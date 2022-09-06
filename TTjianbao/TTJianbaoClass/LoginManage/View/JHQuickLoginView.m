//
//  JHQuickLoginView.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHQuickLoginView.h"
#import "JHAntiFraud.h"
#import "LoginMode.h"
#import "STRIAPManager.h"
#import "JHWebViewController.h"
#import "Tracking.h"
#import "LEEAlert.h"
#import "UIImage+JHColor.h"
#import "JHAppealPopWindow.h"
#import "TTjianbao.h"

@interface JHQuickLoginView ()

///是否同意协议
@property (nonatomic, assign) BOOL agreeCheck;
@property (nonatomic, strong) UILabel *otherLogin;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIStackView *wxStackView;
@property (nonatomic, strong) UIStackView *otherPhoneStackView;

@property (nonatomic, strong) UIButton *wxButton;
@property (nonatomic, strong) UIButton *otherPhoneButton;
@end

@implementation JHQuickLoginView

- (void)dismissQuickLoginControllerAnimated:(BOOL)animated {
    [JHGrowingIO trackEventId:@"enter_live_in_onekey_close_click"];
    [JVERIFICATIONService dismissLoginControllerAnimated:animated completion:nil];
}

#pragma mark - 一键登录 流程
/*
 actionBlock 授权页事件触发回调。包含type和content两个参数，type为事件类型，content为事件描述。 type = 1,授权页被关闭;type=2,授权页面被拉起；type=3,运营商协议被点击；type=4,自定义协议1被点击；type=5,自定义协议2被点击；type=6,checkBox变为选中；type=7,checkBox变为未选中；type=8,登录按钮被点击
*/
- (void)quickLoginStartVerfication:(JHSuccess)response
{
    [SVProgressHUD show];
    UIViewController* vc = [JHRootController currentViewController]; //获取当前viewController
    JH_WEAK(self)
    [self verficationWithVC:vc completResult:^(JHJVerficationResult * _Nonnull result) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if ([result.loginToken isNotBlank]) {
            [self verifyLoginToken:result.loginToken];
        }
        //返回result.code
        response(@(result.code));
    } actionBlock:^(NSInteger type, NSString * _Nonnull content) {
        
        self.agreeCheck = (type == 6);///选中协议
        [SVProgressHUD dismiss];
        response(@(type));
    } customViewsBolck:^(UIView * _Nonnull customAreaView) {
        JH_STRONG(self)
        [self createCustomViewWithSuperView:customAreaView];
        UIViewController *vc = [JHRootController currentViewController];
        if ([vc isKindOfClass:[NSClassFromString(@"JVTelecomViewController") class]]){
            vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self closeBtn]];
        }
    } ];
}

/*
completion 登录结果
result 字典 获取到token时key有operator、code、loginToken字段，获取不到token是key为code和content字段
vc 当前控制器
hide 完成后是否自动隐藏授权页。
actionBlock 授权页事件触发回调。包含type和content两个参数，type为事件类型，content为事件描述。 type = 1,授权页被关闭;type=2,授权页面被拉起；type=3,运营商协议被点击；type=4,自定义协议1被点击；type=5,自定义协议2被点击；type=6,checkBox变为选中；type=7,checkBox变为未选中；type=8,登录按钮被点击

*/
- (void)verficationWithVC:(UIViewController *)vc completResult:(void(^)(JHJVerficationResult *result))resultBlock actionBlock:(void(^)(NSInteger type, NSString *content))actionBlock customViewsBolck:(void(^)(UIView *customAreaView))customViewsBlk
{
    [self customUICustomViewsBolck:customViewsBlk];

    [JVERIFICATIONService getAuthorizationWithController:vc hide:NO animated:NO timeout:3000 completion:^(NSDictionary *result) {
            NSLog(@"一键登录getAuthorization-complete-result:%@", result.description);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                JHJVerficationResult *resultModel = [JHJVerficationResult mj_objectWithKeyValues:result];
                if (result) {
                    resultBlock(resultModel);
                }
            });
        } actionBlock:^(NSInteger type, NSString *content) {
            NSLog(@"一键登录getAuthorization-action:%@ %zd", content, type);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (actionBlock) {
                    actionBlock(type, content);
                }
            });
        }];
}

