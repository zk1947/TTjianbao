//
//  JHGoodsDetailCustomizeHeaderCycleView.m
//  TTjianbao
//
//  Created by user on 2020/12/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailCustomizeHeaderCycleView.h"
#import "JHEasyPollLabel.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "JHPhotoBrowserManager.h"

@interface JHGoodsDetailCustomizeHeaderCycleView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *pageView;
@property (nonatomic, strong) UILabel *pageNumLabel;
@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) NSInteger totalImgCount; //记录图片总数（减去视频）
@property (nonatomic, assign) BOOL hasVideo; //是否存在视频

//轮询显示label信息
@property (nonatomic, strong) JHEasyPollLabel *pollView;

@property (nonatomic, strong) NSMutableArray *photoViews;

@property (nonatomic, assign) NSInteger imgIndex;
@property (nonatomic, assign) NSInteger videoIndex;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *videoButton;


@end

@implementation JHGoodsDetailCustomizeHeaderCycleView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _photoViews = [NSMutableArray new];
        _photoUrls = [NSMutableArray new];
        _imgIndex = -1;
        _videoIndex = -1;
        
        _pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kCycleViewH)];
        [_pageView setBackgroundColor:[UIColor whiteColor]];
        [_pageView setBounces:YES];
        [_pageView setPagingEnabled:YES];
        [_pageView setShowsHorizontalScrollIndicator:NO];
        [_pageView setDelegate:self];
        [self addSubview:_pageView];
        
        _pageNumLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10] textColor:[UIColor whiteColor]];
        _pageNumLabel.backgroundColor = HEXCOLORA(0x333333, .5f);
        _pageNumLabel.textAlignment = NSTextAlignmentCenter;
        _pageNumLabel.clipsToBounds = YES;
        _pageNumLabel.sd_cornerRadiusFromHeightRatio = @0.5;
        [self addSubview:_pageNumLabel];
        _pageNumLabel.sd_layout.rightSpaceToView(self, 15).bottomSpaceToView(self, 15).widthIs(35).heightIs(20);
    }
    return self;
}

