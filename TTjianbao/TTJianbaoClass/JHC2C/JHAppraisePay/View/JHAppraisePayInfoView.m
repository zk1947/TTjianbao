//
//  JHAppraisePayInfoView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAppraisePayInfoView.h"
#import "JHOrdePayGradationViewController.h"
#import "PayMode.h"
#import "TTjianbaoHeader.h"
#import "BYTimer.h"
#import "UIImage+JHColor.h"
#import "JHCouponListView.h"
#import "JHPayProtocolView.h"
#import "JHAppraisePayCoponListView.h"
@interface JHAppraisePayInfoView ()
{
    BYTimer *timer ;
    //实付金额
    NSDecimalNumber * numRealPay;
}
@property(nonatomic,strong) UIView *tipView;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) UILabel * titlelLabel;
@property(nonatomic,strong) UILabel * timerLabel;
@property(nonatomic,strong) UIView *feeView;
@property(nonatomic,strong) UILabel *appraiseFee;
@property(nonatomic,strong) UIView *platformCoponView;
@property(nonatomic,strong) UILabel *platformDesc;
@property(nonatomic, strong) UILabel *couponNumLabel;
@property(nonatomic,strong) UILabel *payPrice;
@property(nonatomic,strong) UIImageView *coponIndicator;


@property(nonatomic,strong) UIView *payWayView;
@property(nonatomic,strong) UIView *protocolView;
@property(nonatomic,strong)JHPayProtocolView *protocol;


@property (strong, nonatomic)  PayWayMode *payWayMode;

@property (strong, nonatomic)   NSIndexPath * selectIndexPath;
@property (strong, nonatomic)   CoponMode *selectCoponMode;
@end
@implementation JHAppraisePayInfoView
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
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initHeaderView];
    [self initTipView];
    [self initFeeView];
    [self initPayWayView];
    [self initProtocolView];
    [self initBottomView];
    
}
-(void)initHeaderView{
    
    _headerView=[[UIView alloc]init];
    [self.contentScroll addSubview:_headerView];
    _headerView.backgroundColor=[UIColor whiteColor];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
    
    _titlelLabel = [[UILabel alloc] init];
    _titlelLabel.numberOfLines =1;
    _titlelLabel.textAlignment = NSTextAlignmentCenter;
    _titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelLabel.textColor = kColor333;
    _titlelLabel.text = @"支付鉴定费";
    _titlelLabel.font=[UIFont fontWithName:kFontBoldPingFang size:17];
    [_headerView addSubview:_titlelLabel];
    
    [ _titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).offset(10);
        make.centerX.equalTo(_headerView);
        make.height.equalTo(@30);
    }];
    
    UIButton *dismissBtn = [[UIButton alloc] init];
    [dismissBtn setImage:[UIImage imageNamed:@"image_close"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:dismissBtn];
    
    [ dismissBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headerView).offset(0);
        make.centerY.equalTo(_titlelLabel);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    
    UIView *timerBack=[UIView new];
    [_headerView addSubview:timerBack];
    [timerBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.top.equalTo(_titlelLabel.mas_bottom).offset(5);
        make.height.offset(0);
        make.bottom.equalTo(_headerView).offset(-10);
    }];
    
    UILabel *remainLabel=[[UILabel alloc]init];
    remainLabel.text=@"剩余时间：";
    remainLabel.font=[UIFont fontWithName:kFontNormal size:12];
    remainLabel.textColor = kColor999;
    remainLabel.numberOfLines = 1;
    remainLabel.textAlignment = NSTextAlignmentCenter;
    remainLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [timerBack addSubview:remainLabel];
    
//    [remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(timerBack).offset(5);
//        make.centerY.equalTo(timerBack);
//
//    }];
    
    _timerLabel=[[UILabel alloc]init];
    _timerLabel.text=@"";
    _timerLabel.font=[UIFont fontWithName:kFontMedium size:12];
    _timerLabel.textColor=kColor999;;
    _timerLabel.numberOfLines = 1;
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [timerBack addSubview:_timerLabel];
    