- (void)verifyLoginToken:(NSString *)token
{
    [SVProgressHUD show];
    NSString *sm_deviceId = [JHAntiFraud deviceId];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"invitationCode":@"",
                                                                                       @"loginWay":@"",
                                                                                       @"sm_deviceId":sm_deviceId,
                                                                                         @"token":token
                                                                                       }];
    if (self.params) {
        [parameters addEntriesFromDictionary:self.params];
    }
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/loginOneTouch") Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [self loginSuccessWithResult:respondObject];
        [JHGrowingIO trackPublicEventId:JHClickOneKeyLoginClick paramDict:@{@"success":@"true"}];
        [self trackingEventName:@"loginMethodClick" property:@{@"login_method":@"本机号码一键登录",@"page_position":@"登录页"}];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [self loginFailWithResult:respondObject];
        [JHGrowingIO trackPublicEventId:JHClickOneKeyLoginClick paramDict:@{@"success":@"false"}];
        [self trackingEventName:@"loginMethodClick" property:@{@"login_method":@"本机号码一键登录",@"page_position":@"登录页"}];
    }];
}

- (void)loginFailWithResult:(RequestModel *)respondObject
{
    if (respondObject.code == 1008) { //被封禁
        @weakify(self);
        [[JHAppealPopWindow signAppealpopVindow] show];
        [JHAppealPopWindow signAppealpopVindow].btnClickedBlock = ^{
            @strongify(self);
            [self quickLogintoAppeal:respondObject.data[@"freezeMessage"]];
        };
    } else {
        [self makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }
}

- (void)loginSuccessWithResult:(RequestModel *)respondObject
{
    LoginMode *loginMode = [LoginMode mj_objectWithKeyValues:respondObject.data];
    NSString *Account = loginMode.wyAccount.accid;
    NSString *Token = loginMode.wyAccount.token;
    [JHTracking loginedUserID:loginMode.customerId];
    if (loginMode.isReg) {
        [Tracking setRegisterWithAccountID:loginMode.customerId?:@""];
    }
    [Growing track:@"loginsucceed"];
    JH_WEAK(self)
    [JHRootController loginIM:Account token:Token completion:^(NSError * _Nullable error) {
        JH_STRONG(self)
        if (!error)
        {
            [[NSUserDefaults standardUserDefaults] setObject:loginMode.loginToken forKey:IDTOKEN ];
            [[NSUserDefaults standardUserDefaults] setObject:ONLINE forKey:LOGINSTATUS ];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[UserInfoRequestManager sharedInstance]bindDeviceToken:nil];
            //内购验证
            [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
                [[UserInfoRequestManager sharedInstance] getHomePageActivitylnfoCompletion:nil];
                [ [STRIAPManager shareSIAPManager] veryfyTransaction:nil];
                [self quickLoginResultAction];
                [self quickLoginCloseAll];
                [[NSNotificationCenter defaultCenter] postNotificationName:kAllLoginSuccessNotification object:nil];
            }];
        }
    }];
}

