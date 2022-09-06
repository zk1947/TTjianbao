//
//  LoginViewController.m
//  ERP
//
//  Created by jiangchao on 16/9/19.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESLogManager.h"
#import "PhoneNumberLoginViewController.h"
#import "WXApi.h"
#import "BindingPhoneViewController.h"
#import "JHWebViewController.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
#import "IQKeyboardManager.h"
#import "VerifyCodeViewController.h"
#import "STRIAPManager.h"
#import "LEEAlert.h"
#import "JHAntiFraud.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TTjianbaoBussiness.h"
#import "JHQuickLoginView.h"
#import "JHAppealPopWindow.h"

#define headViewRate (float) 424/750

static NSString *const protocolString = @"请阅读并勾选《服务协议》和《隐私政策》";

@interface LoginViewController ()<UITextFieldDelegate, JHQuickLoginViewDelegate>
{
    UITextField* account;
    UITextField* password;
    UIView *back;
    UIButton*  press;
    UIView * headerView;
    UIView *titleTipView;
    UIView *buttonsView;
//    TencentOAuth*    _tencentOAuth;
    NSMutableArray * _permissionArray;
    BOOL showQuickLoginPage; //已经显示一键登录,即授权页面被拉起
}
@property(strong,nonatomic)UIButton* chooseBtn;
@property(strong,nonatomic)UIButton* agreementBtn; //服务协议
@property(strong,nonatomic)UIButton* privacyAgreementBtn;  //隐私协议
@property(strong,nonatomic)UIButton* loginButton;
@property(strong,nonatomic)JHQuickLoginView* quickLoginView; //快速登录(一键登录)
@end

@implementation LoginViewController

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXTokenLogin:) name:WXLOGINSUSSNotifaction object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=HEXCOLOR(0xf8f8f8);
    
    [self drawLoginView];
    [self setCommonLoginViewHidden:YES];
    
    [self startLoginVerfication];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

//埋点：扩展创建页面（进入页面的参数）
- (NSMutableDictionary*)growingGetCreatePageParamDict
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:[super growingGetCreatePageParamDict]];
    [dic setValue:@"enter_live_in" forKey:@"page_name"];
    [dic setValue:@"loginPage" forKey:@"from"];
    return dic;
}

#pragma mark ===============view ===============
- (void)drawLoginView
{
    [self initHeaderView];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
//    [self  initToolsBar];
//    self.navbar.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.jhNavView];
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self initRightButtonWithImageName:@"login_close" action:@selector(cancle)];

//    [self.navbar addBtn:nil withImage:[UIImage imageNamed:@"login_close"] withHImage:[UIImage imageNamed:@"login_close"] withFrame:CGRectMake(ScreenW-50,0,44,44)];
//     self.navbar.ImageView.backgroundColor = [UIColor clearColor];
//     [self.navbar.comBtn addTarget :self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    
     
     [self initButtonsView];
     [self initTipView];
     [self initAgreeView];
}

- (void)setCommonLoginViewHidden:(BOOL)hidden {
    [self.view setHidden:hidden];
}

- (JHQuickLoginView *)quickLoginView
{
    if(!_quickLoginView)
    {
        _quickLoginView = [JHQuickLoginView new];
        _quickLoginView.delegate = self;
        _quickLoginView.params = self.params;
    }
    return _quickLoginView;
}

- (void)dismissQuickLoginView
{
    [self.quickLoginView dismissQuickLoginControllerAnimated:NO];
    self.quickLoginView.delegate = nil;
    self.quickLoginView = nil;
    showQuickLoginPage = NO;
}

