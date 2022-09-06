//
//  PhoneNumberLoginViewController.m
//  TTjianbao
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
//


#import "AlterPhoneNumberViewController.h"

#import "NTESService.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESLogManager.h"
#import "NewPhoneNumberViewController.h"

#import "TTjianbaoBussiness.h"

@interface AlterPhoneNumberViewController ()<UITextFieldDelegate>
{
    UITextField* account;
    UITextField* password;
    UIView * passwordView;
    UIButton*  send;
    NSTimer*   __weak countDownTimer;
    int secondsCountDown;
    NSString * loginAccount;
    NSString * loginToken;
    
}
@property(strong,nonatomic)UIButton* loginButton;
@end

@implementation AlterPhoneNumberViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"修改手机号";
    [self jeneralAccountLoginView];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(250);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.offset(45);
    }];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view  addGestureRecognizer:tap];
    
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
    account.userInteractionEnabled=NO;
    account.font=[UIFont systemFontOfSize:16];
    [accountView addSubview:account];
    
    [userNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView).offset(15);
        make.centerY.equalTo(accountView);
        
    }];
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    account.text=user.mobile;
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
        [_loginButton setTitle:@"下一步" forState:UIControlStateNormal];
        _loginButton.titleLabel.font=[UIFont systemFontOfSize:17];
        [_loginButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[[UIImage imageNamed:@"alterphone_press_btn.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginButton;
    
}
-(void)cancle{
    
    [countDownTimer invalidate];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
-(void)send{
    
    if ([account.text length]!=11) {
        [self.view makeToast:@"请输入正确手机号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *captchaCode=[CommHelp md5:[NSString stringWithFormat:@"%@_%@",account.text,@"d94b7176048568a5fa6f8f19e0ba976e"]];
    NSDictionary * parameters=@{
                                @"apisign":captchaCode,
                                 @"type":@"changeMobile1",
                                 @"mobile":account.text
                                };
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/sendPhoneSms") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"发送成功" duration:1.0 position:CSToastPositionCenter];
         send.userInteractionEnabled=NO;
         [password becomeFirstResponder];
         secondsCountDown = 60;//60秒倒计时
         [send setTitle:@"60秒重发" forState:UIControlStateNormal];
        if (countDownTimer) {
            [countDownTimer invalidate];
        }
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
  
}
-(void)complete{
    
    if ([account.text length]!=11)
    {[self.view makeToast:@"请输入正确手机号" duration:1.0 position:CSToastPositionCenter];return;
    }
    if ([password.text length]<=0) {
        [self.view makeToast:@"请输入验证码" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    [self.view endEditing:YES];
    NSDictionary * parameters=@{
                                @"smsCode":password.text,
                                };
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/auth/customer/change/mobile/1") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        NewPhoneNumberViewController * vc=[[NewPhoneNumberViewController alloc]init];
        vc.oldVerifyCode=respondObject.data;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
        
    }];
    
    [SVProgressHUD show];
   
}

-(void)timeFireMethod{
    
    secondsCountDown--;
    [send setTitle: [NSString stringWithFormat:@"%d秒重发",secondsCountDown] forState:UIControlStateNormal];
    if(secondsCountDown==0){
        [send setTitle:@"重新发送" forState:UIControlStateNormal];
        send.userInteractionEnabled=YES;
        [countDownTimer invalidate];
        
    }
}
#pragma mark =============== UITextFieldDelegate ===============
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == account) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
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
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == account) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
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



