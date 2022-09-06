//
//  JHConnetcMicDetailView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHConnetcMicDetailView.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "UIImage+GIF.h"
#import "HKClipperHelper.h"
#import "EnlargedImage.h"
#import "UIImage+JHColor.h"
#import "SDCycleScrollView.h"
#import "JHPageControl.h"
#import "GKPhotoBrowser.h"
#import "JHLiveUserStatus.h"
#import <QBImagePickerController/QBImagePickerController.h>
@interface JHConnetcMicDetailView()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,SDCycleScrollViewDelegate>
{
  
    UIImageView *photoImageView;
    
}
@property (nonatomic, strong) UIView *bar;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *anchorAvatar;
@property (nonatomic, strong) UIImageView *audienceAvatar;

@property (nonatomic, strong) UILabel *waitingNumLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong)  UIImageView * cameraBackImage;
@property (nonatomic, strong) UIButton *sureButton;
@property(nonatomic,copy)completeBlock completeClick;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)JHPageControl *pageControl;
@end

@implementation JHConnetcMicDetailView

- (instancetype)initWithFrame:(CGRect)frame anchorLiveType:(NSInteger)type
{
    if (self = [super initWithFrame:frame]) {
        
        _bar = [[UIView alloc] init];
        _bar.frame = CGRectMake(0,0,self.frame.size.width,336);
        _bar.backgroundColor = [UIColor whiteColor];
        _bar.layer.cornerRadius = 10;
        _bar.userInteractionEnabled=YES;
        [self addSubview:_bar];
        
        _audienceAvatar = [[UIImageView alloc] init];
        _audienceAvatar.layer.masksToBounds =YES;
        _audienceAvatar.layer.cornerRadius =30;
        _audienceAvatar.layer.borderColor = [kColorMain colorWithAlphaComponent:1].CGColor;
        _audienceAvatar.layer.borderWidth = 1;
        [_bar addSubview:_audienceAvatar];
        _audienceAvatar.image=kDefaultAvatarImage;
        [_audienceAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bar).offset(-30);
            make.centerX.equalTo(_bar);
            make.height.width.equalTo(@60);
            
        }];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor =[CommHelp toUIColorByStr:@"#333333"];
        _nameLabel.text=@"";
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
        [_bar addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bar);
            make.top.equalTo(_audienceAvatar.mas_bottom).offset(10);
        }];
        
//        photoImageView = [[UIImageView alloc] init];
//        photoImageView.layer.masksToBounds =YES;
//        photoImageView.layer.cornerRadius =8;
//        [_bar addSubview:photoImageView];
//        photoImageView.clipsToBounds=YES;
//         photoImageView.contentMode=UIViewContentModeScaleAspectFill;
//        [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
//            make.centerX.equalTo(_bar);
//            make.width.equalTo(@345);
//            make.height.equalTo(@194);
//
//        }];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView. infiniteLoop = NO;
        _cycleScrollView.layer.cornerRadius = 4;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [_bar addSubview:_cycleScrollView];
        
        [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(_bar);
            make.width.equalTo(@345);
            make.height.equalTo(@194);
        }];
        
        [_bar addSubview:self.pageControl];
        
