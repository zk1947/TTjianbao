//
//  PhoneNumberLoginViewController.m
//  TTjianbao
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "TTjianbaoMarcoKeyword.h"
#import "NTESService.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESLogManager.h"
#import "LoginMode.h"
#import "BYTimer.h"
#import "Tracking.h"
#import "DeviceInfoTool.h"
#import "UMengManager.h"

@interface BindingPhoneViewController ()<UITextFieldDelegate>
{
    UITextField* account;
    UITextField* password;
    UIView * passwordView;
    UIButton*  send;
    int secondsCountDown;
    NSString * loginAccount;
    NSString * loginToken;
    BYTimer * timer;
}
@property(strong,nonatomic)UIButton* loginButton;
@end

@implementation BindingPhoneViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"绑定手机号"];
    self.title = @"绑定手机号";
//    self.view.backgroundColor=[UIColor whiteColor];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:[UIImage imageNamed:@"Custom Preset.png"] withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self jeneralAccountLoginView];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(250);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view  addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
        [Growing track:@"bindphonenumber"];
    
}

//埋点：扩展创建页面（进入页面的参数）
- (NSMutableDictionary*)growingGetCreatePageParamDict
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:[super growingGetCreatePageParamDict]];
    [dic setValue:@"enter_live_in" forKey:@"page_name"];
    [dic setValue:@"bindPage" forKey:@"from"];
    return dic;
}