//    [_timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(remainLabel.mas_right).offset(5);
//        make.right.equalTo(timerBack.mas_right);
//        make.centerY.equalTo(timerBack);
//
//    }];
    
}
-(void)initTipView{
    
    _tipView=[[UIView alloc]init];
    _tipView.backgroundColor = HEXCOLOR(0xfffaf2);
    [self.contentScroll addSubview:_tipView];
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
      //  make.height.offset(60);
    }];
    
    UILabel * titlelLabel= [[UILabel alloc] init];
    titlelLabel.numberOfLines = 0;
    titlelLabel.textAlignment = NSTextAlignmentLeft;
    titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titlelLabel.textColor = kColor666;
    titlelLabel.font=[UIFont fontWithName:kFontNormal size:12];
    [_tipView addSubview:titlelLabel];
    [ titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipView).offset(5);
        make.bottom.equalTo(_tipView).offset(-5);
        make.left.equalTo(_tipView).offset(10);
        make.right.equalTo(_tipView).offset(-10);
    }];
    NSString * text = @"购买后48小时内出具鉴定报告，若报告出具前商品售出或鉴定超时，鉴定费将自动退回，报告出具后商品被别人抢先购买或下架，鉴定费用无法退回";
    NSRange range = [text rangeOfString:@"48小时"];
    titlelLabel.attributedText=[text attributedFont:[UIFont fontWithName:kFontNormal size:12] color:kColorMainRed range:range];
    
    
}
-(void)initFeeView{
    
    _feeView=[[UIView alloc]init];
    _feeView.backgroundColor=[UIColor whiteColor];
    
    [self.contentScroll addSubview:_feeView];
    
    [_feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(150);
    }];
    
    [self initAppraiseFee];
    [self initCoponView];
    [self initPayView];
    
}
-(void)initAppraiseFee{
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"鉴定费";
    title.font=[UIFont fontWithName:kFontNormal size:14];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_feeView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feeView);
        make.left.equalTo(_feeView).offset(10);
        make.height.equalTo(@50);
    }];
    _appraiseFee=[[UILabel alloc]init];
    _appraiseFee.text=@"¥";
    _appraiseFee.font = [UIFont fontWithName:kFontBoldDIN size:16.f];
    _appraiseFee.textColor=kColor333;
    _appraiseFee.numberOfLines = 1;
    [_appraiseFee setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _appraiseFee.textAlignment = NSTextAlignmentCenter;
    _appraiseFee.lineBreakMode = NSLineBreakByWordWrapping;
    [_feeView addSubview:_appraiseFee];
    
    [_appraiseFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(_feeView.mas_right).offset(-10);
    }];
    
}
-(void)initCoponView{
    
    _platformCoponView=[[UIView alloc]init];
    _platformCoponView.backgroundColor=[UIColor whiteColor];
    _platformCoponView.userInteractionEnabled=YES;
    _platformCoponView.layer.masksToBounds=YES;
    [_platformCoponView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapCopon:)]];
    [_feeView addSubview:_platformCoponView];
    
    [_platformCoponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feeView).offset(50);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(50);
    }];
    
    _coponIndicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appraise_pay_jiantou"]];
    _coponIndicator.backgroundColor=[UIColor clearColor];
    [_coponIndicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_coponIndicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _coponIndicator.contentMode = UIViewContentModeScaleAspectFit;
    [_platformCoponView addSubview:_coponIndicator];
    
    [_coponIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_platformCoponView).offset(-15);
        make.centerY.equalTo(_platformCoponView);
        
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"红包";
    title.font=[UIFont fontWithName:kFontNormal size:14];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_platformCoponView addSubview:title];
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_platformCoponView).offset(10);
        make.centerY.equalTo(_platformCoponView);
    }];
    
    [_platformCoponView addSubview: self.couponNumLabel];
    
    [self.couponNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title.mas_right).offset(3);
        make.centerY.mas_equalTo(title);
    }];
    
    
    _platformDesc=[[UILabel alloc]init];
    _platformDesc.text=@"暂无可用";
    _platformDesc.font=[UIFont fontWithName:kFontNormal size:16];
    _platformDesc.backgroundColor=[UIColor clearColor];
    _platformDesc.textColor=kColor999;
    _platformDesc.numberOfLines = 1;
    _platformDesc.textAlignment = NSTextAlignmentLeft;
    _platformDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [_platformCoponView addSubview:_platformDesc];
    
    [_platformDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(_coponIndicator.mas_left).offset(-10);
    }];
}
-(void)initPayView{
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"实付款";
    title.font=[UIFont fontWithName:kFontNormal size:14];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_feeView addSubview:title];
    
    
    _payPrice=[[UILabel alloc]init];
    _payPrice.text=@"¥";
    _payPrice.font = [UIFont fontWithName:kFontBoldDIN size:24.f];
    _payPrice.textColor=kColor333;
    _payPrice.numberOfLines = 1;
    [_payPrice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _payPrice.textAlignment = NSTextAlignmentCenter;
    _payPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_feeView addSubview:_payPrice];
    
    [_payPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(title).offset(2);
        make.right.equalTo(_feeView.mas_right).offset(-10);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_feeView).offset(-15);
        make.right.equalTo(_payPrice.mas_left).offset(-10);
      //  make.height.equalTo(@50);
    }];
}

