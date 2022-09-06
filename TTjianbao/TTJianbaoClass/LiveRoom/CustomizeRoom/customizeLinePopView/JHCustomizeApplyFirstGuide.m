//
//  JHCustomizeApplyFirstGuide.m
//  TTjianbao
//
//  Created by apple on 2020/11/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeApplyFirstGuide.h"
#import "UIView+CornerRadius.h"
#import "JHWebViewController.h"
#import "UIView+Toast.h"
#import "UIView+JHGradient.h"
#import "JHCustomizeApplyProcessFirst.h"
#import "JHGrowingIO.h"

@interface JHCustomizeApplyFirstGuide ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)  UIButton* sureBtn;
@property(nonatomic,strong) UIView * bar;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UIView * topView;
@property(nonatomic,strong) UIButton * chooseBtn;
@property(nonatomic,strong) UIButton * privacyAgreementBtn;
@property(nonatomic,assign) BOOL isHaveData;
@end

@implementation JHCustomizeApplyFirstGuide
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
        _bar =  [[UIView alloc]init];
        _bar.backgroundColor= HEXCOLOR(0xFFFFFF);
        _bar.userInteractionEnabled = YES;
        _bar.layer.masksToBounds = YES;
        _bar.frame= CGRectMake(0, 0, ScreenW, 560 + UI.bottomSafeAreaHeight);
        [_bar yd_setCornerRadius:12.f corners:UIRectCornerAllCorners];
        [self addSubview:_bar];

        self.topView =  [[UIView alloc] init];
        // topView.frame = CGRectMake(0,0,375,50);
        self.topView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        self.topView.layer.cornerRadius = 0;
        self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        self.topView.layer.shadowOffset = CGSizeMake(0,1);
        self.topView.layer.shadowOpacity = 1;
        self.topView.layer.shadowRadius = 5;
        [_bar addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((_bar)).offset(0);
            make.left.right.equalTo(_bar);
            make.height.offset(50);

        }];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor333;
        _titleLabel.text = @"定制攻略";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.topView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(self.topView);
        }];

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:closeButton];


        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.right.equalTo(self.topView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        JHWebView *webview = [[JHWebView alloc] init];
        [_bar addSubview:webview];
        [webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(399);
        }];
        [webview jh_loadWebURL:H5_BASE_STRING(@"/jianhuo/app/custom/custom_strategy.html")];
        _sureBtn=[[UIButton alloc]init];
        [_sureBtn setTitle:@"申请定制" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = JHFont(15);
        [_sureBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_sureBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        _sureBtn.layer.cornerRadius = 22;
        _sureBtn.clipsToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bar);
            make.bottom.mas_equalTo(_bar).offset(-(10+UI.bottomSafeAreaHeight));
            make.size.mas_equalTo(CGSizeMake(320, 44));
        }];
        [self creatTableFootView];
        [_bar bringSubviewToFront:self.topView];
    }
    return self;
}
- (void)sureClick:(UIButton *)sender{
    if (!self.chooseBtn.selected) {
        [self makeToast:@"您需同意协议才能进行下一步，请先勾选" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_xieyi_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstApplyCustomizeGuide"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.isHaveData) {
        if (self.clickSureBlock) {
            self.clickSureBlock();
        }
    }else{
        JHCustomizeApplyProcessFirst *applyCustomizeView = [[JHCustomizeApplyProcessFirst alloc] initWithFrame:self.bounds andCustomizeId:self.customerId];
        applyCustomizeView.completeBlock = self.completeBlock;
        applyCustomizeView.channelId = self.channelId;
        [self.superview addSubview:applyCustomizeView];
        [applyCustomizeView showAlert];
    }
    
    [self hiddenAlert];
}
- (void)setCustomerId:(NSString *)customerId{
    _customerId = customerId;
    JH_WEAK(self);
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/getMaterialOrders") Parameters:@{@"customerId":customerId,@"channelId":self.channelId}
       successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self);
        if ([respondObject.data isKindOfClass:[NSArray class]] && ((NSArray*)respondObject.data).count>0) {
            self.isHaveData = YES;
        }else{
            self.isHaveData = NO;
        }
    }
    failureBlock:^(RequestModel *respondObject) {

    [self makeToast:respondObject.message];

    }];
}

- (void)creatTableFootView{
    
    UIView *footView = [[UIView alloc] init];
    [_bar addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_sureBtn.mas_top).offset(-10);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(ScreenW, 47));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment = UIControlContentHorizontalAlignmentCenter;
    //[label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = @"确认申请代表您同意";
    label.font=[UIFont systemFontOfSize:11];
    label.textColor = HEXCOLOR(0x999999);
    [footView addSubview:label];
    
    [footView addSubview:self.chooseBtn];
    [footView addSubview:self.privacyAgreementBtn];
    [self.chooseBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [footView addSubview:self.privacyAgreementBtn];
    [label  mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.chooseBtn.mas_right);
       make.centerY.equalTo(footView);
    }];
    
    [self.privacyAgreementBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.centerY.equalTo(footView);
    }];
}
- (UIButton*)chooseBtn{
    
    if (_chooseBtn==nil) {
        
        _chooseBtn = [[UIButton alloc] init];
        _chooseBtn.backgroundColor = [UIColor clearColor];
        [_chooseBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_chooseBtn setImage:[UIImage imageNamed:@"customizeagreeBtn_NO"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"customizeagreeBtn_YES"] forState:UIControlStateSelected];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _chooseBtn.selected=YES;
    }
    
    return _chooseBtn;
}

- (UIButton*)privacyAgreementBtn{
    if (!_privacyAgreementBtn) {
        _privacyAgreementBtn = [[UIButton alloc] init];
        [_privacyAgreementBtn setTitle:@"《定制服务协议》" forState:UIControlStateNormal];
        _privacyAgreementBtn.titleLabel.font = JHFont(12);
        [_privacyAgreementBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
        _privacyAgreementBtn.backgroundColor = [UIColor clearColor];
        [_privacyAgreementBtn addTarget:self action:@selector(privacyAgreeMent:) forControlEvents:UIControlEventTouchUpInside];
    }
      return _privacyAgreementBtn;
}
-(void)chooseBtnClick:(UIButton*)button{
    _chooseBtn.selected = !_chooseBtn.selected;
}
-(void)privacyAgreeMent:(UIButton*)button{
    
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/custom/agreement/agreement.html");
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)showAlert
{
    self.bar.top =  self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom =  self.height;
    }];
}

-(void)hiddenAlert{
   [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
