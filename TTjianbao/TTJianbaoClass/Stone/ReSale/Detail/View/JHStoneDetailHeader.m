//
//  JHStoneDetailHeader.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailHeader.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>

@interface JHStoneDetailHeader () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger totalImgCount; //记录图片总数（减去视频）

@property (nonatomic, assign) NSInteger imgIndex;
@property (nonatomic, assign) NSInteger videoIndex;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIScrollView *pageView;
@property (nonatomic, strong) UILabel *pageNumLabel;
//@property (nonatomic, strong) UIImageView *playIcon;
@property (nonatomic, strong) NSMutableArray *photoViews;
@property (nonatomic, strong) NSMutableArray<CAttachmentListData *> *photoUrls;


@end


@implementation JHStoneDetailHeader

- (void)dealloc
{
    NSLog(@"🔥");
}

#pragma mark ---------------------------- init ----------------------------
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _photoViews = [NSMutableArray new];
        _photoUrls = [NSMutableArray new];
        _imgIndex = -1;
        _videoIndex = -1;
        
        _pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kStoneDetailHeaderH)];
        [_pageView setBackgroundColor:[UIColor whiteColor]];
        [_pageView setBounces:YES];
        [_pageView setPagingEnabled:YES];
        [_pageView setShowsHorizontalScrollIndicator:NO];
        [_pageView setDelegate:self];
        [self addSubview:_pageView];
        
        _pageNumLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:10] textColor:[UIColor whiteColor]];
        _pageNumLabel.backgroundColor = HEXCOLORA(0x333333, 0.5);
        _pageNumLabel.textAlignment = NSTextAlignmentCenter;
        _pageNumLabel.clipsToBounds = YES;
        _pageNumLabel.sd_cornerRadiusFromHeightRatio = @0.5;
        [self addSubview:_pageNumLabel];
        _pageNumLabel.sd_layout.rightSpaceToView(self, 15).bottomSpaceToView(self, 15).widthIs(35).heightIs(20);
    }
    return self;
}

#pragma mark ---------------------------- set ----------------------------
- (void)setDataList:(NSMutableArray<CAttachmentListData *> *)dataList {
    if (!dataList) {
        return;
    }
    _dataList = dataList.mutableCopy;
    _totalImgCount = dataList.count;
    [_pageView setContentSize:CGSizeMake(ScreenWidth * dataList.count, kStoneDetailHeaderH)];
    // 添加在滚动视图上的多张图片
    for (NSInteger i = 0; i < dataList.count; i++) {
        
        UITapImageView *imgView = [[UITapImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, kStoneDetailHeaderH)];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_pageView addSubview:imgView];

        CAttachmentListData *imgInfo = dataList[i];
        NSString *urlStr = imgInfo.coverUrl;
        [imgView jhSetImageWithURL:[NSURL URLWithString:urlStr] placeholder:kDefaultCoverImage];
        
        if (imgInfo.attachmentType == 1) { //附件类型：0-未定义，1-图片，2-视频
            [_photoViews addObject:imgView];
            [_photoUrls addObject:imgInfo];
            _imgIndex = ((_imgIndex == -1) ? i : _imgIndex);
        }

        // 如果是视频，添加播放按钮
        if (imgInfo.attachmentType == 2) { //资源类型 [1 图片 , 2 视频]
            self.mPlayIcon = [UIImageView jh_imageViewWithImage:@"stone_detail_video_play" addToSuperview:imgView];
            self.mPlayIcon.sd_layout.centerXEqualToView(imgView).centerYEqualToView(imgView)
            .widthIs(47).heightEqualToWidth();
            
            if (i == 0) {
                _pageNumLabel.hidden = YES;
            }
            _totalImgCount--;
            _videoIndex = ((_videoIndex == -1) ? i : _videoIndex);
        }
        
        if (_totalImgCount <= 1) {
            _pageNumLabel.hidden = YES;
        }
        
        @weakify(self);
        [imgView addTapBlock:^(UITapImageView * _Nonnull obj) {
            @strongify(self);
            if (imgInfo.attachmentType == 1) {
                [self showPhotoBrowserWithIndex:[self.photoViews indexOfObject:obj]];
            } else {
                [self playBtnClickedDataInfo:imgInfo playIcon:self.mPlayIcon videoContainer:obj];
            }
        }];
        
        if(imgInfo.attachmentType == 2 && _autoPlay && i == 0)
        {
            if (self.playClickVideoBlock) {
                self.mPlayIcon.hidden = YES;
                self.playClickVideoBlock(imgInfo, imgView);
            }
        }
    }
    
    if (_videoIndex > -1 && _imgIndex > -1) {
        _imageButton = [UIButton jh_buttonWithTitle:@"图片" fontSize:10 textColor:RGB(51, 51, 51) target:self action:@selector(scrollToImageMethod) addToSuperView:self];
        [_imageButton jh_cornerRadius:10.f];
        _imageButton.backgroundColor = UIColor.whiteColor;
        [_imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-18.f);
            make.left.equalTo(self.mas_centerX).offset(2.5);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        
        _videoButton= [UIButton jh_buttonWithTitle:@"视频" fontSize:10 textColor:RGB(51, 51, 51) target:self action:@selector(scrollToVideoMethod) addToSuperView:self];
        [_videoButton jh_cornerRadius:10.f];
        _videoButton.backgroundColor = RGB(254, 225, 0);
        [_videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.height.width.equalTo(self.imageButton);
            make.right.equalTo(self.mas_centerX).offset(-2.5);
        }];
    }
    //静音按钮 去掉