-(void)initPayWayView{
    
    _payWayView=[[UIView alloc]init];
    _payWayView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_payWayView];
    
    [_payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feeView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
}
-(void)initPayWaySubviews:(NSArray*)arr{
    
    [_payWayView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel  *viewTitle=[[UILabel alloc]init];
    viewTitle.text = @"付款方式";
    viewTitle.font = [UIFont fontWithName:kFontBoldPingFang size:14];
    viewTitle.backgroundColor=[UIColor clearColor];
    viewTitle.textColor=kColor333;
    viewTitle.numberOfLines = 1;
    viewTitle.textAlignment = NSTextAlignmentLeft;
    viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_payWayView addSubview:viewTitle];
    
    [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payWayView).offset(10);
        make.left.equalTo(_payWayView).offset(10);
        make.right.equalTo(_payWayView).offset(0);
        make.height.offset(30);
    }];
    
    
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
        title.textColor=kColor222;
        title.numberOfLines = 1;
        title.textAlignment = NSTextAlignmentCenter;
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
        [button setImage:[UIImage imageNamed:@"order_payway_choose_nomal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"order_payway_choose_select"] forState:UIControlStateSelected];
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
        
        UILabel  *tip=[[UILabel alloc]init];
        tip.text=payMode.remarks;
        tip.font=[UIFont systemFontOfSize:12];
        tip.backgroundColor=[UIColor clearColor];
        tip.textColor=kColor999;
        tip.numberOfLines = 1;
        tip.textAlignment = NSTextAlignmentCenter;
        tip.lineBreakMode = NSLineBreakByWordWrapping;
//        [view addSubview:tip];
//        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(button.mas_left).offset(-5);
//            make.centerY.equalTo(view);
//        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.left.right.equalTo(_payWayView);
            if (i==0) {
                make.top.equalTo(viewTitle.mas_bottom);
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
-(void)initProtocolView{
    
    _protocolView = [UIView new];
    _protocolView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_protocolView];
    [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payWayView.mas_bottom).offset(0);
        make.height.offset(30.);
        make.left.right.equalTo(self.contentScroll);
    }];
    
    _protocol = [JHPayProtocolView new];
    [_protocolView addSubview:_protocol];
    [_protocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_protocolView);
        make.centerX.equalTo(_protocolView);
    }];
    
//    @weakify(self);
//    _protocol.protocalBlock = ^{
//
//        @strongify(self);
//        if (self.protocalBlock) {
//            self.protocalBlock();
//        }
//    };

}
-(void)initBottomView{
    
    
    UIView * bottom=[[UIView alloc]init];
    bottom.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:bottom];
    
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_protocolView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.bottom.equalTo(self.contentScroll).offset(0);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:kFontNormal size:18];
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(279, 44) radius:4];
    [button setBackgroundImage:nor_image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottom);
       // make.centerY.equalTo(bottom);
        make.top.equalTo(bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(347, 44));
