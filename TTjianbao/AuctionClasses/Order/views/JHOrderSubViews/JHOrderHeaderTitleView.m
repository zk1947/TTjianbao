//
//  JHOrderHeaderTitleView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderHeaderTitleView.h"
#import "JHOrderStatusInterface.h"
@interface JHOrderHeaderTitleView ()
{
    UIView  *timerBack;
    BYTimer *timer;
}
@property(nonatomic,strong) UIImageView *logo;
@property(nonatomic,strong) UILabel * titlelLabel;
@property(nonatomic,strong) UILabel * descLabel;
@property(nonatomic,strong) UILabel * remainLabel;
@property(nonatomic,strong) UILabel * timerLabel;
@property(nonatomic,strong) UIButton *statusButton;
@end

@implementation JHOrderHeaderTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 0;
        
    }
    return self;
}
-(void)setSubViews{
    
    UIImageView  *backImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_heder_title_icon"]];
    backImage.contentMode=UIViewContentModeScaleToFill;
    [self addSubview:backImage];
    [ backImage  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.offset(kHeaderH);
    }];
    
    UIView  *titleBack=[UIView new];
    [backImage addSubview:titleBack];
    // titleBack.backgroundColor=[UIColor greenColor];
    [ titleBack  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImage).offset(UI.statusBarHeight+7+5);
        make.centerX.equalTo(backImage);
        make.height.offset(30);
    }];
    
    _logo=[[UIImageView alloc]init];
    _logo.contentMode = UIViewContentModeScaleAspectFit;
    _logo.image=[UIImage imageNamed:@""];
    [titleBack addSubview:_logo];
    
    [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBack);
        make.centerY.equalTo(titleBack);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _titlelLabel = [[UILabel alloc] init];
    _titlelLabel.numberOfLines =1;
    _titlelLabel.textAlignment = NSTextAlignmentCenter;
    _titlelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelLabel.textColor=[UIColor whiteColor];
    _titlelLabel.text = @"";
    _titlelLabel.font=[UIFont fontWithName:kFontMedium size:20];
    [titleBack addSubview:_titlelLabel];
    
    [ _titlelLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logo.mas_right).offset(5);
        make.centerY.equalTo(_logo);
        make.right.equalTo(titleBack);
    }];
    
    _descLabel=[[UILabel alloc]init];
    _descLabel.font=[UIFont systemFontOfSize:13];
    _descLabel.textColor=[UIColor whiteColor];
    _descLabel.numberOfLines = 2;
    _descLabel.font=[UIFont fontWithName:kFontMedium size:13];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [backImage addSubview:_descLabel];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImage).offset(5);
        make.right.equalTo(backImage).offset(-5);
        make.top.equalTo(titleBack.mas_bottom).offset(5);
    }];
    
    timerBack=[UIView new];
    [backImage addSubview:timerBack];
    [timerBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImage);
        make.top.equalTo(titleBack.mas_bottom).offset(5);
        make.height.offset(25);
    }];
    
    _remainLabel=[[UILabel alloc]init];
    _remainLabel.text=@"";
    _remainLabel.font=[UIFont fontWithName:kFontMedium size:13];
    _remainLabel.textColor=[UIColor whiteColor];
    _remainLabel.numberOfLines = 1;
    _remainLabel.textAlignment = NSTextAlignmentCenter;
    _remainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [timerBack addSubview:_remainLabel];
    
    [_remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timerBack).offset(5);
        make.centerY.equalTo(timerBack);
        
    }];
    
    _timerLabel=[[UILabel alloc]init];
    _timerLabel.text=@"";
    _timerLabel.font=[UIFont fontWithName:kFontMedium size:13];
    _timerLabel.textColor=[UIColor whiteColor];
    _timerLabel.numberOfLines = 1;
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [timerBack addSubview:_timerLabel];
    
    [_timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_remainLabel.mas_right).offset(5);
        make.right.equalTo(timerBack.mas_right);
        make.centerY.equalTo(timerBack);
        
    }];
    
}

