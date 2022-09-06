//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVideoCropFrameView.h"
#import "JHVideoCropFrameModel.h"
#import "SDVideoCropFrameCell.h"
#import "UIView+Extension.h"

#define ViewTopOrBottomEdgeDistance (20.0f)
#define FrameItemLeftOrRightDistance (50.0f)
#define LeftOrRightDragViewWidth (12.0f)
#define FrameBaseItemHeight (60.0f)
#define FrameBaseItemWidth (FrameBaseItemHeight/ 1920.0f * 1080)

typedef enum : NSUInteger {
    DragViewTypeNone,
    DragViewTypeLeftView,
    DragViewTypeRightView,
    DragViewTypeProgressView,
} DragViewType;


@interface JHVideoCropFrameView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *frameCollectionView;
@property(nonatomic,strong)UIImageView *leftSelectView;
@property(nonatomic,strong)UIImageView *rightSelectView;
@property(nonatomic,strong)UIView *progressView;

@property(nonatomic,strong)JHVideoCropDataManager *dataManager;

@property(nonatomic,strong)NSMutableArray *frameArray;
@property(nonatomic,strong)AVAssetImageGenerator *imageGenerator;
@property(nonatomic,strong)NSMutableDictionary *allImageDictionary;

@property(nonatomic,assign)CMTimeRange screenTotalTimeRange; // 当前屏幕表示的时间间隔,会直接影响到间隔时间
@property(nonatomic,assign)CMTime intervalTime; // 间隔时间,也是累加时间
@property(nonatomic,assign)CGFloat secondTimeWidth; // 一秒的宽度

@property(nonatomic,assign)DragViewType currentDragViewType; // 当前拖拽视图的类型
@property(nonatomic,assign)CGPoint lastTouchPoint;
@property(nonatomic,assign)BOOL userIsSeeking; //用户正在拖拽,包括拖拽所有边距,拖拽滚动视图,拖拽进度条三种.
@property(nonatomic,copy)NSValue *changePlayTimeRange;

@end

@implementation JHVideoCropFrameView

- (instancetype)initWithFrame:(CGRect)frame dataManager:(JHVideoCropDataManager *)dataManager {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.frameCollectionView];
        [self addSubview:self.leftSelectView];
        [self addSubview:self.rightSelectView];
        [self addSubview:self.progressView];
        
        UIView *yellowView = [UIView new];
        yellowView.backgroundColor = RGB(254, 225, 0);
        [yellowView jh_cornerRadius:3];
        [self insertSubview:yellowView belowSubview:self.frameCollectionView];
        [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftSelectView);
            make.right.equalTo(self.rightSelectView);
            make.top.equalTo(self.frameCollectionView).offset(-3);
            make.bottom.equalTo(self.frameCollectionView).offset(3);
        }];
        
        self.allImageDictionary = [NSMutableDictionary dictionaryWithCapacity:16];
        self.dataManager = dataManager;
        self.screenTotalTimeRange = dataManager.playTimeRange;
        self.height = self.frameCollectionView.bottom + ViewTopOrBottomEdgeDistance;
        [self addDataObserverAction];
        
        ///初始化最大时间数值范围
        if(self.rightSelectView.centerX - self.leftSelectView.centerX > self.secondTimeWidth * self.dataManager.maxDuration)
        {
            self.dataManager.playTimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(60*self.dataManager.maxDuration, 60));
            
            self.rightSelectView.centerX = self.leftSelectView.centerX + self.secondTimeWidth * self.dataManager.maxDuration;
        }
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)leftSelectView {
    
    if (_leftSelectView == nil) {
        _leftSelectView = [[UIImageView alloc] initWithFrame:CGRectMake(FrameItemLeftOrRightDistance - LeftOrRightDragViewWidth, ViewTopOrBottomEdgeDistance-2, LeftOrRightDragViewWidth, FrameBaseItemHeight+4)];
        _leftSelectView.backgroundColor = RGB(254, 225, 0);
        _leftSelectView.contentMode = UIViewContentModeCenter;
        _leftSelectView.image = JHImageNamed(@"sq_publish_corp_video");
        _leftSelectView.userInteractionEnabled = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_leftSelectView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _leftSelectView.bounds;
        maskLayer.path = maskPath.CGPath;
        _leftSelectView.layer.mask = maskLayer;
    }
    return _leftSelectView;
}