//        make.bottom.equalTo(self.contentScroll).offset(-UI.bottomSafeAreaHeight-10);
    }];
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
-(void)setAppraisePayModel:(JHAppraisePayModel *)appraisePayModel{
    
    _appraisePayModel = appraisePayModel;
    
   // _appraiseFee.text=_appraisePayModel.originOrderPrice;
    NSString * moneyString=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%@",_appraisePayModel.originOrderPrice]];
    NSRange range = [moneyString rangeOfString:@"¥"];
    _appraiseFee.attributedText=[moneyString attributedFont:[UIFont fontWithName:kFontNormal size:10.5] color:kColor333 range:range];
    
    _payWayArray = _appraisePayModel.payWayArray;
     [self initPayWaySubviews: _payWayArray];
    
    if ([CommHelp getHMSWithSecond:[_appraisePayModel.expireTime intValue]/1000]>0) {
        [self timeCountDown];
    }
    else{
       
    }
    self.selectIndexPath=nil;
    self.selectCoponMode=nil;
    
    if (_appraisePayModel.defaultCouponId) {
        for (int i=0; i<_appraisePayModel.myCouponVoList.count; i++) {
            CoponMode *model = _appraisePayModel.myCouponVoList[i];
        if ([model.Id isEqualToString:_appraisePayModel.defaultCouponId]) {
            self.selectIndexPath= [NSIndexPath indexPathForRow:i inSection:0];
            self.selectCoponMode = model;
            break;;
          }
        }
    }
    
    [self setCoponDesc];
}
-(void)timeCountDown{
    
    self.timerLabel.text=[CommHelp getHMSWithSecond:[_appraisePayModel.expireTime intValue]/1000];
    
    if (timer) {
        [timer stopGCDTimer];
        timer=nil;
    }
    
      timer=[[BYTimer alloc]init];
    
    JH_WEAK(self)
    [timer createTimerWithTimeout:[_appraisePayModel.expireTime intValue]/1000 handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        NSLog(@"倒计时==%d",presentTime);
        self.timerLabel.text=[CommHelp getHMSWithSecond:presentTime];
    } finish:^{
        JH_STRONG(self)
        
    }];
}
-(void)setCoponDesc{
    
    if (self.appraisePayModel.myCouponVoList.count <= 0) {
        [self.coponIndicator setHidden:YES];
        [_platformDesc mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_coponIndicator.mas_left).offset(5);
        }];
    }
    else{
        [self.coponIndicator setHidden:NO];
        [_platformDesc mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_coponIndicator.mas_left).offset(-10);
        }];
    }
    
    if (self.appraisePayModel.myCouponVoList.count > 0) {
        self.couponNumLabel.text = [NSString stringWithFormat:@"(%lu 张可用)",(unsigned long)[self.appraisePayModel.myCouponVoList count]];
    }else {
        self.couponNumLabel.text = @"";
    }
    
    if (![self.appraisePayModel.orderStatus isEqualToString:@"waitack"]){
        self.platformCoponView.userInteractionEnabled=NO;
        
        //应付金额开始取原始金额
        numRealPay = [NSDecimalNumber decimalNumberWithString:self.appraisePayModel.orderPrice];
        
        //红包
        if (self.selectCoponMode) {
       
            NSDictionary *dic = @{NSFontAttributeName : [UIFont fontWithName:kFontNormal size:10.5],
                                  NSForegroundColorAttributeName : HEXCOLOR(0xf23730),};
            NSDictionary *dic1 = @{NSFontAttributeName : [UIFont fontWithName:kFontBoldDIN size:16],
                                   NSForegroundColorAttributeName : HEXCOLOR(0xf23730),};
            NSMutableAttributedString *money = [[NSMutableAttributedString alloc] initWithString:@"-￥ " attributes:dic];
            NSMutableAttributedString *money1 = [[NSMutableAttributedString alloc] initWithString:self.selectCoponMode.price attributes:dic1];
            [money appendAttributedString:money1];
            
            self.platformDesc.attributedText = money;
            
            NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.selectCoponMode.price];
            //减去 代金券
            numRealPay = [numRealPay decimalNumberBySubtracting:numberPay];
            if (numRealPay.doubleValue<=0) {
                numRealPay=0;
            }
        }
        else{
            self.platformDesc.textColor=kColor999;
            self.platformDesc.font = [UIFont fontWithName:kFontNormal size:13];
            self.platformDesc.text=[NSString stringWithFormat:@"%lu 张可用",(unsigned long)[self.appraisePayModel.myCouponVoList count]];
        }
        
    }
    else{
        self.platformCoponView.userInteractionEnabled=YES;
        //应付金额开始取原始金额
        numRealPay = [NSDecimalNumber decimalNumberWithString:self.appraisePayModel.orderPrice];
        
        //红包
        if (self.selectCoponMode) {

            NSDictionary *dic = @{NSFontAttributeName : [UIFont fontWithName:kFontNormal size:10.5],
                                  NSForegroundColorAttributeName : HEXCOLOR(0xf23730),};
            NSDictionary *dic1 = @{NSFontAttributeName : [UIFont fontWithName:kFontBoldDIN size:16],
                                   NSForegroundColorAttributeName : HEXCOLOR(0xf23730),};
            NSMutableAttributedString *money = [[NSMutableAttributedString alloc] initWithString:@"-￥ " attributes:dic];
            NSMutableAttributedString *money1 = [[NSMutableAttributedString alloc] initWithString:self.selectCoponMode.price attributes:dic1];
            [money appendAttributedString:money1];
            
            self.platformDesc.attributedText = money;
            
            NSDecimalNumber *numberPay = [NSDecimalNumber decimalNumberWithString:self.selectCoponMode.price];
            //减去 代金券
            numRealPay = [numRealPay decimalNumberBySubtracting:numberPay];
            if (numRealPay.doubleValue<=0) {
                numRealPay=0;
            }
        }
        else{
            self.platformDesc.textColor=kColor999;
            self.platformDesc.font = [UIFont fontWithName:kFontNormal size:13];
            self.platformDesc.text=[NSString stringWithFormat:@"%lu 张可用",(unsigned long)[self.appraisePayModel.myCouponVoList count]];
        }
    }
   
    
    NSString * moneyString=[@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.2f",numRealPay.doubleValue]];
    NSRange range = [moneyString rangeOfString:@"¥"];
    self.payPrice.attributedText=[moneyString attributedFont:[UIFont fontWithName:kFontNormal size:12] color:kColor333 range:range];
}
-(void)tapCopon:(UIGestureRecognizer*)tap{
    [self endEditing:YES];
    if (self.appraisePayModel.myCouponVoList.count<=0) {
        [JHKeyWindow makeToast:@"暂无红包可用" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.appraisePayModel.orderStatus isEqualToString:@"waitpay"]) return;

    
    JHAppraisePayCoponListView *view = [[JHAppraisePayCoponListView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [JHKeyWindow addSubview:view];
        [view setDataArr:self.appraisePayModel.myCouponVoList andDefaultSelecltIndex:self.selectIndexPath];
    [view showAlert];
    JH_WEAK(self)
    view.cellSelect = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        if (indexPath==nil) {
            self.selectIndexPath=nil;
            self.selectCoponMode=nil;
        }else{
            self.selectIndexPath=indexPath;
            self.selectCoponMode=self.appraisePayModel.myCouponVoList[self.selectIndexPath.row];
        }
        [self setCoponDesc];
    };
}
-(void)onClickBtnAction:(UIButton*)button{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(self.payWayMode.Id) forKey:@"payId"];
    [dic setObject:self.appraisePayModel.orderId forKey:@"orderId"];
    [dic setObject:@"ios" forKey:@"portalEnum"] ;
    [dic setObject:@(numRealPay.doubleValue) forKey:@"payMoney"];
    if (self.selectCoponMode) {
        [dic setObject:self.selectCoponMode.Id forKey:@"couponId"];
    }
    
    if (self.payBlock) {
        self.payBlock(dic);
    }
}
-(void)dismiss{
    
    if (self.dissBlock) {
        self.dissBlock();
    }
    
}
-(void)setProtocalBlock:(JHFinishBlock)protocalBlock{

    self.protocol.protocalBlock = protocalBlock;

}
- (UILabel *)couponNumLabel {
    if (!_couponNumLabel) {
        _couponNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _couponNumLabel.textColor = HEXCOLOR(0x999999);
        _couponNumLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _couponNumLabel;
}
- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}
@end

