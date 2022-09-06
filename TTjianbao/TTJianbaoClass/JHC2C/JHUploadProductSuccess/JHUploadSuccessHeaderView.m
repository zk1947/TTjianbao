//
//  JHUploadSuccessHeaderView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUploadSuccessHeaderView.h"
#import "BYTimer.h"
#import "JHCouponListView.h"
#import "JHMallCoponListView.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
#import "JHUIFactory.h"
#import "JHItemMode.h"
#import "JHWebViewController.h"
#import "JHC2CProductDetailController.h"
#import "JHAppraisePayView.h"
#import "JHC2CSelectClassViewController.h"
#import "JHMarketOrderViewModel.h"
#import "JHMarketOrderListViewController.h"
#import "UIImage+JHColor.h"
@interface JHUploadSuccessHeaderView ()
{
    BYTimer *timer;
}
@property(nonatomic,strong) UIView * headerTitleView;
@property(nonatomic,strong) UIView * buttonView;
@property(nonatomic,strong)  UILabel *remainTimeLabel;
@property(nonatomic,strong)  UILabel *appraiseTimeLabel;
@property(nonatomic,strong) UIButton *goOnPublishBtn;
@end
@implementation JHUploadSuccessHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIView alloc]init];
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#ffffff"];
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self initButtonView];
    
}
-(void)initTitleView{
    
    _headerTitleView=[[UIView alloc]init];
    [self.contentScroll addSubview:_headerTitleView];
    [_headerTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
    
}

-(void)initButtonView{
    
    _buttonView=[[UIView alloc]init];
    _buttonView.backgroundColor=[UIColor whiteColor];
    _buttonView.layer.cornerRadius = 8;
    _buttonView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_buttonView];
    
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTitleView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(130);
        make.bottom.equalTo(self.contentScroll).offset(-10);
        
    }];
    [self lookBtn];
    [self shareBtn];
  //  [_buttonView addSubview:];
   // [_buttonView addSubview:];
    
    
    _goOnPublishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_goOnPublishBtn setTitle:@"继续发布" forState:UIControlStateNormal];
    [_goOnPublishBtn setTitleColor:kColor222 forState:UIControlStateNormal];
    _goOnPublishBtn.titleLabel.font=[UIFont fontWithName:kFontMedium size:16];
    _goOnPublishBtn.layer.cornerRadius = 8;
    _goOnPublishBtn.layer.masksToBounds = YES;
    _goOnPublishBtn.layer.borderWidth = 0.5;
    _goOnPublishBtn.layer.borderColor = kColor333.CGColor;
    [_goOnPublishBtn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_goOnPublishBtn];
    
    [_goOnPublishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_buttonView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(310, 50));
        make.centerX.equalTo(_buttonView);
        // make.top.equalTo(_buttonView).offset(50);
    }];
    
   
}
-(void)lookBtn{
    
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    view.userInteractionEnabled=YES;
    view.layer.masksToBounds=YES;
    [view  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(Look:)]];
    [_buttonView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonView).offset(10);
        make.left.equalTo(_buttonView).offset(0);
        make.width.offset(ScreenW/2);
        make.height.offset(50);
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"查看宝贝";
    title.font=[UIFont fontWithName:kFontNormal size:14];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_upload_success_button_icon1"]];
    icon.backgroundColor=[UIColor clearColor];
    [icon setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [icon setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(title.mas_left).offset(-5);
        make.centerY.equalTo(view);
        
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(5);
        make.centerY.equalTo(view);
        
    }];
    
  
    
   // return view;
}