- (UIImageView *)rightSelectView {
    
    if (_rightSelectView == nil) {
        _rightSelectView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - FrameItemLeftOrRightDistance-12, ViewTopOrBottomEdgeDistance-2, LeftOrRightDragViewWidth, FrameBaseItemHeight+4)];
        _rightSelectView.backgroundColor = RGB(254, 225, 0);
        _rightSelectView.contentMode = UIViewContentModeCenter;
        _rightSelectView.userInteractionEnabled = YES;
        _rightSelectView.image = JHImageNamed(@"sq_publish_corp_video");
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_rightSelectView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _rightSelectView.bounds;
        maskLayer.path = maskPath.CGPath;
        _rightSelectView.layer.mask = maskLayer;
    }
    return _rightSelectView;
}

- (UIView *)progressView {
    
    if (_progressView == nil) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(self.leftSelectView.right, ViewTopOrBottomEdgeDistance/2.0, 6, self.height - (ViewTopOrBottomEdgeDistance/2.0 * 2))];
        _progressView.layer.shadowColor = HEXCOLOR(0x000000).CGColor;
        _progressView.layer.shadowOffset = CGSizeMake(0, 0);
        _progressView.layer.shadowRadius = 4.0f;
        _progressView.layer.shadowOpacity = 0.2;
        UIView *progressFrontView = [[UIView alloc] initWithFrame:_progressView.bounds];
        progressFrontView.backgroundColor = [UIColor whiteColor];
        progressFrontView.layer.cornerRadius = _progressView.width/2.0;
        progressFrontView.layer.masksToBounds = YES;
        [_progressView addSubview:progressFrontView];
    }
    return _progressView;
}

- (UICollectionView *)frameCollectionView {
    
    if (_frameCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _frameCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(FrameItemLeftOrRightDistance-10, ViewTopOrBottomEdgeDistance, self.width - 2*(FrameItemLeftOrRightDistance-10), FrameBaseItemHeight) collectionViewLayout:layout];
        _frameCollectionView.backgroundColor = self.backgroundColor;
        _frameCollectionView.showsHorizontalScrollIndicator = NO;
        _frameCollectionView.dataSource = self;
        _frameCollectionView.delegate = self;
        _frameCollectionView.bounces = NO;
        [_frameCollectionView registerClass:[SDVideoCropFrameCell class] forCellWithReuseIdentifier:@"SDVideoCropFrameCell"];
    }
    return _frameCollectionView;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.frameArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *frameVideoArray = self.frameArray[section];
    return frameVideoArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SDVideoCropFrameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SDVideoCropFrameCell" forIndexPath:indexPath];
    NSArray *frameVideoArray = self.frameArray[indexPath.section];
    cell.frameModel = frameVideoArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *frameVideoArray = self.frameArray[indexPath.section];
    JHVideoCropFrameModel *frameModel = frameVideoArray[indexPath.row];
    CGFloat itemSecond = CMTimeGetSeconds(frameModel.duration);
    CGFloat intervalTime = CMTimeGetSeconds(self.intervalTime);
    if (itemSecond != intervalTime) {
        return CGSizeMake(FrameBaseItemWidth * (itemSecond/intervalTime), FrameBaseItemHeight);
    } else {
        return CGSizeMake(FrameBaseItemWidth, FrameBaseItemHeight);
    }
}

#pragma mark - 赋值操作

