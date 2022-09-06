//
//  JHBankPayView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBankPayView.h"
#import "WXPayDataMode.h"
#import "TTjianbaoHeader.h"
#import "JHQYChatManage.h"

@interface JHBankPayView ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel * titleTip;
    UITextField  *bankCode;
    UIButton * addPhoto;
    
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * remainTimeView;
@property(nonatomic,strong) UIView * bankInfoView;
@property(nonatomic,strong) UIView *inputView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UILabel * remainTime;
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *address;
@property (strong, nonatomic)  UILabel *userPhoneNum;

@property (strong, nonatomic)  UILabel *sallerName;
@property (strong, nonatomic)  UILabel *productPrice;
@property (strong, nonatomic)  UILabel *productTitle;
@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *allPrice;
@property (strong, nonatomic)  NSMutableArray <UILabel*> *labelArr;
@end
@implementation JHBankPayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.backgroundColor=[UIColor redColor];
        [self initScrollview];
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)]];
    }
    return self;
}

-(void)dismissKeyboard{
    
    [self endEditing:YES];
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        
    }];
    
    [self initTitleView];
    [self initBankInfoView];
    [self initInputView];
    [self initbottomView];
}

-(void)initTitleView{
    
    _remainTimeView=[[UIView alloc]init];
    _remainTimeView.backgroundColor=[CommHelp  toUIColorByStr:@"#fffbdb"];
    [self.contentScroll addSubview:_remainTimeView];
    
    [_remainTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(30);
        make.width.offset(ScreenW);
    }];
    
    UIView  *back=[UIView new];
    [_remainTimeView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_remainTimeView);
        make.centerX.equalTo(_remainTimeView);
        
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"bank_Tip"];
    [back addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back);
        make.centerY.equalTo(back);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.textAlignment = UIControlContentHorizontalAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    label.text = @"转账时请务必备注订单号后四位或手机号";
    label.font=[UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:0.48f green:0.58f blue:0.61f alpha:1.00f];
    [back addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(logo);
          make.right.equalTo(back.mas_right);
    }];
    
}
-(void)initBankInfoView{
    
    _bankInfoView=[[UIView alloc]init];
    _bankInfoView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_bankInfoView];
    [_bankInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remainTimeView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
      
    }];
   
    _labelArr=[NSMutableArray array];
    NSArray * titles=@[@"收款账户名:",@"开户行:",@"账号:"];
    
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_bankInfoView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.text=[titles objectAtIndex:i];
        title.font=[UIFont systemFontOfSize:14];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[CommHelp toUIColorByStr:@"#999999"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.text=[titles objectAtIndex:i];
        desc.font=[UIFont systemFontOfSize:14];
        desc.backgroundColor=[UIColor clearColor];
        desc.textColor=[CommHelp toUIColorByStr:@"#999999"];
        desc.numberOfLines = 1;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        [_labelArr addObject:desc];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(5);
            make.centerY.equalTo(view);
        }];
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).offset(10);
            make.centerY.equalTo(view);
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"bank_button"] forState:UIControlStateNormal];
         button.contentMode=UIViewContentModeScaleAspectFit;
        [button setTitle:@"复制" forState:UIControlStateNormal];
         button.tag=i;
         button.titleLabel.font=[UIFont systemFontOfSize:13];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view).offset(15);
            make.bottom.equalTo(view).offset(0);
            make.right.equalTo(view).offset(-15);
            make.height.offset(1);
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.left.right.equalTo(_bankInfoView);
            if (i==0) {
                make.top.equalTo(_bankInfoView);
            }
            else{
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i==[titles count]-1) {
                
                make.bottom.equalTo(_bankInfoView);
            }
        }];
        
        lastView= view;
    }
    
}

-(void)initInputView{
    
    _inputView=[[UIView alloc]init];
    _inputView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(60);
    }];
    
    UILabel *  title=[[UILabel alloc]init];
    title.text=@"转账账户";
    title.font=[UIFont systemFontOfSize:15];
    title.textColor=[CommHelp toUIColorByStr:@"#222222"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_inputView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputView);
        make.left.equalTo(_inputView).offset(10);
    }];
    
    bankCode=[[UITextField alloc]init];
    bankCode.backgroundColor=[UIColor clearColor];
    bankCode.tintColor = [UIColor colorWithRed:1.00f green:0.40f blue:0.42f alpha:1.00f];
    bankCode.returnKeyType =UIReturnKeyDone;
    bankCode.delegate=self;
    bankCode.keyboardType = UIKeyboardTypeNumberPad;
    bankCode.placeholder=@"输入您的银行卡账号";
    bankCode.font=[UIFont systemFontOfSize:16];
    [_inputView addSubview:bankCode];
    
    //
    [bankCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_inputView).offset(-10);
        make.left.equalTo(title.mas_right).offset(10);
        make.top.bottom.equalTo(_inputView);
        
    }];
    
}

