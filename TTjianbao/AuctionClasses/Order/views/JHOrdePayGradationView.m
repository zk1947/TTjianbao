//
//  JHOrdePayGradationView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrdePayGradationView.h"
#import "PayMode.h"
#import "TTjianbaoHeader.h"
#import "BYTimer.h"
#import "JHQYChatManage.h"

@interface JHOrdePayGradationView ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIView *adressInfoView;
    UIView *adressAddView;
    UITextView *noteTextview;
    UILabel * titleTip;
    UIView* progressLabelBack ;
    BYTimer *timer ;
    UIProgressView *processView;
    UILabel *_status;
    UILabel *  _remainPrice;
    UITextField  *cash;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * remainTimeView;
@property(nonatomic,strong) UIView *productView;
@property(nonatomic,strong) UIView *gradationView;
@property(nonatomic,strong) UIView *payWayView;

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

@property (strong, nonatomic)  PayWayMode *payWayMode;
@end
@implementation JHOrdePayGradationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
        [self initBottomView];
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
    [self initProductView];
    [self initOrderGradationView];
    [self initPayWayView];
    
}
-(void)initTitleView{
    
    _remainTimeView=[[UIView alloc]init];
    _remainTimeView.backgroundColor=[CommHelp  toUIColorByStr:@"#fffbdb"];
    [self.contentScroll addSubview:_remainTimeView];
    
    [_remainTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(60);
        make.width.offset(ScreenW);
    }];
    
    UIView  *back=[UIView new];
    [_remainTimeView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remainTimeView).offset(5);
        make.centerX.equalTo(_remainTimeView);
        make.height.offset(25);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"order_confirm_time_logo"];
    [back addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back);
        make.centerY.equalTo(back);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.textAlignment = UIControlContentHorizontalAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    label.text = @"剩余支付时间";
    label.font=[UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:0.48f green:0.58f blue:0.61f alpha:1.00f];
    [back addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(logo);
    }];
    
    _remainTime=[[UILabel alloc]init];
    _remainTime.text=@"12:14";
    _remainTime.font=[UIFont systemFontOfSize:13];
    _remainTime.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _remainTime.numberOfLines = 1;
    _remainTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _remainTime.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:_remainTime];
    
    [_remainTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5);
        make.right.equalTo(back.mas_right);
        make.centerY.equalTo(logo);
        
    }];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.numberOfLines =1;
    tip.textAlignment = UIControlContentHorizontalAlignmentLeft;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    tip.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    tip.text = @"天天鉴宝郑重承诺您确认收货后，卖家才会收到货款，请放心购买";
    tip.font=[UIFont boldSystemFontOfSize:13];
    [_remainTimeView addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_remainTimeView);
        make.top.equalTo(back.mas_bottom).offset(5);
    }];
    
}
-(void)initProductView{
    
    _productView=[[UIView alloc]init];
    _productView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_productView];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remainTimeView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(80);
    }];
    
    UIView * back=[[UIView alloc]init];
    [_productView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(_productView);
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"待支付:";
    title.font=[UIFont systemFontOfSize:14];
    //    title.backgroundColor=[UIColor greenColor];
    title.textColor=[CommHelp toUIColorByStr:@"#666666"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(back);
        make.left.equalTo(back).offset(10);
    }];
    
    _allPrice=[[UILabel alloc]init];
    _allPrice.text=@"¥1000";
    _allPrice.font = [UIFont fontWithName:kFontBoldDIN size:22.f];
    //    _allPrice.backgroundColor=[UIColor yellowColor];
    _allPrice.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _allPrice.numberOfLines = 1;
    [_allPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _allPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _allPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:_allPrice];
    
    [_allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.left.equalTo(title.mas_right).offset(5);
        make.right.equalTo(back.mas_right).offset(-10);
    }];
    
}
-(void)initOrderGradationView{
    
    _gradationView=[[UIView alloc]init];
    _gradationView.backgroundColor=[UIColor whiteColor];
    _gradationView.layer.masksToBounds=YES;
    [self.contentScroll addSubview:_gradationView];
    
    [_gradationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(170);
    }];
    
    UIView *processBack=[[UIView alloc]init];
    [_gradationView addSubview:processBack];
    
    [processBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gradationView).offset(20);
        make.left.equalTo(_gradationView).offset(15);
        make.right.equalTo(_gradationView).offset(-15);
    }];
    
    progressLabelBack = [[UIView alloc] init];
    progressLabelBack.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    progressLabelBack.layer.cornerRadius = 2;
    progressLabelBack.alpha=0.8;
    [processBack addSubview:progressLabelBack];
    
    [progressLabelBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@22);
        make.top.equalTo(processBack);
        make.left.equalTo(processBack).offset(0);
    }];
    
    _status=[[UILabel alloc]init];
    _status.text=@"";
    _status.font=[UIFont systemFontOfSize:12];
    _status.textColor=[CommHelp toUIColorByStr:@"#fee100"];
    _status.numberOfLines = 1;
    _status.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _status.lineBreakMode = NSLineBreakByWordWrapping;
    [progressLabelBack addSubview:_status];
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(progressLabelBack);
        make.right.equalTo(progressLabelBack).offset(-5);
        make.left.equalTo(progressLabelBack).offset(5);
    }];
    
    processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    processView.trackTintColor = [CommHelp toUIColorByStr:@"#eeeeee"];
    processView.progressTintColor = [CommHelp toUIColorByStr:@"#ffe300"];
    processView.progress = 0;
    [processBack addSubview:processView];
    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(progressLabelBack.mas_bottom).offset(5);
        make.left.equalTo(processBack);
        make.right.equalTo(processBack);
        make.height.offset(5);
    }];
    
    UILabel * beginTitle=[[UILabel alloc]init];
    beginTitle.text=@"已支付";
    beginTitle.font=[UIFont systemFontOfSize:14];
    beginTitle.backgroundColor=[UIColor clearColor];
    beginTitle.textColor=[CommHelp toUIColorByStr:@"#999999"];
    beginTitle.numberOfLines = 1;
    beginTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    beginTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [processBack addSubview:beginTitle];
    
    [beginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processView.mas_bottom).offset(5);
        make.left.equalTo(processBack).offset(0);
        make.bottom.equalTo(processBack);
    }];
    
    //    UILabel * endTitle=[[UILabel alloc]init];
    //    endTitle.text=@"总金额";
    //    endTitle.font=[UIFont systemFontOfSize:14];
    //    endTitle.backgroundColor=[UIColor clearColor];
    //    endTitle.textColor=[CommHelp toUIColorByStr:@"#666666"];
    //    endTitle.numberOfLines = 1;
    //    endTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    //    endTitle.lineBreakMode = NSLineBreakByWordWrapping;
    //    [_gradationView addSubview:endTitle];
    
     _remainPrice=[[UILabel alloc]init];
    _remainPrice.text=@"";
    _remainPrice.font = [UIFont fontWithName:kFontBoldDIN size:22.f];
    _remainPrice.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _remainPrice.numberOfLines = 1;
    [_remainPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _remainPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _remainPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_gradationView addSubview:_remainPrice];
    
    [_remainPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processView.mas_bottom).offset(5);
        make.right.equalTo(processBack).offset(0);
        
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"合计:";
    title.font=[UIFont systemFontOfSize:14];
    title.textColor=[CommHelp toUIColorByStr:@"#666666"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_gradationView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_remainPrice);
        make.right.equalTo(_remainPrice.mas_left).offset(-10);
        
    }];
    
    UIImageView* cashBackImage= [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"order_inputcash_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(10,0,10,0)resizingMode:UIImageResizingModeStretch]];
    cashBackImage.userInteractionEnabled=YES;
    [_gradationView addSubview:cashBackImage];
    
    [cashBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginTitle.mas_bottom).offset(20);
        make.right.equalTo(_gradationView).offset(-10);
        make.left.equalTo(_gradationView).offset(10);
        make.height.offset(45);
    }];
    
    cash=[[UITextField alloc]init];
    cash.backgroundColor=[UIColor clearColor];
    cash.tag=1;
    cash.tintColor = [UIColor colorWithRed:1.00f green:0.40f blue:0.42f alpha:1.00f];
    cash.returnKeyType =UIReturnKeyDone;
    cash.delegate=self;
    cash.textAlignment = UIControlContentHorizontalAlignmentLeft;
    cash.keyboardType = UIKeyboardTypeDecimalPad;
    cash.placeholder=@"输入金额最少1000元";
    cash.font=[UIFont systemFontOfSize:16];
    [cashBackImage addSubview:cash];
    
    //
    [cash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cashBackImage);
        make.width.equalTo(@200);
        make.top.bottom.equalTo(cashBackImage);
    }];
    
    UIView  * back=[[UIView alloc]init];
    [_gradationView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_gradationView);
        make.top.equalTo(cashBackImage.mas_bottom).offset(10);
        make.height.offset(0);
    }];
    
}