#pragma mark - 一键登录views
- (void)customUICustomViewsBolck:(void(^)(UIView *customAreaView))customViewsBlk
{
    JVUIConfig *config = [[JVUIConfig alloc] init];
//    config.navReturnImg = [UIImage imageNamed:@"login_close"];
    config.agreementNavReturnImage = [UIImage imageNamed:@"navi_icon_back_black"];
    config.autoLayout = YES;
    config.navText = [[NSAttributedString alloc] initWithString:@""];
    config.navDividingLineHidden = YES;
    config.prefersStatusBarHidden = NO;
    config.navColor = [UIColor whiteColor];
    config.sloganTextColor = HEXCOLOR(0x666666);
    config.agreementNavBackgroundColor = config.navColor;
    config.agreementNavText = [[NSAttributedString alloc] initWithString:@"运营商服务协议" attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:20], NSForegroundColorAttributeName:HEXCOLOR(0x408FFE)}];
    
    config.firstPrivacyAgreementNavText = [[NSAttributedString alloc] initWithString:@"服务协议" attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:20], NSForegroundColorAttributeName:HEXCOLOR(0x408FFE)}];
    config.secondPrivacyAgreementNavText = [[NSAttributedString alloc] initWithString:@"隐私政策" attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:20], NSForegroundColorAttributeName:HEXCOLOR(0x408FFE)}];
    //logo
    config.logoImg = [UIImage imageNamed:@"img_login_logo"];
    CGFloat logoWidth = 213;
    CGFloat logoHeight = 56;
    CGFloat windowW = ScreenW;
    JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeTop multiplier:1 constant:-60];
    JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
    JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
    config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
    
    //slogan展示
    config.sloganFont = [UIFont fontWithName:kFontNormal size:12];
    config.sloganTextColor = kColor666;
    JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumber attribute:NSLayoutAttributeTop multiplier:1 constant:-10];
    JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowW];
    JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];

    config.sloganConstraints = @[sloganConstraintX,sloganConstraintY,sloganConstraintW,sloganConstraintH];
    
    //号码栏
    config.numberFont = [UIFont fontWithName:kFontMedium size:20];
    config.numberColor = HEXCOLOR(0x333333);
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeTop multiplier:1 constant:-20];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
    config.numberConstraints = @[numberConstraintX,numberConstraintY,numberConstraintW,numberConstraintH];

    //登录按钮
    CGFloat loginButtonWidth = 280;
    CGFloat loginButtonHeight = 44;
    UIImage *login_nor_image = [UIImage gradientThemeImageSize:CGSizeMake(loginButtonWidth, loginButtonHeight) radius:22];
    UIImage *login_dis_image = [UIImage gradientThemeImageSize:CGSizeMake(loginButtonWidth, loginButtonHeight) radius:22];
    UIImage *login_hig_image = login_nor_image;
    if (login_nor_image && login_dis_image && login_hig_image) {
        config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    }
    config.logBtnTextColor = kColor333;
    config.logBtnText = @"本机号码一键登录";
    config.logBtnFont = [UIFont fontWithName:kFontNormal size:18];
    
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant: 0];
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];

    //隐私
    config.privacyTextFontSize = 12;
    config.privacyTextAlignment = NSTextAlignmentCenter;
    config.appPrivacyColor = @[HEXCOLOR(0x999999),HEXCOLOR(0x3a8cfe)];
    config.appPrivacyOne = @[@"服务协议", H5_BASE_STRING(@"/jianhuo/serviceAgreement.html")];
    config.appPrivacyTwo = @[@"隐私政策", H5_BASE_STRING(@"/jianhuo/privacyAgreement.html")];
    config.privacyComponents = @[@"已阅读并同意",@"和\n天天鉴宝平台",@" ",@" "];
    config.privacyLineSpacing = 5;
    config.privacyShowBookSymbol = YES;
    
    config.checkedImg = JHImageNamed(@"common_checked_box");
    config.uncheckedImg = JHImageNamed(@"common_check_box");
    config.privacyState = NO;
    config.checkViewHidden = NO;
    @weakify(self);
    config.customPrivacyAlertViewBlock = ^(UIViewController *vc) {
    
        @strongify(self);
        [self showCheckBoxToast];
    };
    
    {
        JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeLeft multiplier:1 constant:5];
        JVLayoutConstraint *privacyConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:20];
        
        JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];

        JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeTop multiplier:1 constant:3];
        
        config.checkViewConstraints = @[privacyConstraintX,privacyConstraintW,privacyConstraintY,privacyConstraintH];
    }
    
    
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *privacyConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:260];

    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogin attribute:NSLayoutAttributeTop multiplier:1 constant: -40];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:45];
    
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintW,privacyConstraintY,privacyConstraintH];

    JVLayoutConstraint *privacyConstraintY1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-16];

    config.privacyHorizontalConstraints = @[privacyConstraintX,privacyConstraintW,privacyConstraintH,privacyConstraintY1];

    //loading
    JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
    

    [JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
        UIView *contentView = [UIView new];
        [customAreaView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(customAreaView.mas_centerY).offset(loginButtonHeight/2);
            make.width.centerX.equalTo(customAreaView);
            make.bottom.offset(-(UI.bottomSafeAreaHeight+20+45));
        }];
        if (customViewsBlk) {
            customViewsBlk(contentView);
        }
    }];
}

///checkBox吐司
- (void)showCheckBoxToast {
    if(![JHKeyWindow viewWithTag:2222]) {
        UIView *view = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:JHKeyWindow];
        view.tag = 2222;
        view.alpha = 0.9;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(JHKeyWindow);
            make.size.mas_equalTo(CGSizeMake(ScreenW, 80));
            make.bottom.equalTo(self.otherLogin.mas_top).offset(-20);
        }];
        [view makeToast:@"请阅读并勾选《服务协议》和《隐私政策》\n及第三方运营商服务协议" duration:4 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
        });
    }
}

- (UIView *)createCustomViewWithSuperView:(UIView *)superview
{
    [superview addSubview:self.otherLogin];
    [superview addSubview:self.stackView];
    


    UIImageView *tips = [self tipsGiftBtn];
    [superview addSubview:tips];
    
    UIView*  imageLeft=[[UIView alloc]init];
    imageLeft.contentMode = UIViewContentModeScaleAspectFit;
    imageLeft.backgroundColor = HEXCOLOR(0xeeeeee);
    [superview addSubview:imageLeft];
    
    UIView*  imageright=[[UIView alloc]init];
    imageright.contentMode = UIViewContentModeScaleAspectFit;
    imageright.backgroundColor = HEXCOLOR(0xeeeeee);
    [superview addSubview:imageright];
    
    [imageLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.otherLogin.mas_left).offset(-10);
        make.centerY.equalTo(self.otherLogin);
        make.height.offset(0.5);
        make.left.mas_equalTo(40);
    }];
    
    [imageright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.otherLogin.mas_right).offset(10);
        make.centerY.equalTo(self.otherLogin);
        make.height.offset(0.5);
        make.right.mas_equalTo(-40);
    }];

    [self.otherLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.stackView.mas_top).offset(-18);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