- (void)setHeadImgList:(NSArray<CGoodsImgInfo *> *)headImgList {
    if (!headImgList) {
        _pageNumLabel.hidden = YES;
        [_photoViews removeAllObjects];
        [_photoUrls removeAllObjects];
        return;
    }
    _pageNumLabel.hidden = NO;
    _hasVideo = NO;
    _headImgList = headImgList.copy;
    _totalImgCount = headImgList.count;
    [_pageView setContentSize:CGSizeMake(ScreenWidth * headImgList.count, kCycleViewH)];
    
    // 添加在滚动视图上的多张图片
    for (NSInteger i = 0; i < headImgList.count; i++) {
        UITapImageView *imgView = [[UITapImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, kCycleViewH)];
        if (!self.noNeedAspectFill) {
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
        } else {
            imgView.contentMode = UIViewContentModeScaleAspectFit;
        }
        [_pageView addSubview:imgView];
        
        CGoodsImgInfo *imgInfo = headImgList[i];
        
        NSString *oriUrlStr = [imgInfo.orig_image isNotBlank] ? imgInfo.orig_image : imgInfo.url;
        
        NSString *urlStr = [imgInfo.url isNotBlank] ? imgInfo.url : imgInfo.orig_image;
        
        [imgView jhSetImageWithURL:[NSURL URLWithString:urlStr] placeholder:kDefaultCoverImage];
        
        if (imgInfo.type == 0) { //资源类型 [0 图片 , 1 视频]
            [_photoViews addObject:imgView];
            [_photoUrls addObject:oriUrlStr];
            _imgIndex = ((_imgIndex == -1) ? i : _imgIndex);
        }
        
        // 如果是视频，添加播放按钮
        if (imgInfo.type == 1) { //资源类型 [0 图片 , 1 视频]
            [_pageView addSubview:self.playBtn];
            self.playBtn.sd_layout.centerXEqualToView(imgView).centerYEqualToView(imgView)
            .widthIs(100).heightEqualToWidth();
            
            //将视频信息返回给控制层
            if (self.hasVideoBlock) {
                self.hasVideoBlock(imgInfo, imgView);
            }
            if (i == 0) {
                _pageNumLabel.hidden = YES;
            }
            _totalImgCount--;
            _hasVideo = YES;
            _videoIndex = ((_videoIndex == -1) ? i : _videoIndex);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self playBtnClicked];
            });
        } else {
//            _hasVideo = NO;
        }
        
        if (_totalImgCount <= 1) {
            _pageNumLabel.hidden = YES;
        }
        
        @weakify(self);
        [imgView addTapBlock:^(UITapImageView * _Nonnull obj) {
            @strongify(self);
            if (imgInfo.type == 0) {
                [self showPhotoBrowserWithIndex:[self.photoViews indexOfObject:obj]];
                
            } else {
                [self playBtnClicked];
            }
        }];
    }
    
    if (_hasVideo) {
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
            _imageButton.hidden = NO;
            _videoButton.hidden = NO;
        }
    } else {
        _imageButton.hidden = YES;
        _videoButton.hidden = YES;
    }
    
    _pageNumLabel.text = [NSString stringWithFormat:@"%d/%ld", 1, (long)_totalImgCount];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    _curIndex = scrollview.contentOffset.x / scrollview.frame.size.width;
    
    CGoodsImgInfo *imgInfo = _headImgList[_curIndex];
    _pageNumLabel.hidden = (imgInfo.type == 1 || _totalImgCount <= 1);
    
    if (_hasVideo) {
        _pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_curIndex, (long)_totalImgCount];
    } else {
        _pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_curIndex+1, (long)_totalImgCount];
    }
    
    if (self.cycleScrollEndDeceleratingBlock) {
        self.cycleScrollEndDeceleratingBlock(_curIndex == 0);
    }
    if (_videoIndex > -1 && _imgIndex > -1) {
        [self scrollToIsVideo:(imgInfo.type == 1)];
    }
}

//查看大图
- (void)showPhotoBrowserWithIndex:(NSInteger)index {
    if (!self.canLookOriginImg) {
        NSMutableArray *photoList = [NSMutableArray new];
        [_photoUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
            GKPhoto *photo = [GKPhoto new];
            photo.url = [NSURL URLWithString:url];
            photo.sourceImageView = _photoViews[index]; //用同一个source
            [photoList addObject:photo];
        }];
        
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
        browser.isStatusBarShow = YES; //开始时不隐藏状态栏，不然会有页面跳动问题
        browser.isScreenRotateDisabled = YES; //禁止横屏监测
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
        [browser showFromVC:[JHRootController currentViewController]];
    } else {
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.mediumArr mediumImages:self.mediumArr origImages:self.originArr sources:nil currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom hideDownload:YES];
    }
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:[UIImage imageNamed:@"icon_video_play"] forState:UIControlStateNormal];
        _playBtn.userInteractionEnabled = YES;
        [_playBtn addTarget:self action:@selector(playBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)playBtnClicked {
    NSLog(@"点击播放");
    if (self.playClickBlock) {
        self.playBtn.hidden = YES;
        self.playClickBlock();
    }
}

- (void)setIsPlayEnd:(BOOL)isPlayEnd {
    _isPlayEnd = isPlayEnd;
    self.playBtn.hidden = !isPlayEnd;
}


#pragma mark -
#pragma mark - 文本弹幕

- (void)setPayMsgList:(NSArray *)payMsgList {
    if (payMsgList.count == 0) {
        return;
    }
    _payMsgList = payMsgList;
    
    if (!_pollView) {
        _pollView = [[JHEasyPollLabel alloc] initWithFrame:CGRectMake(15, UI.statusAndNavBarHeight + 13, self.width-30, 31)];
        [self addSubview:_pollView];
    }
    _pollView.msgArray = _payMsgList;
}

#pragma mark --------------- 图片视频 ---------------
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

@end