-(void)initbottomView{
    
    
    _bottomView=[[UIView alloc]init];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
      
        make.bottom.equalTo(self.contentScroll);
    }];
    
    UILabel  *tip=[[UILabel alloc]init];
    tip.text=@"上传转账凭证";
    tip.font=[UIFont systemFontOfSize:15];
    tip.backgroundColor=[UIColor clearColor];
    tip.textColor=[CommHelp toUIColorByStr:@"#222222"];
    tip.numberOfLines = 1;
    tip.textAlignment = UIControlContentHorizontalAlignmentCenter;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    [_bottomView addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(10);
        make.left.equalTo(_bottomView).offset(10);
        make.right.equalTo(_bottomView).offset(-10);
    }];
    addPhoto=[[UIButton alloc]init];
    addPhoto.contentMode=UIViewContentModeScaleAspectFit;
    [addPhoto  setBackgroundImage:[UIImage imageNamed:@"bankpay_addphoto"] forState:UIControlStateNormal];
    [addPhoto addTarget:self action:@selector(photoImageSelect:) forControlEvents:UIControlEventTouchUpInside];
     [_bottomView addSubview:addPhoto];
     [addPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip.mas_bottom).offset(10);
        make.left.equalTo(_bottomView).offset(10);
        make.size.mas_equalTo(CGSizeMake(120,120));
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"若您已完成转账并已上传转账凭证，请等待平台确认收款，到账时间通常为1-2个工作日";
    title.font=[UIFont systemFontOfSize:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#999999"];
    title.numberOfLines = 2;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_bottomView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addPhoto.mas_bottom).offset(10);
        make.left.equalTo(_bottomView).offset(10);
        make.right.equalTo(_bottomView).offset(-10);
    }];
    
    UIView * backView=[[UIView alloc]init];
    [_bottomView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(30);
        make.centerX.equalTo(_bottomView);
         make.height.equalTo(@50);
    }];
    
    UILabel  *serveTitle=[[UILabel alloc]init];
    serveTitle.text=@"支付遇到问题？请联系";
    serveTitle.font=[UIFont systemFontOfSize:13];
    serveTitle.backgroundColor=[UIColor clearColor];
    serveTitle.textColor=[CommHelp toUIColorByStr:@"#999999"];
    serveTitle.numberOfLines = 1;
    serveTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
    serveTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [backView addSubview:serveTitle];
    
    [serveTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.left.equalTo(backView).offset(10);
        
    }];
    
    UIButton  *serverBtn=[[UIButton alloc]init];
    [serverBtn setTitle:@"官方客服" forState:UIControlStateNormal];
    serverBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [serverBtn setTitleColor:[UIColor colorWithRed:0.22f green:0.60f blue:0.85f alpha:1.00f] forState:UIControlStateNormal];
    serverBtn.backgroundColor=[UIColor clearColor];
    [serverBtn addTarget:self action:@selector(Contact) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:serverBtn];

    [serverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.equalTo(backView);
         make.right.equalTo(backView).offset(-5);
         make.left.equalTo(serveTitle.mas_right).offset(5);
    }];
    
    
    UIButton* _completeBtn=[[UIButton alloc]init];
    _completeBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [_completeBtn setTitle:@"确定" forState:UIControlStateNormal];
    _completeBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [_completeBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    [_completeBtn setBackgroundImage:[[UIImage imageNamed:@"commentButonImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_completeBtn setBackgroundImage:[[UIImage imageNamed:@"commentButonImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    [_completeBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:_completeBtn];
    
    [ _completeBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(serveTitle.mas_bottom).offset(20);
         make.bottom.equalTo(_bottomView);
         make.height.equalTo(@47);
         make.left.offset(10);
         make.right.offset(-10);
    }];
    
}
-(void)setBankPayMode:(BankPayDataMode *)bankPayMode{
    
    _bankPayMode=bankPayMode;
    _labelArr[0].text=_bankPayMode.accountName;
    _labelArr[1].text=_bankPayMode.bankBranch;
    _labelArr[2].text=_bankPayMode.accountNo;
    
}
-(void)setButtonImage:(UIImage *)buttonImage{
    
   [addPhoto  setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
}
-(void)buttonPress:(UIButton*)button{
    
     [self makeToast:@"复制成功!" duration:1.0 position:CSToastPositionCenter];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _labelArr[button.tag].text;
    
}
-(void)Contact{
    
      [[JHQYChatManage shareInstance] showChatWithViewcontroller:self.viewController];

    
}
-(void)complete{
    
    if ([bankCode.text length]<=0) {
        [self makeToast:@"请输入银行卡号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (self.delegate) {
        [self.delegate Complete:bankCode.text];
    }
    
}
-(void)photoImageSelect:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate addPhoto];
    }
}
#pragma mark =============== delegate ===============

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [titleTip setHidden:NO];
    }else{
        [titleTip setHidden:YES];
    }
}
@end