// 数据总入口,如果需要全部刷新,只需要重置该值即可
- (void)setScreenTotalTimeRange:(CMTimeRange)screenTotalTimeRange {
    
    _screenTotalTimeRange = screenTotalTimeRange;
    // 当前屏幕内容的总宽度
    CGFloat screenContentTotalWidth = self.width - FrameItemLeftOrRightDistance * 2;
    self.secondTimeWidth = screenContentTotalWidth/CMTimeGetSeconds(screenTotalTimeRange.duration);
    // 计算出允许的最大个数
    int itemNumber = screenContentTotalWidth/FrameBaseItemWidth;
    CGFloat surplusWidth = screenContentTotalWidth - FrameBaseItemWidth * itemNumber;
    CGFloat surplusScale = surplusWidth/FrameBaseItemWidth;
    CGFloat videoTotalTime = CMTimeGetSeconds(screenTotalTimeRange.duration);
    CGFloat addSeconde = videoTotalTime/(itemNumber + surplusScale);
    _intervalTime = CMTimeMakeWithSeconds(addSeconde, 600);
    self.frameArray = [NSMutableArray arrayWithCapacity:16];
    CMTime startTime = kCMTimeZero;
    CMTime assetStartTime = kCMTimeZero;
    NSInteger dataIndex = 0;
    
        NSMutableArray *videoFrameArray = [NSMutableArray arrayWithCapacity:16];
    AVAsset *videoAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:self.dataManager.outPath]];
        while (CMTIME_COMPARE_INLINE(assetStartTime, <, videoAsset.duration)) {
            JHVideoCropFrameModel *frameModel = [[JHVideoCropFrameModel alloc] init];
            frameModel.superAsset = videoAsset;
            frameModel.startTime = startTime;
            frameModel.dataIndex = dataIndex;
            dataIndex ++;
            [videoFrameArray addObject:frameModel];
            CMTime subtractTime = CMTimeSubtract(videoAsset.duration, assetStartTime);
            if (CMTIME_COMPARE_INLINE(subtractTime, <, self.intervalTime)) {
                frameModel.duration = subtractTime;
            } else {
                frameModel.duration = self.intervalTime;
            }
            startTime = CMTimeAdd(startTime, frameModel.duration);
            assetStartTime = CMTimeAdd(assetStartTime, self.intervalTime);
        }
        [self.frameArray addObject:videoFrameArray];
        assetStartTime = kCMTimeZero;
        dataIndex = 0;
    
    [self.frameCollectionView reloadData];
    [self loadAllFrameImageAction];
}

// 加载帧图片数据
- (void)loadAllFrameImageAction {
    
    _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.dataManager.playItem.asset];
    _imageGenerator.videoComposition = self.dataManager.playItem.videoComposition;
    _imageGenerator.appliesPreferredTrackTransform = YES;
    _imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    _imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    _imageGenerator.maximumSize = CGSizeMake(FrameBaseItemWidth * 3, FrameBaseItemHeight * 3);
    
    for (int i = 0; i < self.frameArray.count; i++) {
        NSArray *frameVideoArray = self.frameArray[i];
        for (JHVideoCropFrameModel *dataModel in frameVideoArray) {
            if (self.allImageDictionary[[NSValue valueWithCMTime:dataModel.startTime]] == nil) {
                CGImageRef cgImage = [_imageGenerator copyCGImageAtTime:dataModel.startTime actualTime:NULL error:nil];
                dataModel.frameImage = [UIImage imageWithCGImage:cgImage];
                [self.allImageDictionary setObject:dataModel.frameImage forKey:[NSValue valueWithCMTime:dataModel.startTime]];
                CGImageRelease(cgImage);
            } else {
                dataModel.frameImage = self.allImageDictionary[[NSValue valueWithCMTime:dataModel.startTime]];
            }
            [self.frameCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:dataModel.dataIndex inSection:i]]];
        }
    }

}

// 安全设置进度条的X位置
- (void)setProgressViewStartX:(CGFloat)startX {
    
    if (startX < self.leftSelectView.right) {
        startX = self.leftSelectView.right;
    }
    if (startX > self.rightSelectView.left - self.progressView.width) {
        startX = self.rightSelectView.left - self.progressView.width;
    }
    self.progressView.sh_x = startX;
}

#pragma mark - 拖拽事件

