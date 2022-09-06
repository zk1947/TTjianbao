//
//  PhoneNumberLoginViewController.m
//  TTjianbao
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "JHAntiFraud.h"
#import "NTESService.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESLogManager.h"
#import "JHAppAlertViewManger.h"
#import "CodeInputView.h"
#import "IQKeyboardManager.h"
#import "STRIAPManager.h"
#import "LoginMode.h"
#import "BYTimer.h"
#import "TTjianbaoHeader.h"
#import "Tracking.h"

@interface VerifyCodeViewController ()<UITextFieldDelegate>
{
    UILabel * account;
    UIView * passwordView;
    UIButton*  send;
    int secondsCountDown;
    NSString * loginAccount;
    NSString * loginToken;
    UIView * headerView;
    BYTimer * timer;
}
@property(strong,nonatomic)UIButton* loginButton;
@property(strong,nonatomic)CodeInputView* codeView;
@property(strong,nonatomic)NSString* verifyCode;
@end

@implementation VerifyCodeViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initHeaderView];
    [self.view addSubview:self.codeView];
    [self.view bringSubviewToFront:self.jhNavView];
//    [self  initToolsBar];
//    self.view.backgroundColor=[UIColor whiteColor];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:[UIImage imageNamed:@"Custom Preset.png"] withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//     self.navbar.ImageView.backgroundColor = [UIColor clearColor];
    //不需要替换，默认就OK
    [self countDown];
    [JHAppAlertViewManger appAlertshowing:YES];
}

-(void)countDown {
    
    if (!timer) {
        timer=[[BYTimer alloc]init];
    }
    [timer createTimerWithTimeout:60 handlerBlock:^(int presentTime) {
        
        [send setTitle:[NSString stringWithFormat:@"%ds",presentTime] forState:UIControlStateNormal];
         send.userInteractionEnabled=NO;
        
    } finish:^{
       
        [send setTitle:@"获取验证码" forState:UIControlStateNormal];
        send.userInteractionEnabled=YES;
        
    }];
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
    
    ///此页面没有释放
    [JHAppAlertViewManger appAlertshowing:NO];
}

-(void)initHeaderView{
    
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
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    title.text = @"输入验证码";
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
    desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    desc.textColor=HEXCOLOR(0x999999);
    desc.text = @"验证码已发送至您的手机";
    desc.font=[UIFont systemFontOfSize:13];
    [headerView addSubview:desc];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title);
        make.top.equalTo(title.mas_bottom).offset(10);
    }];
    
    account  = [[UILabel alloc] init];
    account.numberOfLines =1;
    account.backgroundColor=[UIColor clearColor];
    account.textAlignment = UIControlContentHorizontalAlignmentCenter;
    account.lineBreakMode = NSLineBreakByWordWrapping;
    account.textColor=HEXCOLOR(0x999999);
    account.text = self.phoneNumber;
    account.font=[UIFont systemFontOfSize:13];
    [headerView addSubview:account];
    
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title);
        make.top.equalTo(desc.mas_bottom).offset(5);
        make.bottom.equalTo(headerView);
    }];
    
    
    send=[[UIButton alloc]init];
    [send setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [send setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [send setTitle:@"获取验证码" forState:UIControlStateNormal];
    send.titleLabel.font=[UIFont systemFontOfSize:13];
    [send setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [send addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:send];
    
    [send mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(account.mas_right).offset(10);
        make.centerY.equalTo(account);
    }];
}
- (CodeInputView *)codeView {
    
    JH_WEAK(self)
    if (!_codeView) {
        _codeView = [[CodeInputView alloc]initWithFrame:CGRectMake(0,250+UI.statusBarHeight,ScreenW,55) inputType:4 selectCodeBlock:^(NSString * code) {
            JH_STRONG(self)
            self.verifyCode=code;
            if ([code length]==4) {
                 [self login];
            }
           
        }];
        //_codeView.center = self.view.center;
    }
    return _codeView;
}
-(void)send{
    
    if ([account.text length]!=11) {
        [self.view makeToast:@"请输入正确手机号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    NSString *captchaCode=[CommHelp md5:[NSString stringWithFormat:@"%@_%@",account.text,@"d94b7176048568a5fa6f8f19e0ba976e"]];
    
    NSDictionary * parameters=@{@"phone":account.text,
                                @"apisign":captchaCode,
                                };
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/login/smsAndReg") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"发送成功" duration:1.0 position:CSToastPositionCenter];
        [self countDown];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
-(void)login{
    
    if ([account.text length]!=11) {
        [self.view makeToast:@"请输入正确手机号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.verifyCode length]<=0) {
        [self.view makeToast:@"请输入验证码" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    NSString * sm_deviceId = [JHAntiFraud deviceId];

    NSMutableDictionary * parameters= [NSMutableDictionary dictionaryWithDictionary: @{@"phone":account.text,
                                                                                       @"smsVerifyCode":self.verifyCode,
                                                                                       @"sm_deviceId":sm_deviceId,
                                                                                       }];
    
    if (self.params) {
        [parameters addEntriesFromDictionary:self.params];
    }
    
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/loginByPhone") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        LoginMode  *loginMode = [LoginMode mj_objectWithKeyValues:respondObject.data];
        NSString  *Account=loginMode.wyAccount.accid;
        NSString  *Token=loginMode.wyAccount.token;
        [JHTracking loginedUserID:loginMode.customerId];
        if (loginMode.isReg) {
            [Tracking setRegisterWithAccountID:loginMode.customerId?:@""];
        }
        [JHRootController loginIM:Account token:Token completion:^(NSError * _Nullable error) {
            if (!error) {
                
                [[NSUserDefaults standardUserDefaults] setObject:loginMode.loginToken forKey:IDTOKEN ];
                [[NSUserDefaults standardUserDefaults] setObject:ONLINE forKey:LOGINSTATUS ];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[UserInfoRequestManager sharedInstance]bindDeviceToken:nil];
                [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
                    
                    [[UserInfoRequestManager sharedInstance] getHomePageActivitylnfoCompletion:nil];
                    
                    [ [STRIAPManager shareSIAPManager] veryfyTransaction :nil];
                    ///通知红包/礼物界面发放红包或者礼物
                    NSInteger index = JHRootController.homeTabController.selectedIndex;
                    if (index == 1 || index == 3) {
                        NSString * type = (index == 3) ? @"gift" : @"redbag";
                        [[NSNotificationCenter defaultCenter] postNotificationName:kGrantNotification object:nil userInfo:@{@"type":type}];
                    }
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        if (self.loginResult) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kDiscoverHomeRefreshChannelNoticeName object:nil];
//                            ///退出登录 移除记录红包的key
//                            [JHMaskingManager removeRedPocketKey];
                            self.loginResult(YES);
                        }
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAllLoginSuccessNotification object:nil];
                }];
                
            }
            
        }];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
        
    }];
    
    [SVProgressHUD show];
    
}

- (void)dealloc
{
    [timer stopGCDTimer];
    [JHAppAlertViewManger appAlertshowing:NO];
}
@end