//        make.height.offset(60);
        make.bottom.equalTo(superview).offset(0);
    }];
//    [self.wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(36, 36));
//    }];
//    [self.otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(self.wxButton);
//    }];
    [self.wxStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.otherPhoneStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.wxStackView);
    }];

    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(superview);
        make.size.mas_equalTo(CGSizeMake(355*ScreenWidth/375.0, 70));
    }];
    return superview;
}
- (UILabel *)otherLogin {
    if (!_otherLogin) {
        _otherLogin = [[UILabel alloc] initWithFrame:CGRectZero];
        _otherLogin.text = @"其他登录方式";
        _otherLogin.textColor = HEXCOLOR(0x999999);
        _otherLogin.font = [UIFont fontWithName:kFontNormal size:13];
        _otherLogin.textAlignment = NSTextAlignmentCenter;
    }
    return _otherLogin;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.wxStackView, self.otherPhoneStackView]];
        _stackView.spacing = 40;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
    }
    return _stackView;
}
- (UIStackView *)wxStackView {
    if (!_wxStackView) {
        UILabel *label = [self loginTitle:@"微信登录"];
        _wxStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.wxButton, label]];
        _wxStackView.spacing = 2;
        _wxStackView.axis = UILayoutConstraintAxisVertical;
        _wxStackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _wxStackView;
}
- (UIStackView *)otherPhoneStackView {
    if (!_otherPhoneStackView) {
        UILabel *label = [self loginTitle:@"手机号登录"];
        _otherPhoneStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.otherPhoneButton, label]];
        _otherPhoneStackView.spacing = 2;
        _otherPhoneStackView.axis = UILayoutConstraintAxisVertical;
        _otherPhoneStackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _otherPhoneStackView;
}
- (UILabel *)loginTitle : (NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.textColor = HEXCOLOR(0x999999);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:kFontNormal size:11];
    return label;
}
- (UIButton *)otherPhoneButton {
    if (!_otherPhoneButton) {
        _otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherPhoneButton setImage:[UIImage imageNamed:@"icon_login_phone"] forState:UIControlStateNormal];
        [_otherPhoneButton addTarget:self action:@selector(otherLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherPhoneButton;
}
- (UIButton *)wxButton {
    if (!_wxButton) {
        _wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wxButton.tag = JHLoginTypeWeiChat;
        [_wxButton setImage:[UIImage imageNamed:@"icon_login_wx"] forState:UIControlStateNormal];
        [_wxButton addTarget:self action:@selector(quickLoginOtherLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxButton;
}
- (UIButton *)closeBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(quickLoginCloseAll) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 44, 44);
    return btn;
}
//注册享受1888元新人大礼包
- (UIImageView *)tipsGiftBtn
{
    NSString* imageStr = [UserInfoRequestManager sharedInstance].oneTouchImgUrl;
    UIImageView *img = [UIImageView new];
    [img jhSetImageWithURL:[NSURL URLWithString:imageStr]];
    img.userInteractionEnabled = NO;
    return img;
}


- (void)otherLoginAction
{
    [JHGrowingIO trackPublicEventId:JHClickOtherLoginClick paramDict:@{@"success":@"true"}];
    [self trackingEventName:@"loginMethodClick" property:@{@"login_method":@"其它手机号码登录",@"page_position":@"登录页"}];
    [self dismissQuickLoginControllerAnimated:NO];
}

#pragma mark - delegagte event
- (void)quickLoginCloseAll
{
    if([self.delegate respondsToSelector:@selector(closeAll)])
    {
        [self.delegate closeAll];
    }
}

//去申诉
- (void)quickLogintoAppeal:(NSString *)paraStr
{
    if([self.delegate respondsToSelector:@selector(toAppeal:)])
    {
        [self.delegate toAppeal:paraStr];
    }
}

- (void)quickLoginOtherLogin:(UIButton*)button
{
    if(_agreeCheck) {
        if([self.delegate respondsToSelector:@selector(otherLogin:)]) {
            [self.delegate otherLogin:button];
        }
    }
    else {
        [self showCheckBoxToast];
    }
    
}

- (void)quickLoginResultAction
{
    if([self.delegate respondsToSelector:@selector(quickLoginResult:)])
    {
        [self.delegate quickLoginResult:YES];
    }
}

- (void)trackingEventName:(NSString *)event property:(NSDictionary *)dic{
    [JHTracking trackEvent:event property:dic];
}
@end