// 根据拖拽的不同控件改变视频的时间,包括进度,选中时长等
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    self.changePlayTimeRange = [NSValue valueWithCMTimeRange:self.dataManager.playTimeRange];
    self.currentDragViewType = DragViewTypeNone;
    if (CGRectContainsPoint(self.leftSelectView.frame,touchPoint)) {
        self.currentDragViewType = DragViewTypeLeftView;
        self.lastTouchPoint = touchPoint;
        goto delegateAction;
    }
    if (CGRectContainsPoint(self.rightSelectView.frame,touchPoint)) {
        self.currentDragViewType = DragViewTypeRightView;
        self.lastTouchPoint = touchPoint;
        goto delegateAction;

    }
    if (CGRectContainsPoint(self.progressView.frame,touchPoint)) {
        self.currentDragViewType = DragViewTypeProgressView;
        self.lastTouchPoint = touchPoint;
        goto delegateAction;
    }
    delegateAction:{
        self.userIsSeeking = YES;
        if (_delegate != nil && [_delegate respondsToSelector:@selector(userStartChangeVideoTimeRangeAction)]) {
            [_delegate userStartChangeVideoTimeRangeAction];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.currentDragViewType == DragViewTypeNone) {
        return;
    }
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGFloat totalVideoWidth = self.width - FrameItemLeftOrRightDistance * 2;
    CGFloat leftViewMinCenterX = FrameItemLeftOrRightDistance - LeftOrRightDragViewWidth/2.0;
    CGFloat rightViewMaxCenterX = self.width - FrameItemLeftOrRightDistance + LeftOrRightDragViewWidth/2.0 -12;
    
    // 判断方向
    switch (self.currentDragViewType) {
        case DragViewTypeLeftView:{
            // 左边视图影响开始时间,最小不能小于kCMTimeZero
            if (touchPoint.x < leftViewMinCenterX) {
                self.leftSelectView.centerX = leftViewMinCenterX;
            } else {
                // 处理最小时长问题
                if (self.rightSelectView.centerX - touchPoint.x < self.secondTimeWidth * self.dataManager.minDuration) {
                    if(self.rightSelectView.centerX >= rightViewMaxCenterX)
                    {
                        self.rightSelectView.centerX = rightViewMaxCenterX;
                        touchPoint = CGPointMake(self.rightSelectView.centerX - self.secondTimeWidth * self.dataManager.minDuration, touchPoint.y);
                    }
                    else
                    {
                        self.rightSelectView.centerX = touchPoint.x + self.secondTimeWidth * self.dataManager.minDuration;
                    }
                }
                else if(self.rightSelectView.centerX - touchPoint.x > self.secondTimeWidth * self.dataManager.maxDuration)
                {
                    self.rightSelectView.centerX = touchPoint.x + self.secondTimeWidth * self.dataManager.maxDuration;
                }
                self.leftSelectView.centerX = touchPoint.x;
                
                CGFloat leftRatio = (touchPoint.x - leftViewMinCenterX)/totalVideoWidth;
                CGFloat durationRatio = (self.rightSelectView.centerX - touchPoint.x)/totalVideoWidth;
                
                CMTime subDuration = CMTimeMultiplyByFloat64(self.screenTotalTimeRange.duration, durationRatio);
                CMTime startTime = CMTimeMultiplyByFloat64(self.screenTotalTimeRange.duration, leftRatio);
                
                CMTimeRange subTimeRange = CMTimeRangeMake(startTime, subDuration);
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userChangeVideoTimeRangeAction)]) {
                    self.changePlayTimeRange = [NSValue valueWithCMTimeRange:subTimeRange];
                    self.dataManager.currentPlayTime = subTimeRange.start;
                    [self.delegate userChangeVideoTimeRangeAction];
                }
            }
            [self setProgressViewStartX:self.leftSelectView.right];
            break;
        }
        case DragViewTypeRightView:{
            // 右边视图影响播放时长,最大不能大于视频的duration
            if (touchPoint.x > rightViewMaxCenterX) {
                self.rightSelectView.centerX = rightViewMaxCenterX;
            } else {
                // 处理最小时长问题
                if (touchPoint.x - self.leftSelectView.centerX  < self.secondTimeWidth * self.dataManager.minDuration) {
                    if(self.leftSelectView.centerX <= leftViewMinCenterX)
                    {
                        self.leftSelectView.centerX = leftViewMinCenterX;
                        touchPoint = CGPointMake(self.leftSelectView.centerX + self.secondTimeWidth * self.dataManager.minDuration, touchPoint.y);
                    }
                    else
                    {
                        self.leftSelectView.centerX = touchPoint.x - self.secondTimeWidth * self.dataManager.minDuration;
                    }
                }
                else if(touchPoint.x - self.leftSelectView.centerX > self.secondTimeWidth * self.dataManager.maxDuration)
                {
                    self.leftSelectView.centerX = touchPoint.x - self.secondTimeWidth * self.dataManager.maxDuration;
                }
                
                self.rightSelectView.centerX = touchPoint.x;
                
                CGFloat leftRatio = (self.leftSelectView.centerX - leftViewMinCenterX) / totalVideoWidth;
                CGFloat durationRatio = (touchPoint.x - self.leftSelectView.centerX) / totalVideoWidth;
                
                CMTime subDuration = CMTimeMultiplyByFloat64(self.screenTotalTimeRange.duration, durationRatio);
                CMTime startTime = CMTimeMultiplyByFloat64(self.screenTotalTimeRange.duration, leftRatio);
                
                CMTimeRange subTimeRange = CMTimeRangeMake(startTime, subDuration);
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userChangeVideoTimeRangeAction)]) {
                    self.changePlayTimeRange = [NSValue valueWithCMTimeRange:subTimeRange];
                    self.dataManager.currentPlayTime = CMTimeAdd(subTimeRange.start, subTimeRange.duration);
                    [self.delegate userChangeVideoTimeRangeAction];
                }
            }
            [self setProgressViewStartX:self.rightSelectView.left - self.progressView.width];
            break;
        }
        case DragViewTypeProgressView:{
            
            // 判断进度条是否超过左右边界
            if (touchPoint.x < self.leftSelectView.right + self.progressView.width/2.0) {
                self.progressView.centerX = self.leftSelectView.right + self.progressView.width/2.0;
            } else if (touchPoint.x > self.rightSelectView.left - self.progressView.width/2.0) {
                self.progressView.centerX = self.rightSelectView.left - self.progressView.width/2.0;
            } else {
                self.progressView.centerX = touchPoint.x;
            }
            CGFloat videoProgress = (self.progressView.left - self.leftSelectView.right)/(totalVideoWidth - self.progressView.width);
            CMTime currentTime = CMTimeAdd(self.screenTotalTimeRange.start, CMTimeMultiplyByFloat64(self.screenTotalTimeRange.duration, videoProgress));
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userChangeVideoTimeRangeAction)]) {
                self.dataManager.currentPlayTime = currentTime;
                [self.delegate userChangeVideoTimeRangeAction];
            }
            break;
        }
        default:
            break;
    }
    self.lastTouchPoint = touchPoint;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.userIsSeeking = NO;
    if (self.currentDragViewType == DragViewTypeLeftView || self.currentDragViewType == DragViewTypeRightView) {
        if (!CMTimeRangeEqual(self.dataManager.playTimeRange, [self.changePlayTimeRange CMTimeRangeValue])) {
            self.dataManager.playTimeRange = [self.changePlayTimeRange CMTimeRangeValue];
        }
//        [self reloadTimeRangeActionWithReloadFrameData:YES];
    }
    self.currentDragViewType = DragViewTypeNone;
    if (_delegate != nil && [_delegate respondsToSelector:@selector(userEndChangeVideoTimeRangeAction)]) {
        [_delegate userEndChangeVideoTimeRangeAction];
    }
}