- (void)setupGraData {
    OrderStatusTipModel * tipModel=[UserInfoRequestManager findOrderTip:_orderMode.orderStatus];
    [_logo jhSetImageWithURL:[NSURL URLWithString:tipModel.icon?:@""]];
    self.titlelLabel.text=tipModel.name?:@"";
    
    if (timer) {
        [timer stopGCDTimer];
        timer=nil;
    }
    
    self.descLabel.text = _orderMode.orderStatusDesc;
    
    if ([_orderMode.orderStatus isEqualToString:@"waitack"]||
        [_orderMode.orderStatus isEqualToString:@"waitpay"]) {
        if ([CommHelp getHMSWithSecond:[CommHelp dateRemaining:_orderMode.expireTime]]>0) {
            [self timeCountDown];
        }
        else{
            [self HideTimeView];
            self.descLabel.text=@"订单过期未支付！";
        }
    }
    else if ([_orderMode.orderStatus isEqualToString:@"refunding"]||
             [_orderMode.orderStatus isEqualToString:@"refunded"]) {
        if ([CommHelp getHMSWithSecond:[CommHelp dateRemaining:_orderMode.refundExpireTime]]>0) {
            [self timeCountDown];
        }
        else{
            [self HideTimeView];
            self.descLabel.text=@"";
        }
    }
    else{

        [self HideTimeView];
        NSString *content = [NSString stringWithFormat:@"%@%@",tipModel.title?:@"",tipModel.desc?:@""];
        self.descLabel.text=content;

    }
}

#pragma mark - 常规单

- (void)setGraOrderMode:(JHOrderDetailMode *)graOrderMode {
    _graOrderMode = graOrderMode;
    
    [self.titlelLabel removeFromSuperview];
    [self addSubview:self.titlelLabel];
    
    self.titlelLabel.textAlignment = NSTextAlignmentCenter;
    [self.titlelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logo.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
//        make.centerX.mas_equalTo(self);
    }];
    
    [self addSubview:self.statusButton];
    [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_time"] forState:UIControlStateNormal];
    
    [self.statusButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titlelLabel);
        make.centerX.mas_equalTo(self).mas_offset(-50);
    }];
    
    [self.descLabel removeFromSuperview];
    [self addSubview:self.descLabel];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titlelLabel.mas_left).offset(50);
        make.right.mas_equalTo(self.titlelLabel.mas_right).offset(-50);
        make.top.mas_equalTo(self.titlelLabel.mas_bottom).offset(5);
    }];
    
    self.titlelLabel.text = graOrderMode.orderStatusText;
    self.descLabel.text = graOrderMode.orderStatusDesc;
    /**
     1, "待付款",
     2, "待付款",
     11, "待鉴定"
     12, "已鉴定"
     */
    int expireTime = graOrderMode.expireTime.intValue/1000;
    // 待付款
    if(graOrderMode.orderStatus.intValue == 1 || graOrderMode.orderStatus.intValue == 2){
        if (timer) {
            [timer stopGCDTimer];
            timer = nil;
        }
       
        if (expireTime>0) {
            [self groTimeCountDown];
        }
        else{
            [timer stopGCDTimer];
            self.descLabel.text = @"已关闭";
        }
        
    }
    
    // 待鉴定
    if(graOrderMode.orderStatus.intValue == 11){
        if (timer) {
            [timer stopGCDTimer];
            timer=nil;
        }
        
        if (expireTime>0) {
            [self marketTimeCountDown];
        }
        else{
            [timer stopGCDTimer];
            self.descLabel.text = @"已关闭";
        }
        [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_wait"] forState:UIControlStateNormal];
    }
    
    // 鉴定完成
    if(graOrderMode.orderStatus.intValue == 12){
        self.titlelLabel.text  = @"鉴定完成";
        self.descLabel.text = @"";
        [self.statusButton setImage:[UIImage imageNamed:@"c2c_class_order_complete"] forState:UIControlStateNormal];
    }
    
    // 已关闭
//    if(graOrderMode.orderStatus.intValue == 3){
//    }
}

-(void)groTimeCountDown {
    JH_WEAK(self)
    int expireTime= self.graOrderMode.expireTime.intValue/1000;
    
    self.descLabel.text = [NSString stringWithFormat:@"剩%@后未付款,订单自动关闭", [CommHelp getHMSWithSecondWord:expireTime]];
    timer = [self creatTimerOnce]; //[[BYTimer alloc] init];
    [timer createTimerWithTimeout:expireTime handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        NSLog(@"倒计时==%d",presentTime);
        self.descLabel.text = [NSString stringWithFormat:@"剩%@后未付款,订单自动关闭",[CommHelp getHMSWithSecondWord:presentTime]];
    } finish:^{
        JH_STRONG(self)
        self.descLabel.text=@"已关闭";
        [timer stopGCDTimer];
    }];
}

- (void)stopMyTimer{
    [timer stopGCDTimer];
}

- (BYTimer *)creatTimerOnce{
    if (!timer) {
        timer = [[BYTimer alloc] init];
    }
    return timer;
}

