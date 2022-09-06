//
//  JHOrderAgentPayView.h
//  TTjianbao
//
//  Created by jiang on 2019/11/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderAgentPayView.h"
#import "TTjianbaoHeader.h"
#import "BYTimer.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"

@interface JHOrderAgentPayView ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel * titleTip;
    UITextField  *bankCode;
    UIButton * addPhoto;
    BYTimer *timer ;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * titleView;
@property(nonatomic,strong) UIView * infoView;
@property(nonatomic,strong) UIView *inputView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong)    UILabel * remainTime;
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *address;
@property (strong, nonatomic)  UILabel *userPhoneNum;

@property (strong, nonatomic)  UILabel *sallerName;
@property (strong, nonatomic)  UILabel *productPrice;
@property (strong, nonatomic)  UILabel *productTitle;
@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *allPrice;
@end
@implementation JHOrderAgentPayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)]];
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[UIColor whiteColor];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        
    }];
    
    [self initTitleView];
    [self initInfoView];
    [self initbottomView];
}

-(void)initTitleView{
    
    _titleView=[[UIView alloc]init];
    // _titleView.backgroundColor=[CommHelp  toUIColorByStr:@"#fffbdb"];
    [self.contentScroll addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(ScreenW*125./375);
        make.width.offset(ScreenW);
    }];
    UIImageView *back=[[UIImageView alloc]init];
    back.contentMode = UIViewContentModeScaleToFill;
    back.image=[UIImage imageNamed:@"order_agent_title_back"];
    [_titleView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleView);
        make.left.right.equalTo(_titleView);
        
    }];
    
    
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =2;
    label.textAlignment = NSTextAlignmentLeft ;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=kColor333;
    label.text = @"你买宝贝好友付款，点击下面的按钮\n即可找好友帮你付款~";
    label.font=[UIFont systemFontOfSize:13];
    [back addSubview:label];
    [UILabel changeLineSpaceForLabel:label WithSpace:10.0];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        //  make.left.equalTo(logo.mas_right).offset(5);
        make.center.equalTo(back);
        //  make.right.equalTo(back.mas_right);
    }];
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"order_agent_title_icon"];
    [back addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-10);
        make.centerY.equalTo(back);
        make.size.mas_equalTo(CGSizeMake(29, 23));
    }];
    
}
-(void)initInfoView{
    
    _infoView=[[UIView alloc]init];
    _infoView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
    self.allPrice=[[UILabel alloc]init];
    self.allPrice.text=@"";
    self.allPrice.font = [UIFont fontWithName:@"DINAlternate-Bold" size:30];
    self.allPrice.textColor= [UIColor colorWithHexString:@"ff4200"];
    self.allPrice.numberOfLines = 1;
    self.allPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    self.allPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_infoView addSubview:self.allPrice];
    
    [ self.allPrice  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoView).offset(40);
        make.centerX.equalTo(_infoView);
    }];
    
    UIView  *back=[UIView new];
    [_infoView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allPrice.mas_bottom).offset(20);
        make.centerX.equalTo(_infoView);
        make.height.offset(25);
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
        make.left.equalTo(back).offset(5);
        make.centerY.equalTo(label);
    }];
    
    _remainTime=[[UILabel alloc]init];
    _remainTime.text=@"";
    _remainTime.font=[UIFont systemFontOfSize:13];
    _remainTime.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _remainTime.numberOfLines = 1;
    _remainTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _remainTime.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:_remainTime];
    
    [_remainTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5);
        make.right.equalTo(back.mas_right);
        make.centerY.equalTo(label);
    }];
    
    UIButton* share=[[UIButton alloc]init];
    share.translatesAutoresizingMaskIntoConstraints=NO;
    [share setTitle:@"分享给好友代付" forState:UIControlStateNormal];
    share.titleLabel.font=[UIFont systemFontOfSize:18];
    [share setBackgroundColor:kColorMain];
    [share setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:share];
    
    [share  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(back.mas_bottom).offset(20);
        make.height.equalTo(@44);
        make.centerX.equalTo(_infoView);
        make.width.offset(250);
        make.bottom.equalTo(_infoView).offset(-50);
    }];
    
}
-(void)initbottomView{
    
    UIView  * lineView=[[UIView alloc]init];
    lineView.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    [self.contentScroll addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(10);
    }];
    
    _bottomView=[[UIView alloc]init];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.bottom.equalTo(self.contentScroll);
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"代付说明：\n\n1、请在规定时间内完成支付，超时订单将取消\n2、若发生退货退款，支付金额将原路返回给您的好友";
    title.font=[UIFont systemFontOfSize:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#999999"];
    title.numberOfLines = 5;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_bottomView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(10);
        make.left.equalTo(_bottomView).offset(10);
        make.right.equalTo(_bottomView).offset(0);
          make.bottom.equalTo(_bottomView);
    }];
    
}
-(void)setMoney:(double)money{
     _money=money;
     self.allPrice.text=[NSString stringWithFormat:@"¥ %.2f",_money];
}
-(void)setOrderMode:(OrderMode *)orderMode{
    
    _orderMode=orderMode;
    if (!timer) {
        timer=[[BYTimer alloc]init];
    }
    JH_WEAK(self)
    [timer createTimerWithTimeout:[CommHelp dateRemaining:_orderMode.payExpireTime] handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        self.remainTime.text=[CommHelp getHMSWithSecond:presentTime];
    } finish:^{
        JH_STRONG(self)
        self.remainTime.text = @"订单已取消";
    }];
}
-(void)share{
    
    if (self.handle) {
        self.handle();
    }
}
-(UILabel*)getTitleLabel:(NSString*)text{
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=text;
    title.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    title.textColor=kColor666;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    
    return title;
}
@end


