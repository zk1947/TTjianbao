//
//  JHAppraisePayView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
#import "JHAppraisePayView.h"
#import "JHAppraisePayInfoView.h"
#import "PayMode.h"
#import "JHMarketOrderViewModel.h"
#import "JHAppraisePayModel.h"
#import "JHWebViewController.h"
#import "JHAuthorize.h"
static NSInteger allTryCount=2;
@interface JHAppraisePayView (){
    
    BOOL isPaying;
    NSInteger tryQueryCount;
    WXPayDataMode *wxPayMode;
    ALiPayDataMode *aLiPayMode;
}
@property (nonatomic, strong) JHAppraisePayInfoView *contentView;
@property (nonatomic, strong) JHAppraisePayModel *appraisePayModel;
@property(assign,nonatomic) JHPayType payWayType;
@property(strong,nonatomic) NSString* payWayString;
//@property (nonatomic, strong) WXPayDataMode *wxPayMode;
//@property (nonatomic, strong)  ALiPayDataMode *aLiPayMode;

@end

@implementation JHAppraisePayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [self initSubview];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(WillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
       
    }
    return self;
}
-(void)WillEnterForeground:(NSNotificationCenter*)note{
    if (isPaying) {
        isPaying=NO;
        [MBProgressHUD showHUDAddedTo:JHKeyWindow animated:NO];
        [self requestPayStatus];
    }
}
- (void)initSubview {
    
    self.backgroundColor = HEXCOLORA(0x000000, 0.6);
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        //make.height.offset(545);
        make.height.offset(545);
       // make.height.offset(660);
    }];
    
    @weakify(self);
    self.contentView .dissBlock = ^{
        
     @strongify(self);
        
    [self hiddenAlert];
        if(self.hiddenBlock){
            self.hiddenBlock();
        }
    };
    
    //支付
    self.contentView.payBlock = ^(id obj) {
        @strongify(self);
        NSDictionary *parameter = (NSDictionary*)obj;
        
        self.payWayType = [parameter[@"payId"] intValue];
        
        [self preparePay:parameter];
    };
    
    self.contentView.protocalBlock = ^{
        
        @strongify(self);
        [self hiddenAlert];
      
        JHWebViewController *web = [[JHWebViewController alloc] init];
        web.urlString =  H5_BASE_STRING(@"/jianhuo/app/agreement/authenticationService.html");;
        [JHRootController.homeTabController.navigationController pushViewController:web animated:YES];
    };
    
    
}

