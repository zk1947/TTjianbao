//
//  JHAdvertView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/4/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAdvertView.h"
#import "TTjianbaoHeader.h"
#import "NSTimer+Help.h"
#import "TTjianbaoBussiness.h"
#import "UIImageView+WebCache.h"
#import "JHReLayoutButton.h"

@interface JHAdvertView ()
@property (strong, nonatomic)  UIImageView *backImagview;
@property (strong, nonatomic)  UIImageView *logoImagview;
@property (strong, nonatomic)  UIImageView *advretImagview;
@property (strong, nonatomic)  JHReLayoutButton *jumpButton;
@property (strong, nonatomic)  UIButton *completeButton;
@property (strong, nonatomic)  NSTimer  *timer;
@property (strong, nonatomic)  NSMutableArray  *bannerModes;

@property (nonatomic, weak) UIImageView *imageViewBg;

@end

@implementation JHAdvertView

- (void)dealloc
{
    NSLog(@"JHAdvertView dealloc");
    ///隐藏或显示直播浮窗
    [JHRootController.serviceCenter willShowStartLiveButton:YES];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor=[UIColor whiteColor];
        
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"image_start_2021"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewBg = imageView;
        [_imageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.logoImagview];
        
        [self.logoImagview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-UI.bottomSafeAreaHeight - 30);
            make.size.mas_equalTo(CGSizeMake(187, 49));
        }]; 
        
        [self addSubview:self.advretImagview];
        
        [self.advretImagview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(_logoImagview.mas_top).offset(-30);
        }];
        
        [self addSubview:self.completeButton];
        
        
        [self addSubview:self.jumpButton];
        [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(220.f);
            make.height.mas_equalTo(44.f);
            make.bottom.equalTo(self.advretImagview.mas_bottom).offset(-30.f);
        }];
        self.jumpButton.hidden = YES;
        
        @weakify(self);
        __block int num = 2;
        self.timer = [NSTimer jh_scheduledTimerWithTimeInterval:1 repeats:YES block:^{
            @strongify(self);
            [self.completeButton setTitle:[NSString stringWithFormat:@"跳过 %ds",num]forState:UIControlStateNormal];
            if(num == 0)
            {
                [self complete];
            }
            num --;
        }];
        
        
        
        [self requestBanners];
        [JHKeyWindow addSubview:self];
        [JHKeyWindow bringSubviewToFront:self];
    }
    return self;
}

- (void)requestBanners{

    JH_WEAK(self)
    [HttpRequestTool getWithURL:  COMMUNITY_FILE_BASE_STRING(@"/ad/5") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        self.bannerModes = [NSMutableArray array];
        self. bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if ( self.bannerModes.count>0) {
            BannerCustomerModel * mode=  self.bannerModes[0];
            if (isEmpty(mode.startup_text)) {
                self.jumpButton.hidden = YES;
                [self.jumpButton setTitle:@"" forState:UIControlStateNormal];
            } else {
                self.jumpButton.hidden = NO;
                [self.jumpButton setTitle:mode.startup_text forState:UIControlStateNormal];
            }

            [self.advretImagview sd_setImageWithURL:[NSURL URLWithString:mode.image] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                self.imageViewBg.hidden = YES;
                self.logoImagview.hidden = NO;
            }];

        }
   
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

-(UIImageView*)logoImagview{
    
    if (!_logoImagview) {
        _logoImagview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logo_advert"]];
        _logoImagview.contentMode = UIViewContentModeScaleToFill;
        _logoImagview.hidden = false;
    }
    return  _logoImagview;
    
}
-(UIImageView*)backImagview{
    
    if (!_backImagview) {
        
        _backImagview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _backImagview.contentMode = UIViewContentModeScaleToFill;
        CGSize viewSize = [UIScreen mainScreen].bounds.size;
        NSArray * array = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary * dict in array) {
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, viewSize)) {
                _backImagview.image =[UIImage imageNamed: dict[@"UILaunchImageName"]];
            }
        }
    }
    return  _backImagview;
    
}
-(UIImageView*)advretImagview{
    
    if (!_advretImagview) {
        _advretImagview = [[UIImageView alloc] init];
        _advretImagview.contentMode = UIViewContentModeScaleAspectFill;
       // _advretImagview.image = [UIImage imageNamed:@"adver_info"];
        _advretImagview.userInteractionEnabled=YES;
        _advretImagview.layer.masksToBounds=YES;
    }
    return  _advretImagview;
    
}
-(UIButton*)completeButton{
    if (!_completeButton) {
        _completeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-70, UI.statusBarHeight+20, 50, 22)];
        [_completeButton setTitle:@"跳过 3s" forState:UIControlStateNormal];
        _completeButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        _completeButton.layer.cornerRadius = 2;
        _completeButton.alpha=0.8;
        _completeButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        _completeButton.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _completeButton;
}

- (JHReLayoutButton *)jumpButton {
    if (!_jumpButton) {
        _jumpButton = [[JHReLayoutButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW-200.f, 44)];
        _jumpButton.backgroundColor = HEXCOLORA(0x000000,0.5f);
        _jumpButton.layer.cornerRadius = 22;
        _jumpButton.layer.masksToBounds = YES;
        _jumpButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.0f];
        [_jumpButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_jumpButton addTarget:self action:@selector(imageTap:) forControlEvents:UIControlEventTouchUpInside];
        [_jumpButton setImage:[UIImage imageNamed:@"launch_jumpClickIcon"] forState:UIControlStateNormal];
        _jumpButton.layoutType = RelayoutTypeRightLeft;
        _jumpButton.margin = 9.f;
    }
    return _jumpButton;
}

-(void)imageTap:(UIButton*)tap{
    //与JHLiveFromsplashBanner优点重复
    ///启动页广告banner被点击埋点
    [JHGrowingIO trackEventId:JHTrackMarketSaleBannerItemClick from:JHTrackMarketSaleClickSplashBanner];
    [self complete];

    if (self.bannerModes.count>0) {
        ///移除红包/礼物弹窗
//        [JHMaskingManager dismissPopWindow];
        
        BannerCustomerModel *model = self.bannerModes[0];
        [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:JHLiveFromsplashBanner];
        
        NSDictionary *dict = @{
            @"page_position" : @"开屏页",
            @"spm_type" : @"开机屏",
            @"content_url" : model.target.recordComponentName ?: @"",
        };  
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:dict type:JHStatisticsTypeSensors];
    }
}
-(void)complete{

    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (![UserInfoRequestManager sharedInstance].isDeepLinkInto) {
        if (self.block) {
            self.block();
        }
    }
    
}

@end
