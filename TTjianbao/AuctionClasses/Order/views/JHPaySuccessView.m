//
//  JHPaySuccessView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAnniversaryOrderBannerView.h"
#import "JHPaySuccessView.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderListViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHOrderPayViewController.h"
#import "TTjianbaoHeader.h"
#import "JHStoreHomePageController.h"
#import "UIImage+JHColor.h"
#import "JHWebViewController.h"
#import "JHCustomizeOrderDetailController.h"
#import "JHCustomizeHomePickupViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHOrderDetailAppraiseStepView.h"
#import "JHC2CProductDetailController.h"



@interface JHPaySuccessView ()<UITextViewDelegate>
{
    UILabel *cash;
    UIButton* completeBtn;
    UIButton* lookOrderBtn;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * titleView;
@property(nonatomic,strong) JHOrderDetailAppraiseStepView *appraiseStepView;
@property(nonatomic,strong) UIView * orderInfoView;
@property(nonatomic,strong) UIView * customizeInfoView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView * combinedOrderInfoView;
@property(nonatomic,strong) UIView * homePickupInfoView;
@property(nonatomic,strong) UITextView *descriptionTextview;
@property(nonatomic,strong) UIView *remindView;
@property(nonatomic,strong) UILabel *remindLabel;
@property(nonatomic,strong) UILabel *descriptionLabel;

@end
@implementation JHPaySuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollview];
    }
    return self;
}

- (void)initScrollview {
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
    [self initCustomizeInfoView];
    [self initCombinedOrderInfoView];
    [self initHomePickupInfoView];
    [self initAppraiseStepView];
    [self initOrderInfoView];
    [self initbottomView];
}

- (void)initTitleView {
    
    _titleView=[[UIView alloc]init];
    _titleView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(170);
        make.width.offset(ScreenW);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"order_pay_success_icon"];
    [_titleView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView).offset(30);
        make.centerX.equalTo(_titleView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=kColor333;
    label.text = @"支付成功";
    label.font=[UIFont fontWithName:kFontMedium size:18];
    [_titleView addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo.mas_bottom).offset(10);
        make.centerX.equalTo(_titleView);
    }];
    
    UIView  *back=[UIView new];
    [_titleView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.centerX.equalTo(_titleView);
        
    }];
    UILabel *cashTitle = [[UILabel alloc] init];
    cashTitle.numberOfLines =1;
    cashTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    cashTitle.lineBreakMode = NSLineBreakByWordWrapping;
    cashTitle.textColor=kColor999;
    cashTitle.text = @"支付金额:";
    cashTitle.font=[UIFont fontWithName:kFontNormal size:15];
    [back addSubview:cashTitle];
    
    [ cashTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(5);
        make.top.bottom.equalTo(back);
    }];
    
    cash = [[UILabel alloc] init];
    cash.numberOfLines =1;
    cash.textAlignment = UIControlContentHorizontalAlignmentCenter;
    cash.lineBreakMode = NSLineBreakByWordWrapping;
    cash.font = [UIFont fontWithName:kFontNormal size:15];
    cash.textColor= kColor999;
    [back addSubview:cash];
    
    [ cash  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cashTitle.mas_right).offset(5);
        make.centerY.equalTo(cashTitle);
        make.right.equalTo(back.mas_right);
    }];
    
}
//引导定制信息展示
-(void)initCustomizeInfoView{
    
    _customizeInfoView=[[UIView alloc]init];
    _customizeInfoView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_customizeInfoView];
    [_customizeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
}
//合并订单去支付信息
-(void)initCombinedOrderInfoView{
    _combinedOrderInfoView = [[UIView alloc]init];
    _combinedOrderInfoView.backgroundColor = [UIColor whiteColor];
    [self.contentScroll addSubview:_combinedOrderInfoView];
    [_combinedOrderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customizeInfoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
}
//上门取件定制信息展示
-(void)initHomePickupInfoView{
    _homePickupInfoView = [[UIView alloc]init];
    _homePickupInfoView.backgroundColor = [UIColor whiteColor];
    [self.contentScroll addSubview:_homePickupInfoView];
    [_homePickupInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_combinedOrderInfoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
}
-(void)initAppraiseStepView{
    
    _appraiseStepView=[[JHOrderDetailAppraiseStepView alloc]init];
    _appraiseStepView.layer.cornerRadius = 0;
    [self.contentScroll addSubview:_appraiseStepView];
    
    [_appraiseStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_homePickupInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(63);
    }];
    
}
-(void)initOrderInfoView{
    
    _orderInfoView=[[UIView alloc]init];
    _orderInfoView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_orderInfoView];
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_appraiseStepView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
}
///引导定制信息展示
-(void)setUpCustomizeSubViews{
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =2;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=kColor333;
    label.text = @"您购买的宝贝支持在线定制服务\n现在是否定制？";
    label.font=[UIFont fontWithName:kFontMedium size:15];
    [_customizeInfoView addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customizeInfoView).offset(10);
        make.centerX.equalTo(_customizeInfoView);
    }];
    
    
    UIButton* introductBtn=[[UIButton alloc]init];
    introductBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [introductBtn setTitle:@"定制服务介绍" forState:UIControlStateNormal];
    introductBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [introductBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    [introductBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    introductBtn.tag=3;
    introductBtn.layer.cornerRadius = 19.0;
    [introductBtn setBackgroundColor:[UIColor whiteColor]];
    introductBtn.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
    introductBtn.layer.borderWidth = 0.5f;
    
    [_customizeInfoView addSubview:introductBtn];
    
    [ introductBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.right.offset(-(ScreenW/2+10));
    }];
    
    UIButton *customizBtn=[[UIButton alloc]init];
    customizBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [customizBtn setTitle:@"去定制" forState:UIControlStateNormal];
    customizBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    customizBtn.layer.borderWidth = 0;
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(120, 38) radius:19];
    customizBtn.tag=4;
    [customizBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
    [customizBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    [customizBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [_customizeInfoView addSubview:customizBtn];
    
    [ customizBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.left.offset(ScreenW/2+10);
    }];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.numberOfLines =2;
    tip.textAlignment = UIControlContentHorizontalAlignmentCenter;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    tip.textColor=kColor999;
    tip.text = @"忽略后，如果想定制可在订单页面中申请操作";
    tip.font=[UIFont fontWithName:kFontNormal size:11];
    [_customizeInfoView addSubview:tip];
    
    [ tip  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introductBtn.mas_bottom).offset(20);
        make.bottom.equalTo(_customizeInfoView.mas_bottom).offset(-30);
        make.centerX.equalTo(_customizeInfoView);
    }];
    
    
}