-(void)marketTimeCountDown {
    JH_WEAK(self)
    int expireTime= self.graOrderMode.expireTime.intValue/1000;
    self.descLabel.text = [NSString stringWithFormat:@"鉴定师正在加紧为您鉴定中，%@后未鉴定,系统将自动退款",[CommHelp getHMSWithSecondWord:expireTime]];
    timer = [self creatTimerOnce];//[[BYTimer alloc]init];
    [timer createTimerWithTimeout:expireTime handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        NSLog(@"倒计时==%d",presentTime);
        self.descLabel.text = [NSString stringWithFormat:@"鉴定师正在加紧为您鉴定中，%@后未鉴定,系统将自动退款",[CommHelp getHMSWithSecondWord:presentTime]];
    } finish:^{
        JH_STRONG(self)
        self.descLabel.text=@"已关闭";
        [timer stopGCDTimer];
    }];
}

-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    _orderMode=orderMode;
    if(self.isGra){
        [self setupGraData];
        return;
    }
    JHCustomerOrderSide side = _orderMode.isSeller ? JHCustomerOrderSide_Merchants : JHCustomerOrderSide_Buyers;
    JHBusinessModel bModel = _orderMode.directDelivery ? JHBusinessModel_SH : JHBusinessModel_De;
    // 获得订单状态
//    JHVariousStatusOfOrders orderStatusType = [JHOrderFactory getVariousStatusOfOrders:_orderMode.orderStatus];
    JHChangeDesCondition condition = JHChangeDesCondition_None;
    if (side == JHCustomerOrderSide_Buyers &&
        /*orderStatusType == JHVariousStatusOfOrders_WaitReceiving &&*/
        bModel == JHBusinessModel_SH) {
        condition = JHChangeDesCondition_Buyers_WaitReceiving_SH;
    }
    OrderStatusTipModel *tipModel = [UserInfoRequestManager findNewTip:condition
                                                                status:_orderMode.orderStatus];
    
    [_logo jhSetImageWithURL:[NSURL URLWithString:tipModel.icon?:@""]];
    self.titlelLabel.text=tipModel.name?:@"";
    
    if (timer) {
        [timer stopGCDTimer];
        timer=nil;
    }
    if (([_orderMode.orderStatus isEqualToString:@"waitack"]||
        [_orderMode.orderStatus isEqualToString:@"waitpay"])&& _isAuction != YES) {
        if ([CommHelp getHMSWithSecond:[CommHelp dateRemaining:_orderMode.payExpireTime]]>0) {
            [self timeCountDown];
        }
        else{
            [self HideTimeView];
            self.descLabel.text=@"订单过期未支付！";
        }
    }
    else if ([_orderMode.orderStatus isEqualToString:@"refunding"]||
             [_orderMode.orderStatus isEqualToString:@"refunded"]) {
        if ([CommHelp getHMSWithSecond:[CommHelp dateRemaining:_orderMode.refundExpireTime]]>0) {
            [self timeCountDown];
        }
        else{
            [self HideTimeView];
            self.descLabel.text=@"";
        }
    }
    else{
        
        [self HideTimeView];
        NSString *content = [NSString stringWithFormat:@"%@%@",tipModel.title?:@"",tipModel.desc?:@""];
        self.descLabel.text= self.isAuction ? @"温馨提示：如您“竞拍成功后完成商品支付”或“竞拍失败后拍卖活动结束”，您支付的保证金会原路返回，请您放心参与~" : content;
        
    }
    
}
-(void)timeCountDown{
    
    [self HideDescView];
    JH_WEAK(self)
    NSString * expireTime;
    if ([self.orderMode.orderStatus isEqualToString:@"waitack"]||
        [self.orderMode.orderStatus isEqualToString:@"waitpay"]) {
        expireTime=self.orderMode.payExpireTime;
        self.remainLabel.text=@"剩余支付时间:";
    }
    else if ([self.orderMode.orderStatus isEqualToString:@"refunding"]||
             [self.orderMode.orderStatus isEqualToString:@"refunded"]) {
        expireTime=self.orderMode.refundExpireTime;
        self.remainLabel.text=@"剩余退货时间:";
    }
    self.timerLabel.text=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:expireTime]];

    timer= [self creatTimerOnce];//[[BYTimer alloc]init];
    [timer createTimerWithTimeout:[CommHelp dateRemaining:expireTime] handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        NSLog(@"倒计时==%d",presentTime);
        self.timerLabel.text=[CommHelp getHMSWithSecond:presentTime];
    } finish:^{
        JH_STRONG(self)
        if ([self.orderMode.orderStatus isEqualToString:@"waitack"]||
            [self.orderMode.orderStatus isEqualToString:@"waitpay"]) {
            [self HideTimeView];
            self.descLabel.text=@"订单过期未支付！";
        }
        else if ([self.orderMode.orderStatus isEqualToString:@"refunding"]||
                 [self.orderMode.orderStatus isEqualToString:@"refunded"]) {
            [self HideTimeView];
            self.descLabel.text=@"";
        }
        
    }];
}
#pragma mark - 定制单