-(void)shareBtn{
    
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    view.userInteractionEnabled=YES;
    view.layer.masksToBounds=YES;
    [view  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(Share:)]];
    [_buttonView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonView).offset(10);
        make.right.equalTo(_buttonView).offset(0);
        make.width.offset(ScreenW/2);
        make.height.offset(50);
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"去分享";
    title.font=[UIFont fontWithName:kFontNormal size:14];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_upload_success_button_icon1"]];
    icon.backgroundColor=[UIColor clearColor];
    [icon setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [icon setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(title.mas_left).offset(-5);
        make.centerY.equalTo(view);
        
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(5);
        make.centerY.equalTo(view);
        
    }];
    
    UIImageView *bubble=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_upload_success_button_bubble"]];
    bubble.backgroundColor=[UIColor clearColor];
    bubble.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentScroll addSubview:bubble];
    
    [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(title.mas_top).offset(-5);
        make.centerX.equalTo(title);
        
    }];
    JHCustomLine *line = [JHUIFactory createLine];
    [_buttonView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.height.offset(18);
        make.centerX.equalTo(_buttonView);
        make.centerY.equalTo(view);
    }];
 //   return view;
}
-(void)initHeaderWaitPayView{
    
    UIView  *back=[UIView new];
    back.backgroundColor=[CommHelp toUIColorByStr:@"#f8f8f8"];
    back.layer.cornerRadius = 8;
    back.layer.masksToBounds = YES;
    [_headerTitleView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTitleView).offset(10);
        make.left.equalTo(_headerTitleView).offset(10);
        make.right.equalTo(_headerTitleView).offset(-10);
        make.height.offset(70);
        make.bottom.equalTo(_headerTitleView).offset(-20);
    }];
    
    UILabel *titlelLabel = [[UILabel alloc] init];
    titlelLabel.numberOfLines =1;
    titlelLabel.textAlignment = NSTextAlignmentLeft;
    titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titlelLabel.textColor= kColor333;
    titlelLabel.text = @"待支付 剩余:";
    titlelLabel.font=[UIFont systemFontOfSize:13];
    [back addSubview:titlelLabel];
    
    [ titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(10);
        make.top.equalTo(back).offset(10);
    }];
    
    _remainTimeLabel=[[UILabel alloc]init];
    _remainTimeLabel.text=@"29 :30 :23";
    _remainTimeLabel.font=[UIFont systemFontOfSize:13];
    _remainTimeLabel.textColor=[CommHelp toUIColorByStr:@"#f03d37"];
    _remainTimeLabel.numberOfLines = 1;
    _remainTimeLabel.textAlignment = NSTextAlignmentLeft;
    _remainTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:_remainTimeLabel];
    
    [_remainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlelLabel.mas_right).offset(5);
        make.centerY.equalTo(titlelLabel);
    }];
    
    UILabel *desc = [[UILabel alloc] init];
    desc.numberOfLines =1;
    desc.textAlignment = NSTextAlignmentLeft;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    desc.textColor= kColor333;
    desc.text = @"您的宝贝鉴定费尚未支付";
    desc.font=[UIFont systemFontOfSize:13];
    [back addSubview:desc];
    
    [ desc  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(10);
        make.bottom.equalTo(back).offset(-10);
    }];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"立即支付" forState:UIControlStateNormal];
    button.backgroundColor = kColorMain;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    [button setTitleColor:kColor222 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
    [button addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(back).offset(0);
        make.right.equalTo(back).offset(-10);
        make.size.mas_equalTo(CGSizeMake(98, 29));
    }];
}
-(void)initHeaderWaitAppraiseView{
    
    UIImageView  *back=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_upload_success_header"]];
    //    back.backgroundColor=[CommHelp toUIColorByStr:@"#f8f8f8"];
    //    back.layer.cornerRadius = 8;
    //    back.layer.masksToBounds = YES;
    back.userInteractionEnabled = YES;
    [_headerTitleView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTitleView).offset(10);
        make.left.equalTo(_headerTitleView).offset(10);
        make.right.equalTo(_headerTitleView).offset(-10);
        make.height.offset(154);
        make.bottom.equalTo(_headerTitleView).offset(-20);
    }];
    
    UILabel *titlelLabel = [[UILabel alloc] init];
    titlelLabel.numberOfLines =1;
    titlelLabel.textAlignment = NSTextAlignmentLeft;
    titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titlelLabel.textColor= kColor333;
    titlelLabel.text = @"专业图文鉴定";
    titlelLabel.font=[UIFont fontWithName:kFontMedium size:16];
    [back addSubview:titlelLabel];
    
    [ titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(10);
        make.top.equalTo(back).offset(20);
    }];
    
    UIImageView  *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_upload_success_tip"]];
    [back addSubview:logo];
    [ logo  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlelLabel.mas_right).offset(10);
        make.centerY.equalTo(titlelLabel).offset(0);
    }];
    
    UIImageView  *logo1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_upload_success_tip1"]];
    [back addSubview:logo1];
    [ logo1  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlelLabel).offset(0);
        make.top.equalTo(titlelLabel.mas_bottom).offset(10);
    }];
    
    UILabel *tip1 = [[UILabel alloc] init];
    tip1.numberOfLines =1;
    tip1.textAlignment = NSTextAlignmentLeft;
    tip1.lineBreakMode = NSLineBreakByWordWrapping;
    tip1.textColor= kColor333;
    tip1.text = @"提升曝光，流量扶持优先展示";
    tip1.font=[UIFont fontWithName:kFontNormal size:13];
    [back addSubview:tip1];
    
    [ tip1  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo1.mas_right).offset(10);
        make.centerY.equalTo(logo1).offset(0);
    }];
    
    UIImageView  *logo2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c2c_upload_success_tip2"]];
    [back addSubview:logo2];
    [ logo2  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlelLabel).offset(0);
        make.top.equalTo(logo1.mas_bottom).offset(10);
    }];
    
    UILabel *tip2 = [[UILabel alloc] init];
    tip2.numberOfLines =1;
    tip2.textAlignment = NSTextAlignmentLeft;
    tip2.lineBreakMode = NSLineBreakByWordWrapping;
    tip2.textColor= kColor333;
    tip2.text = @"增强信任，宝贝更易出售";
    tip2.font=[UIFont fontWithName:kFontNormal size:13];
    [back addSubview:tip2];
    
    [ tip2  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo2.mas_right).offset(10);
        make.centerY.equalTo(logo2).offset(0);
    }];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [back addSubview:line];
    line.backgroundColor = kColorFFF;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(.5);
        make.top.equalTo(tip2.mas_bottom).offset(10);
    }];
    
    _appraiseTimeLabel=[[UILabel alloc]init];
    _appraiseTimeLabel.text=@"预计鉴定完成时间：明日10:00前";
    _appraiseTimeLabel.font=[UIFont fontWithName:kFontNormal size:12];
    _appraiseTimeLabel.textColor=[CommHelp toUIColorByStr:@"#3f3939"];
    _appraiseTimeLabel.numberOfLines = 1;
    _appraiseTimeLabel.textAlignment = NSTextAlignmentLeft;
    _appraiseTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [back addSubview:_appraiseTimeLabel];
    
    [_appraiseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlelLabel).offset(5);
        make.top.equalTo(line.mas_bottom).offset(10);
    }];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"我要鉴定" forState:UIControlStateNormal];
    button.backgroundColor = HEXCOLORA(0xffffff, 0.5);;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
  //  button.layer.borderWidth = 0.5;
  //  button.layer.borderColor = kColor333.CGColor;
    [button setTitleColor:[CommHelp toUIColorByStr:@"#5a3b23"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [button addTarget:self action:@selector(apprise:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:button];
        [button setImage:[UIImage imageNamed:@"c2c_publish_icon_jiantou"] forState:UIControlStateNormal];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titlelLabel).offset(0);
        make.right.equalTo(back).offset(-10);
        make.size.mas_equalTo(CGSizeMake(76, 28));
    }];
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                imageTitleSpace:5];
}