///上门取件定制信息展示
- (void)setupHomePickupSubView{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kColor333;
    titleLabel.text = @"等待平台联系 免费上门取件";
    titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [_homePickupInfoView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_homePickupInfoView.mas_top).offset(13);
        make.left.equalTo(_homePickupInfoView.mas_left).offset(12);
    }];
    UIImageView *redIcon = [[UIImageView alloc] init];
    redIcon.image = [UIImage imageNamed:@"customize_orderPaySuccess_homePickup_XFL_Icon"];
    [_homePickupInfoView addSubview:redIcon];
    [redIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 15));
        make.left.equalTo(titleLabel.mas_right).offset(4);
        make.centerY.equalTo(titleLabel);
    }];
    
    _descriptionTextview = [[UITextView alloc] init];
    _descriptionTextview.delegate = self;
    _descriptionTextview.editable = NO;
    _descriptionTextview.scrollEnabled = NO;
    _descriptionTextview.textContainerInset = UIEdgeInsetsZero;
    _descriptionTextview.textContainer.lineFragmentPadding = 0;
    _descriptionTextview.linkTextAttributes = @{NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#2F66A0"]};
    [_homePickupInfoView addSubview:_descriptionTextview];
    [_descriptionTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_homePickupInfoView.mas_left).offset(12);
        make.right.equalTo(_homePickupInfoView.mas_right).offset(-12);
    }];
    
    //温馨提示
    UIView *remindView = [[UIView alloc]init];
    self.remindView = remindView;
    remindView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
    remindView.layer.cornerRadius = 5;
    [_homePickupInfoView addSubview:remindView];
    [remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionTextview.mas_bottom).offset(0);
        make.left.equalTo(_homePickupInfoView.mas_left).offset(12);
        make.right.equalTo(_homePickupInfoView.mas_right).offset(-12);
    }];
    UIImageView *remindIcon = [[UIImageView alloc] init];
    remindIcon.image = [UIImage imageNamed:@"customize_orderPaySuccess_remindIcon"];
    [remindView addSubview:remindIcon];
    [remindIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(remindView.mas_top).offset(5);
        make.left.equalTo(remindView.mas_left).offset(8);
    }];
    UILabel *remindLabel = [[UILabel alloc] init];
    self.remindLabel = remindLabel;
    remindLabel.textColor = kColor999;
    remindLabel.numberOfLines = 0;
    remindLabel.text = @"";
    remindLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [remindView addSubview:remindLabel];
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remindView.mas_top).offset(0);
        make.bottom.equalTo(remindView.mas_bottom).offset(0);
        make.left.equalTo(remindIcon.mas_right).offset(4);
        make.right.equalTo(remindView.mas_right).offset(-10);
    }];
    remindView.hidden = YES;
    
    //我要预约上门取件btn
    UIButton *homePickupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homePickupBtn setTitle:@"我要预约免费上门取件" forState:UIControlStateNormal];
    homePickupBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [homePickupBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    [homePickupBtn addTarget:self action:@selector(clickHomePickupBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [homePickupBtn setBackgroundColor:[UIColor whiteColor]];
    homePickupBtn.layer.cornerRadius = 22.0;
    homePickupBtn.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
    homePickupBtn.layer.borderWidth = 0.5f;
    [_homePickupInfoView addSubview:homePickupBtn];
    [homePickupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remindView.mas_bottom).offset(12);
        make.left.equalTo(_homePickupInfoView.mas_left).offset(28);
        make.right.equalTo(_homePickupInfoView.mas_right).offset(-28);
        make.height.offset(44);
        make.bottom.equalTo(_homePickupInfoView.mas_bottom).offset(-15);
    }];
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"telphone"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
        return NO;
    }
    return YES;
}
-(void)clickHomePickupBtnAction:(UIButton *)sender{
    JHCustomizeHomePickupViewController * orderdetail=[[JHCustomizeHomePickupViewController alloc]init];
    orderdetail.orderId = self.mode.orderId;
    orderdetail.fromString = JHFromOrderPaySuccess;//订单支付成功页
    orderdetail.orderMode = self.mode;
    [self.viewController.navigationController pushViewController:orderdetail animated:YES];
    [JHGrowingIO trackEventId:@"dz_zxqj_click"];
}