- (void)initHeaderView{
    
    headerView=[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    headerView.userInteractionEnabled=YES;
    [self.view addSubview:headerView];
   
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.width.offset(ScreenW);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines =1;
    title.backgroundColor=[UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    title.text = @"登录天天鉴宝";
    title.font=[UIFont boldSystemFontOfSize:25];
    title.textColor = HEXCOLOR(0x333333);
    [headerView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(40);
        make.top.equalTo(headerView).offset(100+UI.statusBarHeight);
    }];
    
    UILabel *desc = [[UILabel alloc] init];
    desc.numberOfLines =1;
    desc.backgroundColor=[UIColor clearColor];
    desc.textAlignment = NSTextAlignmentCenter;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    desc.textColor=HEXCOLOR(0x999999);
    desc.text = @"专业鉴定师免费直播鉴定平台";
    desc.font=[UIFont systemFontOfSize:14];
    [headerView addSubview:desc];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title);
        make.top.equalTo(title.mas_bottom).offset(10);
    }];
    
    UIView * accountView=[[UIView alloc]init];
    accountView.backgroundColor=[UIColor clearColor];
    [headerView addSubview:accountView];
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(desc.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@50);
        make.bottom.equalTo(headerView);
    }];
    
    UIView * line1=[[UIView alloc]init];
    line1.backgroundColor=[CommHelp toUIColorByStr:@"#EOEOEO"];
    line1.alpha=0.1;
    [accountView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@1);
        make.bottom.equalTo(accountView).offset(-1);
    }];
    
    UIImageView* accountima=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_ic_phone"]];
    accountima.backgroundColor=[UIColor clearColor];
    [accountView addSubview:accountima];
    
    account=[[UITextField alloc]init];
    account.backgroundColor=[UIColor clearColor];
    account.tag=1;
    account.tintColor = HEXCOLOR(0x333333);
    account.returnKeyType =UIReturnKeyDone;
    account.delegate=self;
    account.keyboardType = UIKeyboardTypeNumberPad;
    account.placeholder=@"请输入手机号码";
    account.font=[UIFont fontWithName:@"ArialMT" size:22.f];
    [accountView addSubview:account];
    
    [accountima mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(accountView).offset(40);
        make.centerY.equalTo(accountView);
        make.size.mas_equalTo(CGSizeMake(13,21));
        
    }];
    //
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(accountima.mas_right).offset(10);
        make.right.equalTo(accountView);
        make.centerY.equalTo(accountView);
        make.top.bottom.equalTo(accountView);
    }];
}

-(void)initTipView{
    titleTipView=[[UIView alloc]init];
    titleTipView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:titleTipView];
    [titleTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
//        make.top.equalTo(self.loginButton.mas_bottom).offset(30);
        make.bottom.mas_equalTo(buttonsView.mas_top).offset(-18);
        make.width.offset(ScreenW);
        make.height.equalTo(@30);
    }];
    
    UILabel* titleName=[[UILabel alloc]init];
    titleName.text=@"其他登录方式";
    titleName.font=[UIFont systemFontOfSize:16];
    titleName.backgroundColor=[UIColor clearColor];
    titleName.textColor=[UIColor colorWithRed:0.48f green:0.48f blue:0.48f alpha:1.00f];
    titleName.numberOfLines = 1;
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.lineBreakMode = NSLineBreakByWordWrapping;
    [titleTipView addSubview:titleName];
    
    UIView*  imageLeft=[[UIView alloc]init];
    imageLeft.contentMode = UIViewContentModeScaleAspectFit;
    imageLeft.backgroundColor=[UIColor colorWithRed:0.91f green:0.90f blue:0.88f alpha:1.00f];
    [titleTipView addSubview:imageLeft];
    
    UIView*  imageright=[[UIView alloc]init];
    imageright.contentMode = UIViewContentModeScaleAspectFit;
     imageright.backgroundColor=[UIColor colorWithRed:0.91f green:0.90f blue:0.88f alpha:1.00f];
    [titleTipView addSubview:imageright];
    
    [titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTipView).offset(0);
        make.centerX.equalTo(titleTipView);
        make.height.offset(30);
    }];
    
    [imageLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleName.mas_left).offset(-10);
        make.centerY.equalTo(titleName);
        make.height.offset(1);
        make.left.equalTo(titleTipView).offset(40);

    }];
    
    [imageright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleName.mas_right).offset(10);
        make.centerY.equalTo(titleName);
        make.height.offset(1);
        make.right.equalTo(titleTipView).offset(-40);
    }];
    
    if ([WXApi isWXAppInstalled]) {
        titleTipView.hidden = NO;
    }else {
        titleTipView.hidden = YES;
    }
}