-(void)initHeaderCompleteView{
    
    UIView  *back=[UIView new];
    back.backgroundColor=[CommHelp toUIColorByStr:@"#f8f8f8"];
    back.layer.cornerRadius = 8;
    back.layer.masksToBounds = YES;
    [_headerTitleView addSubview:back];
    [ back  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTitleView).offset(10);
        make.left.equalTo(_headerTitleView).offset(10);
        make.right.equalTo(_headerTitleView).offset(-10);
        make.height.offset(58);
        make.bottom.equalTo(_headerTitleView).offset(-20);
    }];
    
    UILabel *titlelLabel = [[UILabel alloc] init];
    titlelLabel.numberOfLines =2;
    titlelLabel.textAlignment = NSTextAlignmentCenter;
    titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titlelLabel.textColor= kColor333;
    titlelLabel.text = @"温馨提示：鉴定报告会在鉴定完成后同步给您，同时会增加鉴定标识。让您的宝贝更容易售出。";
    titlelLabel.font=[UIFont systemFontOfSize:13];
    [back addSubview:titlelLabel];
    
    [ titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back).offset(10);
        make.right.equalTo(back).offset(-10);
        make.centerY.equalTo(back).offset(0);
    }];
    
    
    
}
-(void)setModel:(JHC2CPublishSuccessBackModel *)model{
    
    _model = model;
    
    if ([_model.order.orderStatus isEqualToString:@"waitpay"]||
        [_model.order.orderStatus isEqualToString:@"waitack"]) {
        [self initHeaderWaitPayView];
    }else if([_model.order.orderStatus isEqualToString:@"success"]) {
        
        [self initHeaderCompleteView];
        _goOnPublishBtn.layer.borderWidth = 0;
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(310, 50) radius:8];
        [_goOnPublishBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
    }else {
        if (self.canAuth) {
            [self initHeaderWaitAppraiseView];
        }
    }
    
    if ([CommHelp getHMSWithSecond:[_model.order.payExpiredTime intValue]/1000]>0&&
        ([_model.order.orderStatus isEqualToString:@"waitpay"]||
         [_model.order.orderStatus isEqualToString:@"waitack"])) {
        [self timeCountDown];
    }else{
        
    }
    if (self.viewHeightChangeBlock) {
        self.viewHeightChangeBlock();
    };
    
}
-(void)timeCountDown{
    
    self.remainTimeLabel.text= [CommHelp getHMSWithSecond:[self.model.order.payExpiredTime intValue]/1000];;
    
    if (timer) {
        [timer stopGCDTimer];
        timer=nil;
    }
    
    timer=[[BYTimer alloc]init];
    
    JH_WEAK(self)
    [timer createTimerWithTimeout:[self.model.order.payExpiredTime intValue]/1000 handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        NSLog(@"倒计时==%d",presentTime);
        self.remainTimeLabel.text=[CommHelp getHMSWithSecond:presentTime];
    } finish:^{
        JH_STRONG(self)
        
    }];
}
//- (void)apprise:(UIButton*)button{
//
////    JHWebViewController *web = [[JHWebViewController alloc] init];
////    web.urlString =  H5_BASE_STRING(@"");;
////    [JHRootController.homeTabController.navigationController pushViewController:web animated:YES];
//
//}
///一键鉴定,先下单,后跳转到支付页面
- (void)apprise:(UIButton*)button{
    
    //调取下单接口
    [JHRootController checkLoginWithTarget:self.viewController complete:^(BOOL result) {
        if (result) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"productId"] = self.model.productId;
            [SVProgressHUD show];
            [JHMarketOrderViewModel appriaseProductAuth:params Completion:^(NSError * _Nullable error, JHMarketProductAuthModel * _Nullable model) {
                [SVProgressHUD dismiss];
                if ([model.orderStatus isEqualToString:@"waitack"] || [model.orderStatus isEqualToString:@"waitpay"]) {
                    //下面是支付页面
                    JHAppraisePayView * payView = [[JHAppraisePayView alloc]init];
                    payView.orderId = model.orderId;
                    [JHKeyWindow addSubview:payView];
                    [payView showAlert];
                }else{
                    JHTOAST(@"鉴定报告即将出炉，请耐心等待");
                }
            }];
        }
    }];
}
- (void)publish:(UIButton*)button{
    
    JHC2CSelectClassViewController *vc = [[JHC2CSelectClassViewController alloc] init];
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    
}
- (void)pay:(UIButton*)button{
    
    JHAppraisePayView * payView = [[JHAppraisePayView alloc]init];
    payView.orderId = self.model.order.orderId;
    [JHKeyWindow addSubview:payView];
    [payView showAlert];
    
    @weakify(self);
    payView.paySuccessBlock = ^{
        @strongify(self);
        [self.viewController.navigationController popToRootViewControllerAnimated:YES];
    };
}

-(void)Look:(UIGestureRecognizer*)tap{
    
    JHMarketOrderListViewController *vc = [[JHMarketOrderListViewController alloc] init];
  //  vc.productID = self.model.productId;
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}
-(void)Share:(UIGestureRecognizer*)tap{
    
    if (self.shareHandle) {
        self.shareHandle(self.model.shareInfo,nil);
    }
    
}
- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}
@end