///合并订单去支付信息
-(void)setupOwnCustomizeSubView{
    
    UIView *imgView = [[UIView alloc]init];
    [_combinedOrderInfoView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_combinedOrderInfoView);
        make.height.offset(90);
    }];
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [CommHelp toUIColorByStr:@"#EEEEEE"];
    lineView1.layer.cornerRadius = 2;
    [imgView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(4);
        make.width.offset(74);
        make.center.equalTo(imgView);
    }];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [CommHelp toUIColorByStr:@"#FFD70F"];
    lineView2.layer.cornerRadius = 2;
    [lineView1 addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(lineView1);
        make.height.offset(4);
        make.width.offset(37);
    }];
    UIImageView *leftImgView = [[UIImageView alloc] init];
    leftImgView.image = [UIImage imageNamed:@"customize_orderPaySuccess_leftIcon"];
    [imgView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 40));
        make.centerY.equalTo(imgView);
        make.right.equalTo(lineView1.mas_left).offset(-22);
    }];
    UIImageView *leftSuccessImgView = [[UIImageView alloc] init];
    leftSuccessImgView.image = [UIImage imageNamed:@"order_pay_success_icon"];
    [imgView addSubview:leftSuccessImgView];
    [leftSuccessImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerX.equalTo(leftImgView.mas_right).offset(-2);
        make.centerY.equalTo(leftImgView.mas_bottom).offset(-2);
    }];
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.textColor = kColor333;
    leftLabel.text = @"原料订单";
    leftLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [imgView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImgView.mas_bottom).offset(11);
        make.centerX.equalTo(leftImgView);
    }];
    
    UIImageView *rightImgView = [[UIImageView alloc] init];
    rightImgView.image = [UIImage imageNamed:@"customize_orderPaySuccess_rightIcon"];
    [imgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 40));
        make.centerY.equalTo(imgView);
        make.left.equalTo(lineView1.mas_right).offset(22);
    }];
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.textColor = kColor333;
    rightLabel.text = @"定制订单";
    rightLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [imgView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightImgView.mas_bottom).offset(11);
        make.centerX.equalTo(rightImgView);
    }];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel = descriptionLabel;
    descriptionLabel.textColor = kColor666;
    descriptionLabel.text = @"定制套餐中【原料订单】已完成支付，请您继续支付【定制订单】若7天内未支付【定制订单】，视为您放弃定制，平台会将原料邮寄给您";
    descriptionLabel.font = [UIFont fontWithName:kFontNormal size:13];
    descriptionLabel.numberOfLines = 0;
    [_combinedOrderInfoView addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(13);
        make.left.equalTo(_combinedOrderInfoView).offset(18);
        make.right.equalTo(_combinedOrderInfoView).offset(-18);
    }];
    
    UIButton *goPayBtn = [[UIButton alloc]init];
    [goPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
    goPayBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
    [goPayBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    [goPayBtn setBackgroundColor:[CommHelp toUIColorByStr:@"#FFD70F"]];
    goPayBtn.layer.cornerRadius = 19.0;
    [goPayBtn addTarget:self action:@selector(clickGoPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_combinedOrderInfoView addSubview:goPayBtn];
    [goPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 38));
        make.centerX.equalTo(_combinedOrderInfoView);
        make.top.equalTo(descriptionLabel.mas_bottom).offset(10);
    }];
    
    UILabel *descriptionLabel2 = [[UILabel alloc] init];
    descriptionLabel2.textColor = kColor999;
    descriptionLabel2.text = @"您可在“个人中心-订单列表”查看订单信息";
    descriptionLabel2.font = [UIFont fontWithName:kFontNormal size:11];
    [_combinedOrderInfoView addSubview:descriptionLabel2];
    [descriptionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goPayBtn.mas_bottom).offset(10);
        make.bottom.equalTo(_combinedOrderInfoView.mas_bottom).offset(-15);
        make.centerX.equalTo(_combinedOrderInfoView);
    }];
    
    
    
}
///是否定制引导 去支付
-(void)clickGoPayBtnAction:(UIButton *)sender{
    //会用到 model的nextOrderId
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
    vc.orderId = self.mode.nextOrderId;
    vc.fromString = JHConfirmFromOrderDialog;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [JHGrowingIO trackEventId:@"dz_order_pay_click"];
    //    [self hiddenAlert];
    //    LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
    //    model.orderCategory = self.model.orderCategory;
    //    [JHGrowingIO trackEventId:JHTracklive_orderreceive_paybtn variables:[model mj_keyValues]];
}