- (void)reloadTimeRangeActionWithReloadFrameData:(BOOL)reloadFrameData {
    if (reloadFrameData) {
        self.screenTotalTimeRange = self.dataManager.playTimeRange;
    } else {
        _screenTotalTimeRange = self.dataManager.playTimeRange;
    }
    CGFloat scale = CMTimeGetSeconds(self.dataManager.playTimeRange.start) / CMTimeGetSeconds(self.dataManager.playTotalTimeRange.duration);
    CGFloat offSetX = scale * self.frameCollectionView.contentSize.width - FrameItemLeftOrRightDistance;
    CGFloat offSetY = 0;
    [self.frameCollectionView setContentOffset:CGPointMake(offSetX, offSetY) animated:NO];
    [UIView animateWithDuration:0.1 animations:^{
        self.leftSelectView.frame = CGRectMake(FrameItemLeftOrRightDistance - LeftOrRightDragViewWidth, ViewTopOrBottomEdgeDistance, LeftOrRightDragViewWidth, 60 + 2 * 2);
        self.rightSelectView.frame = CGRectMake(self.width - FrameItemLeftOrRightDistance, ViewTopOrBottomEdgeDistance, LeftOrRightDragViewWidth, 60 + 2 * 2);
    }];
}

#pragma mark - 滚动监听

