//
//  YDMediaCarousel.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDMediaCarousel.h"
#import "YDMediaToolBar.h"
#import "JHPhotoBrowserManager.h"

@interface YDMediaCarousel () <UIScrollViewDelegate, YDMediaToolBarDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) YDMediaToolBar *toolBar; //视频图片切换

@property (nonatomic, strong) UIButton *playBtn; //播放按钮
@property (nonatomic, strong) UILabel *imgIndexLabel; //图片下标Label

@property (nonatomic, assign) BOOL hasVideo; //是否存在视频
@property (nonatomic, assign) NSInteger curIndex; //当前页index

@property (nonatomic, strong) NSMutableArray<NSString *> *photoUrls; //所有图片url（不包含视频）
@property (nonatomic, strong) NSMutableArray<UITapImageView *> *photoViews;//所有图片View（不包含视频）

@end

@implementation YDMediaCarousel

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _photoUrls = [NSMutableArray new];
        _photoViews = [NSMutableArray new];
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _scrollView = [YDMediaCarouselUtil mediaScrollWithDelegate:self];
    _imgIndexLabel = [YDMediaCarouselUtil imageIndexLabel];
    
    _toolBar = [[YDMediaToolBar alloc] initWithFrame:CGRectZero];
    _toolBar.delegate = self;
    
    [self sd_addSubviews:@[_scrollView, _toolBar, _imgIndexLabel]];
    
    //布局
    _toolBar.sd_layout
    .bottomSpaceToView(self, 22)
    .centerXEqualToView(self)
    //.widthIs(90) //内部自适应宽度
    .heightIs(20);
    
    _imgIndexLabel.sd_layout
    .rightSpaceToView(self, 15)
    .bottomSpaceToView(self, 22)
    .widthIs(38).heightIs(20);
    
    _toolBar.hidden = YES;
    _imgIndexLabel.hidden = YES;
}

//添加显示内容视图
- (void)addMediaViewAtIndex:(NSInteger)index {
    UITapImageView *imgView = [YDMediaCarouselUtil mediaImageView];
    [_scrollView addSubview:imgView];
    imgView.sd_layout
    .topEqualToView(_scrollView)
    .leftSpaceToView(_scrollView, kScreenWidth * index)
    .widthIs(kScreenWidth)
    .heightIs(YDMediaCarouselHeight);
    
    YDMediaData *data = _mediaList[index];
    [imgView jhSetImageWithURL:[NSURL URLWithString:data.imageUrl] placeholder:kDefaultCoverImage];
    
    @weakify(self);
    [imgView addTapBlock:^(UITapImageView * _Nonnull obj) {
        if (data.isVideo == 1) {
            @strongify(self);
            [self startPlay];
            
        } else {
            [JHPhotoBrowserManager showPhotoBrowserImages:self.photoUrls sources:self.photoViews currentIndex:[self.photoViews indexOfObject:obj]];
        }
    }];
    
    if (data.isVideo) {
        _hasVideo = YES;
        [_scrollView addSubview:self.playBtn];
        self.playBtn.sd_layout.centerXEqualToView(imgView).centerYEqualToView(imgView).widthIs(100).heightEqualToWidth();
        
        //将视频信息返回给控制层
        if (self.hasVideoBlock) {
            self.hasVideoBlock(data, imgView);
        }
        
    } else {
        [_photoViews addObject:imgView];
        [_photoUrls addObject:data.imageUrl];
    }
}

#pragma mark -
#pragma mark - 数据处理

- (void)setMediaList:(NSMutableArray<YDMediaData *> *)mediaList {
    if (mediaList.count == 0) {
        return;
    }
    [YDMediaCarouselUtil filterMediaList:mediaList];
    _mediaList = mediaList;
    [_scrollView setContentSize:CGSizeMake(kScreenWidth * mediaList.count, YDMediaCarouselHeight)];
    
    for (NSInteger i = 0; i < mediaList.count; i++) {
        [self addMediaViewAtIndex:i];
    }
    
    [self updateToolBar];
    [self updateImgIndex];
    
    //wifi环境自动播放
    if (_hasVideo) {
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            [self startPlay];
        }
    }
}


#pragma mark -
#pragma mark - Action Methods

//播放按钮
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [YDMediaCarouselUtil playButton];
        [_playBtn addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

//开始播放
- (void)startPlay {
    self.playBtn.hidden = YES;
    if (self.startPlayBlock) {
        self.startPlayBlock();
    }
}

//播放结束
- (void)endPlay {
    self.playBtn.hidden = NO;
}

//刷新toolBar <存在视频 & 视频+图片总数大于1时显示toolBar>
- (void)updateToolBar {
    BOOL isHidden = !(_hasVideo && _mediaList.count > 1);
    _toolBar.hidden = isHidden;
    
    if (!isHidden) {
        _toolBar.selectedIndex = (_curIndex == 0 ? 0 : 1);
    }
}

//刷新图片下标
- (void)updateImgIndex {
    if (_hasVideo) { //存在视频
        if (_curIndex == 0) {
            _imgIndexLabel.hidden = YES;
        } else {
            _imgIndexLabel.hidden = (_mediaList.count <= 2);
        }
        _imgIndexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_curIndex, (long)_mediaList.count-1];
        
    } else { //只有图片
        _imgIndexLabel.hidden = (_mediaList.count <= 1);
        _imgIndexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_curIndex+1, (long)_mediaList.count];
    }
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    _curIndex = scrollview.contentOffset.x / scrollview.width;
    [self updateToolBar];
    [self updateImgIndex];
    if (_hasVideo) {
        if (self.didEndScrollBlock) {
            self.didEndScrollBlock(_curIndex == 0);
        }
    }
}

#pragma mark -
#pragma mark - YDMediaToolBarDelegate

- (void)mediaToolBar:(YDMediaToolBar *)toolBar didSelectAtIndex:(NSInteger)index {
    _curIndex = index;
    [self updateImgIndex];
    
    if (index == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        [_scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:NO];
    }
}

@end