//        photoImageView.userInteractionEnabled=YES;
//        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
//        [photoImageView addGestureRecognizer:tapGesture];
        
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_sureButton setBackgroundImage:[UIImage imageNamed:@"audience_no_auth"] forState:UIControlStateNormal ];
        [_sureButton setBackgroundColor:[UIColor whiteColor]];
        _sureButton.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
               _sureButton.layer.borderWidth = 0.5f;
         _sureButton.layer.cornerRadius = 15;
        if (type == JHAnchorLiveAppraiseType)
        {
            [_sureButton setTitle:@"无法鉴定" forState:UIControlStateNormal];
        }
        else  if (type == JHAnchorLiveCustomizeType)
        {
            [_sureButton setTitle:@"无法定制" forState:UIControlStateNormal];
        }
        else  if (type == JHAnchorLiveRecycleType)
        {
            [_sureButton setTitle:@"无法连麦" forState:UIControlStateNormal];
        }
        
        _sureButton.titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
        [_sureButton setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        _sureButton.contentMode=UIViewContentModeScaleAspectFit;
        [_sureButton addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_sureButton];
        
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bar.mas_right).offset(-_bar.frame.size.width/2-10);
            make.top.equalTo(_cycleScrollView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(82, 30));
        }];
        
        UIButton  *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cancleButton setBackgroundImage:[UIImage imageNamed:@"connect_press"] forState:UIControlStateNormal ];
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(82, 30) radius:15];
        [cancleButton setBackgroundImage:nor_image forState:UIControlStateNormal];
        [cancleButton setTitle:@"关闭" forState:UIControlStateNormal];
         cancleButton.titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
        [cancleButton setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        cancleButton.contentMode=UIViewContentModeScaleAspectFit;
        [cancleButton addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:cancleButton];
        
        [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(_bar).offset(_bar.frame.size.width/2+10);
             make.top.equalTo(_sureButton).offset(0);
              make.size.mas_equalTo(CGSizeMake(82, 30));
            
        }];
        
      [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        
        //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //            [window addSubview:self];
        
    }
    return self;
}
- (JHPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, 245 , ScreenW, 4)];
        _pageControl.numberOfPages = 0; //点的总个数
        _pageControl.pointSize = 4;
        _pageControl.otherMultiple = 1; //其他点w是h的倍数(圆点)
        _pageControl.currentMultiple = 3; //选中点的宽度是高度的倍数(设置长条形状)
        _pageControl.pageControlAlignment = JHPageControlAlignmentMiddle; //居中显示
        _pageControl.otherColor = kColorEEE; //非选中点的颜色
        _pageControl.currentColor = kColorMain; //选中点的颜色
        _pageControl.numberOfPages = 0;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
//0, // 鉴定主播 9, //定制主播
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame anchorLiveType:0];
}

-(void)refuse:(UIButton*)sender{
    
    if (self.connector.state==NTESLiveMicStateWait) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"已发起连麦申请,请等待" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(refuseAppraisal:)]) {
        [self.delegate refuseAppraisal:self.connector];
    }
     [self dismiss];
}
- (void)onTapBackground:(UIButton *)button
{
    [self dismiss];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    [self.pageControl setCurrentPage:index];
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSMutableArray *photoList = [NSMutableArray new];
    [self.connector.imgList enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:url];
       // photo.sourceImageView = index; //用同一个source
        [photoList addObject:photo];
    }];
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES; //开始时不隐藏状态栏，不然会有页面跳动问题
    browser.isScreenRotateDisabled = YES; //禁止横屏监测
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:[JHRootController currentViewController]];
  
    return;;
//    if (!self.connector||!photoImageView.image) {
//        return;
//    }
//    if (!IS_ARRAY(self.connector.imgList)) {
//        return;
//    }
//    if ([self.connector.imgList count]==0) {
//        return;
//    }
    UIImageView * imageview=[UIImageView new];
    NSMutableArray * arr=[NSMutableArray arrayWithArray:self.connector.imgList];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
        
    }]; //使用
    
}

-(void)imageViewTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (!self.connector||!photoImageView.image) {
        return;
    }
    if (!IS_ARRAY(self.connector.imgList)) {
        return;
    }
    if ([self.connector.imgList count]==0) {
        return;
    }
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr=[NSMutableArray arrayWithArray:self.connector.imgList];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
        
    }]; //使用
}
- (void)show
{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)withCompleteClick:(completeBlock)block{
    
    self.completeClick = block;
}

-(void)setConnector:(NTESMicConnector *)connector{
    
    _connector=connector;
    [_audienceAvatar jhSetImageWithURL:[NSURL URLWithString:connector.avatar] placeholder:nil];
     _nameLabel.text=connector.nick;
//        [photoImageView jhSetImageWithURL:[NSURL URLWithString:SAFE_OBJECTATINDEX(, 0)] placeholder:kDefaultCoverImage];
//    NSMutableArray *urls = [NSMutableArray array];
//    for (BannerCustomerModel *model in _bannerArray) {
//        [urls addObject:model.image];
//    }
    self.cycleScrollView.imageURLStringsGroup = connector.imgList;
    
    if (connector.imgList.count <= 1) {
        
        [_pageControl setHidden:YES];
    }
    else{
        [_pageControl setHidden:NO];
        self.pageControl.numberOfPages = connector.imgList.count;
        [self.pageControl setCurrentPage:0];
    }
    
  
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bar.bottom = self.height;
    
}
- (void)dealloc
{
    
    
}
@end