-(void)setupOrderInfo:(NSArray*)titles{
    
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_orderInfoView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.text=[titles objectAtIndex:i];
        title.font=[UIFont fontWithName:kFontNormal size:12];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.textColor=kColor666;
        title.numberOfLines = 2;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        //        UILabel  *desc=[[UILabel alloc]init];
        //        desc.text=[descs objectAtIndex:i];
        //        desc.font=[UIFont systemFontOfSize:14];
        //        desc.textColor=[CommHelp toUIColorByStr:@"#999999"];
        //        desc.numberOfLines = 1;
        //        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        //        desc.lineBreakMode = NSLineBreakByWordWrapping;
        //        [view addSubview:desc];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        //        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        //             make.left.equalTo(title.mas_right).offset(10);
        //              make.right.equalTo(view.mas_right).offset(-10);
        //              make.top.equalTo(title);
        ////              make.centerY.equalTo(view);
        //        }];
        
        //        UIView * line=[[UIView alloc]init];
        //        line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        //        [view addSubview:line];
        //
        //        [line mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            make.left.equalTo(view).offset(15);
        //            make.bottom.equalTo(view).offset(0);
        //            make.right.equalTo(view).offset(-15);
        //            make.height.offset(1);
        //        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(_orderInfoView);
            if (i==0) {
                make.top.equalTo(_orderInfoView).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_orderInfoView).offset(-10);
            }
            
        }];
        
        lastView= view;
    }
}