-(void)jeneralAccountLoginView{
    
    UIView * accountView=[[UIView alloc]init];
    accountView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:accountView];
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight+10);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@50);
    }];
    
    UIView * line1=[[UIView alloc]init];
    line1.backgroundColor=[CommHelp toUIColorByStr:@"#EOEOEO"];
    line1.alpha=0.1;
    [accountView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@1);
        make.bottom.equalTo(accountView).offset(-1);
    }];
    
    UILabel *userNamelabel = [[UILabel alloc] init];
    userNamelabel.numberOfLines = 1;
    [userNamelabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    userNamelabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    userNamelabel.lineBreakMode = NSLineBreakByWordWrapping;
    userNamelabel.text = @"手机号:";
    
    userNamelabel.font=[UIFont systemFontOfSize:15];
    userNamelabel.textColor = HEXCOLOR(0x333333);
    [accountView addSubview:userNamelabel];
    
    account=[[UITextField alloc]init];
    account.backgroundColor=[UIColor clearColor];
    account.tag=1;
    account.tintColor = HEXCOLOR(0xfee200);
    account.returnKeyType =UIReturnKeyDone;
    account.delegate=self;
    account.keyboardType = UIKeyboardTypeNumberPad;
    account.placeholder=@"请输入手机号";
    account.font=[UIFont systemFontOfSize:16];
    [accountView addSubview:account];
    
    [userNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView).offset(15);
        make.centerY.equalTo(accountView);
        
    }];
    
    //
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(userNamelabel.mas_right).offset(10);
        make.right.equalTo(accountView);
        make.centerY.equalTo(accountView);
        make.top.bottom.equalTo(accountView);
    }];
    
    
    passwordView=[[UIView alloc]init];
    passwordView.backgroundColor=[UIColor  clearColor];
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(accountView.mas_bottom);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@50);
        
    }];
    
    UILabel *passwordlabel = [[UILabel alloc] init];
    passwordlabel.numberOfLines = 1;
    [passwordlabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    passwordlabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    passwordlabel.lineBreakMode = NSLineBreakByWordWrapping;
    passwordlabel.text = @"验证码:";
    passwordlabel.font=[UIFont systemFontOfSize:15];
    passwordlabel.textColor = HEXCOLOR(0x333333);
    [passwordView addSubview:passwordlabel];
    
    password=[[UITextField alloc]init];
    password.backgroundColor=[UIColor clearColor];
    password.tag=2;
    password.tintColor = HEXCOLOR(0xfee200);
    password.keyboardType = UIKeyboardTypeNumberPad;
    password.returnKeyType =UIReturnKeyDone;
    password.delegate=self;
    password.placeholder=@"验证码";
    password.font=[UIFont systemFontOfSize:16];
    [passwordView addSubview:password];
    
    UIView * line2=[[UIView alloc]init];
    line2.backgroundColor=[CommHelp toUIColorByStr:@"#EOEOEO"];
    line2.alpha=0.1;
    [passwordView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(passwordView.mas_bottom).offset(1);
    }];
    
    [passwordlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(passwordView).offset(15);
        make.centerY.equalTo(passwordView);
        
    }];
    //
    send=[[UIButton alloc]init];
    [send setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [send setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [send setTitle:@"获取验证码" forState:UIControlStateNormal];
    send.titleLabel.font=[UIFont systemFontOfSize:13];
    [send setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    [send setBackgroundImage:[UIImage imageNamed:@"alterphone_code_btn.png"] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:send];
    
    [send mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(passwordView.mas_right).offset(-10);
        make.centerY.equalTo(passwordView);
    }];
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(passwordlabel.mas_right).offset(10);
        make.right.equalTo(send.mas_left).offset(-10);
        make.centerY.equalTo(passwordView);
        make.top.bottom.equalTo(passwordView);
    }];
    
}
-(UIButton*)loginButton{
    
    if (_loginButton==nil) {
        _loginButton=[UIButton new];
        [_loginButton setTitle:@"完成" forState:UIControlStateNormal];
        _loginButton.titleLabel.font=[UIFont systemFontOfSize:17];
        _loginButton.tag=104;
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"new_login_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"new_login_press.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(bingPhone) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _loginButton;
    
}
-(void)cancle{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
-(void)send{
    
    NSString *phoneNum = [account.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([phoneNum length]!=11) {
        [self.view makeToast:@"请输入正确手机号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *captchaCode=[CommHelp md5:[NSString stringWithFormat:@"%@_%@",phoneNum,@"d94b7176048568a5fa6f8f19e0ba976e"]];
    NSDictionary * parameters=@{
                                @"apisign":captchaCode,
                                @"type":@"bindMobile",
                                @"mobile":phoneNum
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",self.loginMode.loginToken] forHTTPHeaderField:@"Authorization"];
    SignModel * sign=[HttpRequestTool encryption:parameters];
    [manager.requestSerializer setValue:sign.locality_Time forHTTPHeaderField:@"X-Client-Time"];
    [manager.requestSerializer setValue:sign.encryption_Sign forHTTPHeaderField:@"X-TtjbSign"];
    [manager.requestSerializer setValue: sign.nonceStr forHTTPHeaderField:@"X-NonceStr"];
    [manager.requestSerializer setValue:[HttpRequestTool getPublicInfoString] forHTTPHeaderField:@"X-App-Info"];
    
    [manager POST:FILE_BASE_STRING(@"/auth/customer/sendPhoneSms") parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        RequestModel *model = [RequestModel mj_objectWithKeyValues:responseObject];
        if (model.code == 1000) {
            [self.view makeToast:@"发送成功" duration:1.0 position:CSToastPositionCenter];
            [password becomeFirstResponder];
             [self countDown];
        }
        else{
            
            [self.view makeToast:model.message duration:1.0 position:CSToastPositionCenter];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
          [SVProgressHUD dismiss];
         [self.view makeToast:@"服务器错误" duration:1.0 position:CSToastPositionCenter];
    
    }];
      [SVProgressHUD show];
    
    
    //    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/sendPhoneSms") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
    //        [SVProgressHUD dismiss];
    //        [self.view makeToast:@"发送成功" duration:1.0 position:CSToastPositionCenter];
    //        send.userInteractionEnabled=NO;
    //        [self countDown];
    //
    //    } failureBlock:^(RequestModel *respondObject) {
    //
    //        [SVProgressHUD dismiss];
    //        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    //    }];
    //
    //    [SVProgressHUD show];
}
-(void)bingPhone{
    
    NSString *phoneNum = [account.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([phoneNum length]!=11)
    {[self.view makeToast:@"请输入正确手机号" duration:1.0 position:CSToastPositionCenter];return;
    }
    if ([password.text length]<=0) {
        [self.view makeToast:@"请输入验证码" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    [self.view endEditing:YES];
    
    NSDictionary * parameters=@{@"mobile":phoneNum,
                                @"smsCode":password.text,
                                };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    //这里是为了过虑后台返回的null
    serializer.removesKeysWithNullValues = YES;
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",self.loginMode.loginToken] forHTTPHeaderField:@"Authorization"];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id].length>0) {
        [manager.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id] forHTTPHeaderField:@"X-SESSION-ID"];
    }
    [manager.requestSerializer setValue:JHAppVersion forHTTPHeaderField:@"X-App-Version"];
    [manager.requestSerializer setValue:[HttpRequestTool getPublicInfoString] forHTTPHeaderField:@"X-App-Info"];
//    [manager.requestSerializer setValue:[CommHelp deviceIDFA] forHTTPHeaderField:@"X-Device-IDFA"];
//    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-App-Id"];
    
//    [manager.requestSerializer setValue:JHAppChannel forHTTPHeaderField:@"X-App-Channel"];
//    [manager.requestSerializer setValue:[DeviceInfoTool deviceVersion] forHTTPHeaderField:@"X-Device-Model"];
//    [manager.requestSerializer setValue:@"Apple" forHTTPHeaderField:@"X-Device-Name"];
//    [manager.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"X-Device-Version"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%f",ScreenW] forHTTPHeaderField:@"X-Device-Width"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%f",ScreenH] forHTTPHeaderField:@"X-Device-Height"];
//    [manager.requestSerializer setValue:[[UMengManager shareInstance] getUmengId] forHTTPHeaderField:@"X-Device-UMId"];
//    [manager.requestSerializer setValue:[[UMengManager shareInstance] getUmengUtid] forHTTPHeaderField:@"X-Device-UTDId"];
//    [manager.requestSerializer setValue:[Growing getDeviceId] forHTTPHeaderField:@"X-Device-GIId"];
    
    
    [manager PUT:FILE_BASE_STRING(@"/auth/customer/bind/mobile") parameters:parameters headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        RequestModel *model = [RequestModel mj_objectWithKeyValues:responseObject];
        LoginMode  *loginMode = [LoginMode mj_objectWithKeyValues:model.data];
        if (model.code == 1000) {
            if (loginMode) {
                if (loginMode.isReg) {
                    [Tracking setRegisterWithAccountID:loginMode.customerId?:@""];
                }
            }
            [Growing track:@"bindphonenumbersucceed"];
            NSString  *loginAccount = loginMode.wyAccount.accid;
            NSString  *loginToken = loginMode.wyAccount.token;
            [JHRootController loginIM:loginAccount token:loginToken completion:^(NSError * _Nullable error) {
                if (!error) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:loginMode.loginToken forKey:IDTOKEN ];
                    [[NSUserDefaults standardUserDefaults] setObject:ONLINE forKey:LOGINSTATUS ];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                     [[UserInfoRequestManager sharedInstance]bindDeviceToken:nil];
                    [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
                        [[UserInfoRequestManager sharedInstance] getHomePageActivitylnfoCompletion:nil];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        if (self.loginResult) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:kDiscoverHomeRefreshChannelNoticeName object:nil];
                            self.loginResult(YES);
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAllLoginSuccessNotification object:nil];
                    }];
                    
                }
            }];
        }
        
        else{
            
            [self.view makeToast:model.message duration:1.0 position:CSToastPositionCenter];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.view makeToast:@"服务器错误" duration:1.0 position:CSToastPositionCenter];
        
    }];
    [SVProgressHUD show];
}
-(void)countDown{
    
    if (!timer) {
        timer=[[BYTimer alloc]init];
    }
    [timer createTimerWithTimeout:60 handlerBlock:^(int presentTime) {
        
        [send setTitle:[NSString stringWithFormat:@"%d秒重发",presentTime] forState:UIControlStateNormal];
        send.userInteractionEnabled=NO;
        
    } finish:^{
        
        [send setTitle:@"获取验证码" forState:UIControlStateNormal];
        send.userInteractionEnabled=YES;
        
    }];
}

//-(void)timeFireMethod{
//
//    secondsCountDown--;
//    [send setTitle: [NSString stringWithFormat:@"%d秒重发",secondsCountDown] forState:UIControlStateNormal];
//    if(secondsCountDown==0){
//        [send setTitle:@"重新发送" forState:UIControlStateNormal];
//        send.userInteractionEnabled=YES;
//        [countDownTimer invalidate];
//
//    }
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==account) {
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
            return NO;
            
        }
        [textField setText:newString];
        
        return NO;
        
    }
    
    return YES;
}
-(void)dismissKeyboard {
    
    for (UIView* view in self.view.subviews ) {
        
        if ([view isKindOfClass:[UITextField class]]) {
            
            [view resignFirstResponder];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField  resignFirstResponder];
    return YES;
}



#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self autoMovekeyBoard:keyboardRect.size.height];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self autoMovekeyBoard:0];
    
    
}
-(void) autoMovekeyBoard: (float) h{
    
    
    if (1) {
        if (h!=0) {
            h=90;
            if (iPhone3_5||iPhone4_0) {
                
                h=90;
            }
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect;
            rect.origin.x= self.view.frame.origin.x;
            rect.origin.y= self.view.frame.origin.y+h;
            rect.size.width= self.view.frame.size.width;
            rect.size.height= self.view.frame.size.height;
            
            self.view.bounds =rect;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}
//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if (textField == account) {
//        if (textField.text.length > 11) {
//            textField.text = [textField.text substringToIndex:11];
//        }
//    }
//}
- (void)dealloc
{
    [timer stopGCDTimer];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