-(void)initPayWayView{
    
    UILabel  *viewTitle=[[UILabel alloc]init];
    viewTitle.text=@"付款方式";
    viewTitle.font=[UIFont systemFontOfSize:13];
    viewTitle.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
    viewTitle.textColor=[CommHelp toUIColorByStr:@"#999999"];
    viewTitle.numberOfLines = 1;
    viewTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentScroll addSubview:viewTitle];
    
    [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gradationView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(30);
    }];
    
    _payWayView=[[UIView alloc]init];
    _payWayView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_payWayView];
    
    [_payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTitle.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
    
}
-(void)initPayWaySubviews:(NSArray*)arr{
    
 
    
    UIView * lastView;
    for (int i=0; i<[arr count]; i++) {
        
        PayWayMode * payMode =arr[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(payWayViewTap:)]];
        [_payWayView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.text=payMode.name;
        title.font=[UIFont systemFontOfSize:15];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UIImageView * logo=[[UIImageView alloc]init];
        [logo jhSetImageWithURL:[NSURL URLWithString:payMode.icon]];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [logo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [logo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [view addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(25,40));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logo.mas_right).offset(5);
            make.centerY.equalTo(view);
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"order_pay_button"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"order_pay_button_select"] forState:UIControlStateSelected];
        button.contentMode=UIViewContentModeScaleAspectFit;
        button.userInteractionEnabled=NO;
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
        }];
        button.selected=NO;
        if (payMode.isDefault) {
            button.selected=YES;
            self.payWayMode=payMode;
        }
        
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
            make.left.right.equalTo(_payWayView);
            if (i==0) {
                make.top.equalTo(_payWayView);
            }
            else{
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i==[arr count]-1) {
                
                make.bottom.equalTo(_payWayView);
            }
            
        }];
        
        lastView= view;
    }
    
}
-(void)initBottomView{
    
    UIView * bottom=[[UIView alloc]init];
    [self.contentScroll addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payWayView.mas_bottom).offset(50);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.bottom.equalTo(self.contentScroll).offset(-10);
    }];
    
    UIView * backView=[[UIView alloc]init];
    [bottom addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom).offset(10);
        make.centerX.equalTo(bottom);
        make.height.equalTo(@30);
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
        make.left.equalTo(serveTitle.mas_right).offset(0);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"commentButonImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"commentButonImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottom).offset(10);
        make.right.equalTo(bottom).offset(-10);
        make.top.equalTo(backView.mas_bottom).offset(5);
        make.height.offset(47);
        make.bottom.equalTo(bottom);
    }];
}
-(void)Contact{
    
    [[JHQYChatManage shareInstance] showChatWithViewcontroller:self.viewController];
    
}
-(void)payWayViewTap:(UITapGestureRecognizer*)tap{
    
    [self cancleButtonSelect:self.payWayView];
    UITapGestureRecognizer *tapView=(UITapGestureRecognizer*)tap;
    for (UIView * view in tapView.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn=(UIButton*)view;
            btn.selected=YES;
        }
    }
    self.payWayMode=self.payWayArray[tap.view.tag];
    
}
- (void)cancleButtonSelect:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            btn.selected=NO;
        } else {
            [self cancleButtonSelect:subView];
        }
    }
}
-(void)setOrderMode:(OrderMode *)orderMode{
   
    _orderMode = orderMode;
    _allPrice.text=[NSString stringWithFormat:@"¥ %.2f",[_orderMode.orderPrice doubleValue]-[_orderMode.payedMoney doubleValue]];
    _remainTime.text=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:_orderMode.payExpireTime]];
    JH_WEAK(self)
    if (!self.orderMode.payedMoney) {
        self.orderMode.payedMoney=@"0";
    }
    _status.text=[NSString stringWithFormat:@"¥%@",self.orderMode.payedMoney];
    _remainPrice.text=[NSString stringWithFormat:@"¥%@",self.orderMode.orderPrice];
    
    double rate =[self.orderMode.payedMoney doubleValue]/
                                                    [self.orderMode.orderPrice doubleValue];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:1.0f animations:^{
        
        [processView setProgress:rate animated:YES];
        if ((ScreenW-30)*rate<=progressLabelBack.mj_w/2) {
            progressLabelBack.center = CGPointMake(progressLabelBack.mj_w/2, progressLabelBack.center.y);
        }
        else if ((ScreenW-30)*rate>=ScreenW-30-progressLabelBack.mj_w/2) {
            progressLabelBack.center = CGPointMake(ScreenW-30-progressLabelBack.mj_w/2, progressLabelBack.center.y);
        }
        else{
            progressLabelBack.center = CGPointMake((ScreenW-30)*rate, progressLabelBack.center.y);
        }
        
    }];
    
    

    if (!timer) {
        timer=[[BYTimer alloc]init];
    }
    [timer createTimerWithTimeout:[CommHelp dateRemaining:_orderMode.payExpireTime] handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        self.remainTime.text=[CommHelp getHMSWithSecond:presentTime];
    } finish:^{
        JH_STRONG(self)
        self.remainTime.text = @"订单已取消";
    }];
}
-(void)setPayWayArray:(NSArray *)payWayArray{
    
    _payWayArray=payWayArray;
    [self initPayWaySubviews:_payWayArray];
}

-(void)onClickBtnAction:(UIButton*)sender{
    
    
    if ([cash.text doubleValue]<[self.orderMode.payBatchMin doubleValue]) {
        [self makeToast: [NSString stringWithFormat:@"分次金额不得少于%@",self.orderMode.payBatchMin] duration:1.0 position:CSToastPositionCenter];
           return;
    }
    
    if ([self isMoreThanPayMoney]) {
        [self makeToast:@"支付金额已超出订单金额" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(Complete:andPayMoney:)]) {
        
        [self.delegate Complete:self.payWayMode andPayMoney:[cash.text doubleValue]];
    }
    
}
-(BOOL)isMoreThanPayMoney{
    
    NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:self.orderMode.orderPrice];
    NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.orderMode.payedMoney];
    NSDecimalNumber *numResult = [numberAll decimalNumberBySubtracting:numberPay];
   
    if ([[NSDecimalNumber decimalNumberWithString:cash.text] compare:numResult]==NSOrderedDescending) {
        return  YES;
    }
      return NO;
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
- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}
@end