//    if(_videoIndex > -1)
//    {
//        _muteButton = [UIButton jh_buttonWithImage:@"stone_video_mute_1" target:self action:@selector(muteMethod:) addToSuperView:self];
//        [_muteButton setImage:JHImageNamed(@"stone_video_mute_0") forState:UIControlStateSelected];
//        [_muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//            make.right.equalTo(self);
//            make.centerY.equalTo(self.pageNumLabel);
//        }];
//    }
    
    _pageNumLabel.text = [NSString stringWithFormat:@"%d/%ld", 1, (long)_totalImgCount];
}

#pragma mark ---------------------------- action ----------------------------
- (void)showPhotoBrowserWithIndex:(NSInteger)index {
    NSMutableArray *photoList = [NSMutableArray new];
    [_photoUrls enumerateObjectsUsingBlock:^(CAttachmentListData * _Nonnull data, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:data.originUrl];
        photo.sourceImageView = _photoViews[index]; //用同一个source
        [photoList addObject:photo];
    }];
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES; //开始时不隐藏状态栏，不然会有页面跳动问题
    browser.isScreenRotateDisabled = YES; //禁止横屏监测
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:[JHRootController currentViewController]];
}

- (void)playBtnClickedDataInfo:(CAttachmentListData *)data playIcon:(UIImageView *)playIcon videoContainer:(UITapImageView *)videoContainer {
    
    self.mPlayIcon = playIcon;
    if (self.playClickVideoBlock) {
        self.mPlayIcon.hidden = YES;
        self.playClickVideoBlock(data, videoContainer);
    }
}

- (void)endPlay {
    self.mPlayIcon.hidden = NO;
}

- (void)muteMethod:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isMute = sender.selected;
    
    if(_muteBlock)
    {
        _muteBlock();
    }
}
-(void)scrollToImageMethod
{
    [self scrollToIsVideo:NO];
    [self.pageView setContentOffset:CGPointMake(ScreenW * _imgIndex, 0) animated:YES];
}

-(void)scrollToVideoMethod
{
    [self scrollToIsVideo:YES];
    [self.pageView setContentOffset:CGPointMake(ScreenW * _videoIndex, 0) animated:YES];
}

-(void)scrollToIsVideo:(BOOL)isVideo
{
    if (isVideo) {
        _videoButton.backgroundColor = RGB(254, 225, 0);
        _imageButton.backgroundColor = UIColor.whiteColor;
    }
    else{
        _videoButton.backgroundColor = UIColor.whiteColor;
        _imageButton.backgroundColor = RGB(254, 225, 0);
    }
}
#pragma mark ---------------------------- delegate ----------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    NSInteger curIndex = scrollview.contentOffset.x / scrollview.frame.size.width;
    NSInteger videoCount = self.dataList.count - self.totalImgCount;
    CAttachmentListData *imgInfo = _dataList[curIndex];
    _muteButton.hidden = (imgInfo.attachmentType != 2);
    if (_videoIndex > -1 && _imgIndex > -1) {
        [self scrollToIsVideo:(imgInfo.attachmentType == 2)];
    }
    _pageNumLabel.hidden = (imgInfo.attachmentType == 2 || _totalImgCount <= 1);
    
    
    _pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(curIndex - videoCount + 1), (long)_totalImgCount];
    
    if (self.didEndScrollingBlock) {
        self.didEndScrollingBlock(curIndex < videoCount);
    }
}
@end