// 通过此方法判断是否是用户的操作改变了ScrollView的偏移量
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.userIsSeeking = YES;
    self.currentDragViewType = DragViewTypeNone;
    self.changePlayTimeRange = [NSValue valueWithCMTimeRange:self.dataManager.playTimeRange];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.currentDragViewType != DragViewTypeNone) {
        return;
    }
    CGFloat frameOffX = scrollView.contentOffset.x;
    CGFloat scale = (frameOffX + FrameItemLeftOrRightDistance - 1.0)/scrollView.contentSize.width;
    CMTime startTime = CMTimeMultiplyByFloat64(self.dataManager.playTotalTimeRange.duration, scale);
    CMTimeRange subTimeRange = CMTimeRangeMake(startTime, self.dataManager.playTimeRange.duration);
    self.progressView.left = self.leftSelectView.right;

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userChangeVideoTimeRangeAction)]) {
        self.changePlayTimeRange = [NSValue valueWithCMTimeRange:subTimeRange];
        self.dataManager.currentPlayTime = subTimeRange.start;
        [self.delegate userChangeVideoTimeRangeAction];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.userIsSeeking = NO;
    self.currentDragViewType = DragViewTypeNone;
    self.dataManager.playTimeRange = [self.changePlayTimeRange CMTimeRangeValue];
    [self reloadTimeRangeActionWithReloadFrameData:NO];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(userEndChangeVideoTimeRangeAction)]) {
        [_delegate userEndChangeVideoTimeRangeAction];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        self.userIsSeeking = NO;
        self.currentDragViewType = DragViewTypeNone;
        self.dataManager.playTimeRange = [self.changePlayTimeRange CMTimeRangeValue];
        [self reloadTimeRangeActionWithReloadFrameData:NO];
        if (_delegate != nil && [_delegate respondsToSelector:@selector(userEndChangeVideoTimeRangeAction)]) {
            [_delegate userEndChangeVideoTimeRangeAction];
        }
    }
}

#pragma mark - 数据监听观察

- (void)addDataObserverAction {
    
    [self.dataManager addObserver:self forKeyPath:@"currentPlayTime" options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangeVideoSectionIndexAction:) name:VideoArrayItemExchangeIndexNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAddVideoSectionIndexAction:) name:VideoArrayItemAddNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDeleteVideoSectionIndexAction:) name:VideoArrayItemDeleteIndexNotificationName object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"currentPlayTime"]) {
        if (!self.userIsSeeking) {
            CGFloat currentSecond = CMTimeGetSeconds(self.dataManager.currentPlayTime);
            CGFloat totalSecond = CMTimeGetSeconds(self.screenTotalTimeRange.duration);
            
            CGFloat totalVideoWidth = self.width - FrameItemLeftOrRightDistance * 2;
            CGFloat leftViewMinCenterX = FrameItemLeftOrRightDistance - LeftOrRightDragViewWidth/2.0;
            
            CGFloat startX = (currentSecond / totalSecond) * totalVideoWidth + leftViewMinCenterX;

            [UIView animateWithDuration:CMTimeGetSeconds(self.dataManager.observerTimeSpace) delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self setProgressViewStartX:startX];
            } completion:nil];
        }
    }
}

- (void)userChangeVideoSectionIndexAction:(NSNotification *)notification {
    
    [self.allImageDictionary removeAllObjects];
    self.screenTotalTimeRange = self.dataManager.playTimeRange;
}

- (void)userAddVideoSectionIndexAction:(NSNotification *)notification {
    
    self.screenTotalTimeRange = self.dataManager.playTimeRange;
}

- (void)userDeleteVideoSectionIndexAction:(NSNotification *)notification {
    
    [self.allImageDictionary removeAllObjects];
    self.screenTotalTimeRange = self.dataManager.playTimeRange;
}

#pragma mark - 系统方法

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.dataManager removeObserver:self forKeyPath:@"currentPlayTime"];
}

@end