-(void)initbottomView{
    
    _bottomView=[[UIView alloc]init];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(300);
        make.bottom.equalTo(self.contentScroll);
    }];
    
    lookOrderBtn=[[UIButton alloc]init];
    lookOrderBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [lookOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    lookOrderBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    lookOrderBtn.tag=1;
    [lookOrderBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    lookOrderBtn.layer.cornerRadius = 19.0;
    [lookOrderBtn setBackgroundColor:[UIColor whiteColor]];
    lookOrderBtn.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
    lookOrderBtn.layer.borderWidth = 0.5f;
    [lookOrderBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:lookOrderBtn];
    
    [ lookOrderBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.left.offset(ScreenW/2+10);
    }];
    
    completeBtn=[[UIButton alloc]init];
    completeBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [completeBtn setTitle:@"返回" forState:UIControlStateNormal];
    completeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    completeBtn.tag=2;
    [completeBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    completeBtn.layer.cornerRadius = 19.0;
    [completeBtn setBackgroundColor:[UIColor whiteColor]];
    completeBtn.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
    completeBtn.layer.borderWidth = 0.5f;
    [completeBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:completeBtn];
    
    [ completeBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.right.offset(-(ScreenW/2+10));
    }];
    
    
    JHAnniversaryOrderBannerView *bannerView = [JHAnniversaryOrderBannerView new];
    bannerView.backgroundColor = RGB(216, 216, 216);
    [bannerView jh_cornerRadius:4];
    [self addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(completeBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(70);
    }];
    [bannerView show];
    
}
-(void)setMode:(OrderMode *)mode{
    
    _mode=mode;
    NSMutableArray * titles=[NSMutableArray array];
    [titles addObject:[@"订单号:" stringByAppendingString:OBJ_TO_STRING(_mode.orderCode)]];
    [titles addObject: [@"支付时间:" stringByAppendingString:_mode.payTime?:@""]];
    if (mode.orderCategoryType==JHOrderCategoryRestoreIntention||
        mode.orderCategoryType==JHOrderCategoryResaleIntentionOrder){
        lookOrderBtn.hidden=YES;
        [ completeBtn  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView).offset(100);
            make.height.equalTo(@47);
            make.left.equalTo(_bottomView).offset(20);
            make.right.equalTo(_bottomView).offset(-20);
        }];
    }
    else{
        [titles addObject:[[_mode.shippingReceiverName?:@"" stringByAppendingString:@"    "]stringByAppendingString:_mode.shippingPhone?:@""]];
        [titles addObject:[NSString stringWithFormat:@"收货地址:%@ %@ %@ %@",_mode.shippingProvince?:@"",_mode.shippingCity?:@"",_mode.shippingCounty?:@"",_mode.shippingDetail?:@""]];
        
    }
    
    NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:_mode.payedMoney];
    NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:_mode.orderPrice];
    
    if ([numberPay compare:numberAll]==NSOrderedAscending)
    {
        [completeBtn setTitle:@"继续支付" forState:UIControlStateNormal];
    }
    else{
        [completeBtn setTitle:@"返回" forState:UIControlStateNormal];
        if ([_mode.orderCategory isEqualToString:@"limitedTimeOrder"]) {
            [completeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        }
    }
    [self setupOrderInfo:titles];
    
#warning 之前引导定制的判断
    //    if (_mode.canCustomize&&!_mode.customizeType) {
    //        [_customizeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(_titleView.mas_bottom).offset(10);
    //            make.left.equalTo(self.contentScroll).offset(0);
    //            make.right.equalTo(self.contentScroll).offset(0);
    //        }];
    //        [self setUpCustomizeSubViews];
    //    }
    //支付成功展示类型 0 普通支付成功展示 1 引导定制展示 2 需要上门取件展示 3 组合订单展示
    if ([mode.paymentSuccessShowType isEqualToString:@"1"]) {
        [_customizeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(0);
            make.right.equalTo(self.contentScroll).offset(0);
        }];
        [self setUpCustomizeSubViews];
    }else if ([mode.paymentSuccessShowType isEqualToString:@"3"]) {
        [_combinedOrderInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_customizeInfoView.mas_bottom).offset(10);
        }];
        [self setupOwnCustomizeSubView];
        self.descriptionLabel.text = mode.onlyNormalPayedDesc;
        
    }else if ([mode.paymentSuccessShowType isEqualToString:@"2"]) {
        [_homePickupInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_combinedOrderInfoView.mas_bottom).offset(10);
        }];
        [self setupHomePickupSubView];
        
        NSString *phone1 = mode.platformServiceDialTelStr;
        NSString *phone2 = mode.platformServiceTelStr;
        NSString *time = mode.platformServiceWorkTimeStr;
        NSString *str = [NSString stringWithFormat:@"自有原料定制服务需要邮寄原料，平台客服(%@)会在工作日%@期间与您联系，向您核对信息并预约上门取件 ，请保持手机畅通；\n如需联系客服，请拨打%@",phone1,time,phone2];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:13],NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#333333"]}];
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:13], NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#FF4200"]} range:[[attrString string] rangeOfString:phone1]];
        [attrString addAttributes:@{NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#FF4201"]} range:[[attrString string] rangeOfString:time]];
        [attrString addAttribute:NSLinkAttributeName value:@"telphone://" range:[[attrString string] rangeOfString:phone2]];
        _descriptionTextview.attributedText = attrString;
        
        //疫情温馨提示
        if (mode.keepEpidemicWarnDesc.length > 0) {
            [self.remindView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_descriptionTextview.mas_bottom).offset(12);
            }];
            self.remindLabel.text = mode.keepEpidemicWarnDesc;
            [self.remindLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.remindView.mas_top).offset(7);
                make.bottom.equalTo(self.remindView.mas_bottom).offset(-7);
            }];
            self.remindView.hidden = NO;
        }
        
    }
    
    if (_mode.directDelivery) {
        [_appraiseStepView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_homePickupInfoView.mas_bottom).offset(0);
            make.height.offset(0);
        }];
    }
}
-(void)setPayMoney:(NSString *)payMoney{
    
    cash.text =payMoney;
}
-(void)buttonPress:(UIButton*)button{
    
    if (button.tag==1) {
        if (self.mode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder) {
            JHCustomizeOrderDetailController * orderdetail=[[JHCustomizeOrderDetailController alloc]init];
            orderdetail.orderId=self.mode.orderId;
            [self.viewController.navigationController pushViewController:orderdetail animated:YES];
        }
        else{
            JHOrderDetailViewController * orderdetail=[[JHOrderDetailViewController alloc]init];
            orderdetail.orderId=self.mode.orderId;
            orderdetail.orderCategoryType =self.mode.orderCategoryType;
            [self.viewController.navigationController pushViewController:orderdetail animated:YES];
        }
        
    }
    if (button.tag==2) {
        
        NSDecimalNumber *numberAll = [NSDecimalNumber decimalNumberWithString:self.mode.orderPrice];
        NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.mode.payedMoney];
        
        if ([numberPay compare:numberAll]==NSOrderedAscending) {
            for (UIViewController* vc in self.viewController.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHOrderPayViewController class]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:OrderPayInfoStatusChangeNotifaction object:nil];//
                    [self.viewController.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        }
        
        else{
            
            BOOL  isPop=NO;
            for (UIViewController* vc in self.viewController.navigationController.viewControllers) {
                if ([vc isKindOfClass: [NTESAudienceLiveViewController  class]]) {
                    isPop=YES;
                    [self.viewController.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            for (UIViewController* vc in self.viewController.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHOrderListViewController class]]) {
                    isPop=YES;
                    [self.viewController.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            for (UIViewController* vc in self.viewController.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHStoreHomePageController class]]) {
                    isPop=YES;
                    [self.viewController.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            
            for (UIViewController* vc in self.viewController.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHCustomizeOrderListViewController class]]) {
                    isPop=YES;
                    [self.viewController.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            for (UIViewController* vc in self.viewController.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHC2CProductDetailController class]]) {
                    isPop=YES;
                    [self.viewController.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            
            if (!isPop) {
                [self.viewController.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
    }
    
    else if (button.tag==3){
        
        JHWebViewController *webVC = [JHWebViewController new];
        webVC.urlString = H5_BASE_STRING(@"/jianhuo/app/customization.html");
        webVC.titleString = @"定制服务介绍";
        [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
        [JHGrowingIO trackEventId:@"cust_dzservice_click" variables:@{@"orderId":self.mode.orderId}];
        
    }
    else if (button.tag==4){
        
        BOOL sameRoomId=NO;
        for ( UIViewController *vc in self.viewController.navigationController.viewControllers) {
            if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
                if ([liveVC.channel.channelLocalId isEqualToString:self.mode.channelLocalId]) {
                    sameRoomId = YES;
                    /// 连麦中直接返回，不连麦打开呼起连麦弹层
                    if (liveVC.currentUserRole == CurrentUserRoleLinker) {
                        [self.viewController.navigationController popToViewController:liveVC animated:YES];
                    } else {
                        [JHRootController EnterLiveRoom:liveVC.channel.channelLocalId fromString:@"" isStoneDetail:NO isApplyConnectMic:YES];
                    }
                    break;
                }
                
            }
        }
        if (!sameRoomId) {
            [JHRootController EnterLiveRoom:self.mode.channelLocalId fromString:@"" isStoneDetail:NO isApplyConnectMic:YES];
        }
        
        [JHGrowingIO trackEventId:@"cust_dz_click" variables:@{@"orderId":self.mode.orderId}];
    }
}

@end