-(void)setCustomizeOrderMode:(JHCustomizeOrderModel *)customizeOrderMode{
    
    _customizeOrderMode = customizeOrderMode;
    [_logo jhSetImageWithURL:[NSURL URLWithString:_customizeOrderMode.icon?:@""]];
    self.titlelLabel.text=_customizeOrderMode.statusName?:@"";
    if (timer) {
        [timer stopGCDTimer];
        timer=nil;
    }
    //待确认 待付款
    if (_customizeOrderMode.customizeOrderStatusType == JHCustomizeOrderStatusWaitCharge||
        _customizeOrderMode.customizeOrderStatusType == JHCustomizeOrderStatusWaitOrder) {
        [self customizeWaitPayTimeCountDown];
    }
    //待用户确认方案
    else  if (_customizeOrderMode.customizeOrderStatusType == JHCustomizeOrderStatusWaitCustomerAckPlan&&
              !_customizeOrderMode.isSeller) {
        NSString *timeTitle = @"待确认方案剩余时间";
        [self customizeTimeCountDown:timeTitle];
    }
    //待用户发货
    else  if (_customizeOrderMode.customizeOrderStatusType == JHCustomizeOrderStatusWaitUserSend&&
              !_customizeOrderMode.isSeller) {
        NSString *timeTitle = @"待发货剩余时间";
        [self customizeTimeCountDown:timeTitle];
    }
    //待定制师发货
    else  if (_customizeOrderMode.customizeOrderStatusType == JHCustomizeOrderStatusWaitCustomizerSend&&
              _customizeOrderMode.isSeller) {
        NSString *timeTitle = @"待发货剩余时间";
        [self customizeTimeCountDown:timeTitle];
    }
    else{
         [self HideTimeView];
         self.descLabel.text=_customizeOrderMode.orderCopy;
    }
}
-(void)customizeWaitPayTimeCountDown{
    
    JH_WEAK(self)
    if([CommHelp dateRemaining:self.customizeOrderMode.payExpireTime] <=0){
        self.descLabel.text = @"订单过期未支付！";
        [self HideTimeView];
      }
     else
      {
        [self HideDescView];
        self.remainLabel.text=@"剩余支付时间:";
        self.timerLabel.text=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:self.customizeOrderMode.payExpireTime]];
       
          timer=[self creatTimerOnce];//[[BYTimer alloc]init];
        [timer createTimerWithTimeout:[CommHelp dateRemaining:self.customizeOrderMode.payExpireTime] handlerBlock:^(int presentTime) {
            JH_STRONG(self)
            self.timerLabel.text=[CommHelp getHMSWithSecond:presentTime];
        } finish:^{
            JH_STRONG(self)
            self.descLabel.text = @"订单过期未支付！";
            [self HideTimeView];
            
        }];
    }
    
}
//待确认方案 待发货 等倒计时
-(void)customizeTimeCountDown:(NSString*)timeTitle{
    
    //过期显示过期文案
    if (self.customizeOrderMode.isDownExpired) {
         [self HideTimeView];
         self.descLabel.text=_customizeOrderMode.downExpiredCopy;
    }
    else if([CommHelp dateRemaining:self.customizeOrderMode.downExpiredTime]>0){
        
        [self HideDescView];
        JH_WEAK(self)
        self.remainLabel.text= timeTitle;
        self.timerLabel.text=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:self.customizeOrderMode.downExpiredTime]];
       
        timer=[self creatTimerOnce];//[[BYTimer alloc]init];
        [timer createTimerWithTimeout:[CommHelp dateRemaining:self.customizeOrderMode.downExpiredTime] handlerBlock:^(int presentTime) {
            JH_STRONG(self)
            self.timerLabel.text=[CommHelp getHMSWithSecond:presentTime];
        } finish:^{
            JH_STRONG(self)
            [self HideTimeView];
             self.descLabel.text=_customizeOrderMode.downExpiredCopy;
        }];
    }
    //可能会有异常  及本地比对和服务器返回标识不一致，容错就直接显示默认文案
    else{
        [self HideTimeView];
        self.descLabel.text=_customizeOrderMode.orderCopy;
        
    }
    
}
-(void)HideDescView{
    
    self.descLabel.hidden=YES;
    self.descLabel.text= nil ;
    timerBack.hidden=NO;
}
-(void)HideTimeView{
    
    timerBack.hidden=YES;
    self.timerLabel.text = nil;
    self.remainLabel.text = nil;
    self.descLabel.hidden=NO;
}

- (UIButton *)statusButton {
    if (_statusButton == nil) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_statusButton setTitle:@"" forState:UIControlStateNormal];
        _statusButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:20];
        [_statusButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
    }
    return _statusButton;
}


- (void)dealloc
{
    [timer stopGCDTimer];
    timer=nil;
}
@end