-(void)initButtonsView{
    
    buttonsView=[[UIView alloc]init];
    buttonsView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
     
//        make.top.equalTo(titleTipView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-(UI.bottomSafeAreaHeight + 30));
        make.width.offset(200);
        make.height.equalTo(@70);
        make.centerX.equalTo(self.view);
    }];
    
    NSArray * images;;
    if ([WXApi isWXAppInstalled]) {
        images=@[@"new_wx_press"];
    }
    UIButton * lastBtn;
    
    for (int i=0; i<[images count]; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];//
        button.tag=JHLoginTypeWeiChat;
        [button setTitle:@"微信登录" forState:UIControlStateNormal];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#999999"] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(otherLoginMethod:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.top.equalTo(buttonsView);
            if (i==0) {
                make.left.equalTo(buttonsView);
            }
            
            else{
                make.left.equalTo(lastBtn.mas_right);
                make.width.equalTo(lastBtn);
                
            }
            if (i==[images count]-1) {
                
                make.right.equalTo(buttonsView);
            }
            
        }];
        
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
        lastBtn=button;
    }
}

-(void)initAgreeView{
    
    back=[UIView new];
    back.backgroundColor=[UIColor clearColor];
    [self.view addSubview:back];
    
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(account.mas_bottom).offset(18);
        make.left.mas_equalTo(headerView).offset(31);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-10-UI.bottomSafeAreaHeight);
        make.height.equalTo(@30);