-(void)preparePay:(NSDictionary*)parameter{
    
    [JHTracking trackEvent:@"clickPayOrder" property:@{@"page_position":@"集市鉴定收银台弹层页",@"commodity_id":self.appraisePayModel.goodsId,@"order_id":self.appraisePayModel.orderId}];
   
    [JHMarketOrderViewModel appriaseOrderPreparePay:parameter
                                         completion:^(RequestModel *respondObject, NSError *error) {
        
        [MBProgressHUD hideHUDForView:JHKeyWindow animated:NO];
        DDLogInfo(@"isNeedPay====%@",respondObject.data);
        
        if (error) {
        [JHKeyWindow makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if ([respondObject.data[@"isNeedPay"] boolValue]) {
            if (self.payWayType  == JHPayTypeWxPay ) {
                isPaying=YES;
                wxPayMode=[WXPayDataMode mj_objectWithKeyValues: respondObject.data[@"payParam"]];
                [PayMode WXPay:wxPayMode];
            }
           
            if (self.payWayType  == JHPayTypeAliPay ) {
                aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: respondObject.data[@"payParam"]];
                isPaying=YES;
                JH_WEAK(self)
                [PayMode AliPay:aLiPayMode.token callback:^(id obj) {
                    JH_STRONG(self)
                    NSLog(@"reslut = %@",(NSDictionary*)obj);
                    if (isPaying) {
                        isPaying=NO;
                        [MBProgressHUD showHUDAddedTo:JHKeyWindow animated:NO];
                        [self requestPayStatus];
                    }
                } ];
            }
            

            
            
        }
        else{
            [JHKeyWindow makeToast:@"支付成功，48小时内根据图文出具鉴定报告" duration:1.0 position:CSToastPositionCenter];
            
            if (self.paySuccessBlock) {
                self.paySuccessBlock();
            }
            [self hiddenAlert];
            
        }
    }];
    [MBProgressHUD showHUDAddedTo:JHKeyWindow animated:NO];
    
    
}
-(void)requestInfo{
    
    [JHMarketOrderViewModel confirmAppriaseOrderDetail:@{@"orderId":self.orderId} completion:^(RequestModel *respondObject, NSError *error) {
        
        if (!error) {
          self.appraisePayModel= [JHAppraisePayModel mj_objectWithKeyValues: respondObject.data];
            NSDictionary * dic = respondObject.data[@"payWayMap"];
            NSArray * arr= [PayWayMode mj_objectArrayWithKeyValuesArray:dic.allValues];
            self.appraisePayModel.payWayArray = arr;
        [self.contentView setAppraisePayModel:self.appraisePayModel];
            
        }
        else{
            
            [self.contentView setAppraisePayModel:self.appraisePayModel];
            [self makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
}
-(void)requestPayStatus{
    
      tryQueryCount++;
      NSString *outTradeNo;
     if (wxPayMode&&self.payWayType==JHPayTypeWxPay) {
         outTradeNo=wxPayMode.out_trade_no;
//        self.payWay=@"weixin";
        self.payWayString=@"微信";
    }
    else  if (aLiPayMode&&self.payWayType==JHPayTypeAliPay) {
        outTradeNo=aLiPayMode.outTradeNo;
      //  self.payWay=@"zhifubao";
        self.payWayString=@"支付宝";
    }

    [PayMode requestOrderPayStatus:outTradeNo completion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
        PayResultMode  * resultMode=[PayResultMode mj_objectWithKeyValues: respondObject.data];
            [self handlePaySuccessStatus:resultMode];
        }
        else{
            [self handlePayFailureStatus];
        }
    }];
    
}
-(void)handlePaySuccessStatus:(PayResultMode*)resultMode{
    
    
    if ([resultMode.return_code isEqualToString:@"SUCCESS"]) {
        
        [MBProgressHUD hideHUDForView:JHKeyWindow animated:NO];
        [self makeToast:@"支付成功，48小时内根据图文出具鉴定报告" duration:1.0 position:CSToastPositionCenter];
        
        if (self.paySuccessBlock) {
            self.paySuccessBlock();
        }
        [self hiddenAlert];
        if ([self.from isEqualToString:@"ProductDetail"]) {
            [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeAppraisalPaymentSuccess];
        }
        
    }
    else if ([resultMode.return_code isEqualToString:@"FAIL"]) {
       
       
    }
    else if ([resultMode.return_code isEqualToString:@"NOTPAY"]) {

    }
    else if ([resultMode.return_code isEqualToString:@"PAYING"]) {
        
    }
    if (![resultMode.return_code isEqualToString:@"SUCCESS"]){
        [self handlePayFailureStatus];
    }
    
}
-(void)handlePayFailureStatus{
    if (tryQueryCount<allTryCount) {
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self requestPayStatus];
           });
       }
       else{
           [MBProgressHUD hideHUDForView:JHKeyWindow animated:NO];
           
           [self showFailAlert];
       }
    
}
-(void)showFailAlert{
    
    [self requestInfo];
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"支付提醒" andDesc:[NSString stringWithFormat:@"由于%@支付的原因\n未获得支付结果",@""] cancleBtnTitle:@"未支付" sureBtnTitle:@"已支付"];
    alert.titleImage.image=[UIImage imageNamed:@"pay_result_tip-icon"];
    JH_WEAK(self)
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.handle = ^{
        JH_STRONG(self)
//        JHOrderDetailViewController * orderdetail=[[JHOrderDetailViewController alloc]init];
//        orderdetail.orderId=self.orderMode.orderId;
//        [self.navigationController pushViewController:orderdetail animated:YES];
    };
    
}
#pragma mark - GET

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [JHAppraisePayInfoView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (void)showAlert {
    
    [self layoutIfNeeded];
    CGRect rect = self.contentView.frame;
    self.contentView.mj_y = ScreenH;
    rect.origin.y = ScreenH - rect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.frame = rect;
    }];
    [self requestInfo];
    [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"集市鉴定费用收银台弹层页",@"commodity_id":self.orderId}];
}

- (void)hiddenAlert {
    CGRect rect = self.contentView.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.frame = rect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)hiddenAlertCompletion:(void (^)(BOOL))completion {
    CGRect rect = self.contentView.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self hiddenAlert];
//}


@end