//        make.centerX.equalTo(self.view);
    }];
    
    [back addSubview:self.chooseBtn];
    [back addSubview:self.agreementBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //[label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = @"已阅读并同意天天鉴宝平台";
    label.font=[UIFont systemFontOfSize:12];
    label.textColor = HEXCOLOR(0x999999);
    [back addSubview:label];
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back);
        make.centerY.equalTo(back);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [back addSubview:self.privacyAgreementBtn];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.chooseBtn.mas_right).offset(-4);
        make.centerY.equalTo(back);
    }];
    
    [ self.agreementBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.centerY.equalTo(label);
        make.right.equalTo(self.privacyAgreementBtn.mas_left);
    }];
    [ self.privacyAgreementBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreementBtn.mas_right);
        make.centerY.equalTo(label);
        make.right.equalTo(back);
    }];
    
}
-(UIButton*)loginButton{
    
    if (_loginButton==nil) {
        _loginButton=[UIButton new];
        _loginButton.contentMode=UIViewContentModeScaleAspectFit;
        [_loginButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"new_login_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"new_login_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
         [_loginButton setTitle:@"下一步" forState:UIControlStateNormal];
         [_loginButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        
        _loginButton.userInteractionEnabled=NO;
        _loginButton.alpha=0.7;
      
    }
    return _loginButton;
}

-(UIButton*)chooseBtn{
    
    if (_chooseBtn==nil) {
        
        _chooseBtn = [[UIButton alloc] init];
        _chooseBtn.backgroundColor = [UIColor clearColor];
        [_chooseBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_chooseBtn setImage:[UIImage imageNamed:@"common_check_box"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"common_checked_box"] forState:UIControlStateSelected];
        [_chooseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _chooseBtn.tag = 1000;
    }
    
    return _chooseBtn;
}

-(UIButton*)agreementBtn{
    
    if (_agreementBtn==nil) {
        _agreementBtn=[[UIButton alloc]init];
        [_agreementBtn setTitle:@"《服务协议》" forState:UIControlStateNormal];
        _agreementBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [_agreementBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
        _agreementBtn.backgroundColor=[UIColor clearColor];
        [_agreementBtn addTarget:self action:@selector(agreeMent:) forControlEvents:UIControlEventTouchUpInside];
        //_loginBtn.alpha=0.5;
    }
  
      return _agreementBtn;
}
-(UIButton*)privacyAgreementBtn{
    if (_privacyAgreementBtn==nil) {
        _privacyAgreementBtn=[[UIButton alloc]init];
        [_privacyAgreementBtn setTitle:@"《隐私政策》" forState:UIControlStateNormal];
        _privacyAgreementBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [_privacyAgreementBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
        _privacyAgreementBtn.backgroundColor=[UIColor clearColor];
        [_privacyAgreementBtn addTarget:self action:@selector(privacyAgreeMent:) forControlEvents:UIControlEventTouchUpInside];
        //_loginBtn.alpha=0.5;
    }
  
      return _privacyAgreementBtn;
}
-(void)agreeMent:(UIButton*)button{
    
    //关于我们
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/serviceAgreement.html");
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)privacyAgreeMent:(UIButton*)button{
    
    //关于我们
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/privacyAgreement.html");
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setLoginResult:(void (^)(BOOL))loginResult{
    
    _loginResult = loginResult;
}

#  pragma mark =============== buttonClickMethod ===============
//登录验证,如果可以调起一键登录,就显示一键登录界面,否则显示普通登录界面
- (void)startLoginVerfication {
    JH_WEAK(self)
    [self.quickLoginView quickLoginStartVerfication:^(NSNumber* resultCode) {
        JH_STRONG(self)
        NSInteger code = [resultCode integerValue];
        if(code == JHVerficationActiveTypePageOpen) { //显示一键登录
            showQuickLoginPage = YES;
            [self reportPageView:true];
        } else if(code == JHVerficationActiveTypePageClose) {
            if(showQuickLoginPage) {
//                [self dismissQuickLoginView];
                [self setCommonLoginViewHidden:NO];
            }
        } else { //显示普通登录
            if(showQuickLoginPage) {
                // 1 调起后,在JHVerficationActiveTypePageClose出执行后续操作
            } else { // 2 未调起时,展示普通登录
                [self setCommonLoginViewHidden:NO];
                [self reportPageView:false];
            }
        }
    }];
}
- (void)reportPageView : (BOOL)isQuickLogin{
    NSString *pageViewStr = isQuickLogin ? @"一键登录页" : @"手机号登录页";
    // 点击事件 应与 源状态相反
    NSDictionary *par = @{
        @"page_name" : pageViewStr,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
-(void)cancle{
    [JHGrowingIO trackEventId:@"enter_live_in_other_close_click"];
    if (showQuickLoginPage) {
        [self startLoginVerfication];
    } else {
        if (self.loginResult) {
            self.loginResult(NO);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)btnClick:(UIButton*)button{
    
    if (button.selected) {
        
        button .selected=NO;
    }
    else{
        button .selected=YES;
    }
}

-(void)login:(UIButton*)button{
    
    switch (button.tag) {
        case JHLoginTypePhoneNumber:
        {
            [Growing track:@"loginchoice" withVariable:@{@"value":@(2)}];
            PhoneNumberLoginViewController * login=[[PhoneNumberLoginViewController alloc]init];
            login.params = self.params;
            login.loginResult = self.loginResult;
            [self.navigationController pushViewController:login animated:YES];
        }
            break;
            
        case JHLoginTypeWeiChat:
        {
            [Growing track:@"loginchoice" withVariable:@{@"value":@(0)}];
            if (![WXApi isWXAppInstalled]) {
                [self.view makeToast:@"当前设备没有安装微信，请用手机号登陆" duration:1.0 position:CSToastPositionCenter];
                return;
            }
            [self sendAuthRequest];
        }
            break;
            
        default:
            break;
    }
}

-(void)send{
    
    NSString *phoneNum = [account.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([phoneNum length] != 11) {
        [self.view makeToast:@"请输入正确手机号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    ///检查是否遵守了协议
    if (!self.chooseBtn.selected) {
        [self showCheckBoxToast];
        return;
    }
    NSString *captchaCode = [CommHelp md5:[NSString stringWithFormat:@"%@_%@",phoneNum,@"d94b7176048568a5fa6f8f19e0ba976e"]];
    
    NSDictionary * parameters=@{@"phone":phoneNum,
                                @"apisign":captchaCode,
                                };
    [SVProgressHUD show];
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/login/smsAndReg") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        VerifyCodeViewController * vc=[[VerifyCodeViewController alloc]init];
        vc.params = self.params;
        vc.phoneNumber=phoneNum;
        vc.loginResult = self.loginResult;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        
         if (respondObject.code == 1008) { //被封禁
             [account resignFirstResponder];
             [[JHAppealPopWindow signAppealpopVindow] show];
             [JHAppealPopWindow signAppealpopVindow].btnClickedBlock = ^{
                 @strongify(self);
                 [self toAppeal:respondObject.data[@"freezeMessage"]];
             };
         } else {
             [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
         }
    }];
}

- (void)showCheckBoxToast {
    [self.view endEditing:YES];
    if(![self.view viewWithTag:2222]) {
        UIView *view = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self.view];
        view.tag = 2222;
        view.alpha = 0.9;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(ScreenW, 80));
            make.bottom.equalTo(titleTipView.mas_top).offset(0);
        }];
        [view makeToast:protocolString duration:4 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
        });
    }
}

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"loginwx";
    [WXApi sendReq:req completion:^(BOOL success) {
        [JHGrowingIO trackEventId:@"enter_wchat_click" variables:@{
            @"success":@(success),
        }];
    }];
}

-(void)WXTokenLogin:(NSNotification*)note{
    
    NSString * sm_deviceId = [JHAntiFraud deviceId];

    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary: @{
        @"sm_deviceId":sm_deviceId
        }];
    
    if (self.params) {
        [parameters addEntriesFromDictionary:self.params];
    }
     NSString * code=[note object];
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/appLogin/") stringByAppendingString:OBJ_TO_STRING(code)] Parameters:parameters  successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
         LoginMode  *loginMode = [LoginMode mj_objectWithKeyValues:respondObject.data];
         NSString  *Account=loginMode.wyAccount.accid;
         NSString  *Token=loginMode.wyAccount.token;
         [JHTracking loginedUserID:loginMode.customerId];
        if ([loginMode.isBind integerValue]==0) {
            
            [Growing track:@"loginsucceed"];
          [JHRootController loginIM:Account token:Token completion:^(NSError * _Nullable error) {
              if (!error) {
                  
                    [[NSUserDefaults standardUserDefaults] setObject:loginMode.loginToken forKey:IDTOKEN ];
                    [[NSUserDefaults standardUserDefaults] setObject:ONLINE forKey:LOGINSTATUS ];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [[UserInfoRequestManager sharedInstance]bindDeviceToken:nil];
                    //内购验证
                    [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
                    [[UserInfoRequestManager sharedInstance] getHomePageActivitylnfoCompletion:nil];
                    //                      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    [self closeAll];
                    [[STRIAPManager shareSIAPManager] veryfyTransaction:nil];
                    [self loginResultExt:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAllLoginSuccessNotification object:nil];
                  }];
              }

          }];
        }
        else{
            if (showQuickLoginPage)
            {
                [self->_quickLoginView dismissQuickLoginControllerAnimated:NO];
            }
            BindingPhoneViewController * bind=[[BindingPhoneViewController alloc]init];
            bind.loginResult = self.loginResult;
            bind.loginMode=loginMode;
            [self.navigationController pushViewController:bind animated:YES];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        if (respondObject.code == 1008) { //被封禁
            @weakify(self);
            [account resignFirstResponder];
            [[JHAppealPopWindow signAppealpopVindow] show];
            [JHAppealPopWindow signAppealpopVindow].btnClickedBlock = ^{
                @strongify(self);
                [self toAppeal:respondObject.data[@"freezeMessage"]];
            };
            
        } else {
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
    [SVProgressHUD show];
}

- (void)otherLoginMethod:(UIButton *)sender {
    
    ///如果没有同意隐私  需要提示用户同意隐私
    if (!self.chooseBtn.selected) {
        [self showCheckBoxToast];
        return;
    }
    
    [self otherLogin:sender];
}

- (void)otherLogin:(UIButton*)button{
    
    switch (button.tag) {
        case JHLoginTypePhoneNumber:
        {
            [Growing track:@"loginchoice" withVariable:@{@"value":@(2)}];
            PhoneNumberLoginViewController * login=[[PhoneNumberLoginViewController alloc]init];
            login.params = self.params;
            login.loginResult = self.loginResult;
            [self.navigationController pushViewController:login animated:YES];
        }
            break;
            
        case JHLoginTypeQQ:
        {
//            [JHGrowingIO trackPublicEventId:JHClickQQLoginClick];
//            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1107964101" andDelegate:self];
//            _tencentOAuth.authShareType = AuthShareType_QQ;
//            NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", nil];
//            [_tencentOAuth authorize:permissions];
        }
            break;
        case JHLoginTypeWeiChat:
        {
            [JHGrowingIO trackPublicEventId:JHClickWechatLoginClick paramDict:nil];
            [JHTracking trackEvent:@"loginMethodClick" property:@{@"login_method":@"微信登录",@"page_position":@"登录页"}];
            
            if (![WXApi isWXAppInstalled]) {
                [self.view makeToast:@"当前设备没有安装微信，请用手机号登陆" duration:1.0 position:CSToastPositionCenter];
                return;
            }
            [self sendAuthRequest];
        }
            break;
    
            default:
            break;
    }
}
//去申诉
- (void)toAppeal:(NSString *)paraStr {
    NSString * url = @"/jianhuo/app/applyForThawing.html";
    if ([paraStr containsString:@"?"]) {
        url = [url stringByAppendingString:paraStr];
    }
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = @"申诉";
    vc.urlString = H5_BASE_STRING(url);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)closeAll
{
    JH_WEAK(self)
    [self dismissViewControllerAnimated:NO completion:^{
        JH_STRONG(self)
        [self->_quickLoginView dismissQuickLoginControllerAnimated:YES];
    }];
}

- (void)quickLoginResult:(BOOL)result
{
    [self loginResultExt:result];
}

- (void)loginResultExt:(BOOL)result
{
    if (self.loginResult)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDiscoverHomeRefreshChannelNoticeName object:nil];
        self.loginResult(YES);
    }
}

#pragma mark - touch & delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [account resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
      NSString *text = [textField text];
     NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
     string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        
        return NO;
        
    }
     text = [text stringByReplacingCharactersInRange:range withString:string];
     text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSMutableString *temString = [NSMutableString stringWithString:text];
     [temString insertString:@" " atIndex:0];
     text = temString;
     NSString *newString = @"";
      while (text.length > 0) {
        
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
          newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            
            newString = [newString stringByAppendingString:@" "];
            
        }
         text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
     newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    if (newString.length >= 14) {
        _loginButton.userInteractionEnabled=YES;
          _loginButton.alpha=1.0;
          return NO;
        
    }
    if (newString.length >= 13) {
        _loginButton.userInteractionEnabled=YES;
          _loginButton.alpha=1.0;
    }
    else{
          _loginButton.userInteractionEnabled=NO;
         _loginButton.alpha=0.7;
    }
     [textField setText:newString];
    
      return NO;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField  resignFirstResponder];
    return YES;
}

@end

