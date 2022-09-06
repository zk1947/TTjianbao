//
//  JHOrderPayViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderPayViewController.h"
#import "JHOrderPayView.h"
#import "JHPaySuccessViewController.h"
#import "JHBankPayInfoViewController.h"
#import "WXApi.h"
#import "NTESAudienceLiveViewController.h"
#import "JHOrderListViewController.h"
#import "JHOrderAgentPayViewController.h"
#import "WXPayDataMode.h"
#import "PayMode.h"
#import "JHOrderViewModel.h"
#import "AdressMode.h"
#import "TTjianbaoUtil.h"
#import "JHOrderDetailViewController.h"
#import "JHGoodsDetailViewController.h"
#import "PanNavigationController.h"
#import "JHCustomizeOrderDetailController.h"
#import "JHCustomizeOrderListViewController.h"
#import "JHC2CProductDetailController.h"
#import "JHNewPaySuccessViewController.h"
#import "JHMarketOrderDetailViewController.h"
#import "JHMarketOrderListViewController.h"
#import "JHStoreDetailViewController.h"

static NSInteger allTryCount=2;
@interface JHOrderPayViewController ()<JHOrderPayViewDelegate,UIScrollViewDelegate>
{
    JHOrderPayView * orderView;
    WXPayDataMode * wxPayMode;
    ALiPayDataMode * aLiPayMode;
    BOOL isPaying;
    NSInteger tryQueryCount;
    CGFloat alphaValue;   ///导航栏透明度
    BOOL titleHidden;
   
}
@property(strong,nonatomic) JHOrderDetailMode* orderMode;
@property(strong,nonatomic) PayWayMode* payWayMode;

@property(strong,nonatomic) NSString* payWay;
@property(strong,nonatomic) NSString* payWayString;


@end

@implementation JHOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:OrderPayInfoStatusChangeNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(WillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
     [self initContentView];
     [self.view bringSubviewToFront:self.jhNavView];
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
//    [self initToolsBar];
     self.title = @"支付订单";
     [self.jhTitleLabel setHidden:YES];
//    [self.navbar setTitle:@"支付订单"];
//     [self.navbar addBtn:nil withImage:kNavBackWhiteShadowImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//     [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navbar.ImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
//    self.navbar.titleLbl.hidden=YES;
    [self requestInfo];
    [self requestPayWays];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
    nav.isForbidDragBack = YES;
        
    }
    [self reportPageView];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = NO;
        
    }
}
-(void)initContentView{
    
    orderView=[[JHOrderPayView alloc]init];
    orderView.isAuction = self.isAuction;
    orderView.delegate=self;
    orderView.contentScroll.delegate=self;
    if(self.isMarket){
        [orderView displayMarket];
    }
    if (self.isAuction) {
        [orderView dealAuctionUI];
    }
    [self.view addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        
    }];
}
-(void)WillEnterForeground:(NSNotificationCenter*)note{
    if (isPaying) {
        isPaying=NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [self requestPayStatus];
    }
}
-(void)backActionButton:(UIButton *)sender{
    [self backToVc];
}

- (void)backToVc {
    BOOL  isPop=NO;
    for (UIViewController* vc in self.navigationController.viewControllers.reverseObjectEnumerator.allObjects) {
        if ([vc isKindOfClass: [NTESAudienceLiveViewController  class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHOrderListViewController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHGoodsDetailViewController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHCustomizeOrderDetailController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHCustomizeOrderListViewController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHC2CProductDetailController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHMarketOrderDetailViewController class]]) {
            isPop=YES;
            //通知刷新
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHMarketOrderListViewController class]]) {
            isPop=YES;
            //通知刷新
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHStoreDetailViewController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        
        
        
    }
    if (!isPop) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)requestInfo{
    
    if (JH_UNION_ENABLE) {
        [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/friendsPaying/v2?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            self.orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
            [orderView setOrderMode:self.orderMode];
            
        } failureBlock:^(RequestModel *respondObject) {
            [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }];
        
        [SVProgressHUD show];
    }
    else{
        [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/friendsPaying?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            self.orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
            [orderView setOrderMode:self.orderMode];
            
        } failureBlock:^(RequestModel *respondObject) {
            [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }];
        
        [SVProgressHUD show];
        
    }
    
//#ifdef JH_UNION_PAY
//    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/friendsPaying/v2?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
//#else
//    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/friendsPaying?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
//#endif
//        [SVProgressHUD dismiss];
//        self.orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
//        [orderView setOrderMode:self.orderMode];
//
//    } failureBlock:^(RequestModel *respondObject) {
//        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
//        [self.navigationController popViewControllerAnimated:YES];
//        [SVProgressHUD dismiss];
//    }];
//
//    [SVProgressHUD show];
}
-(void)requestPayWays{
    [PayMode requestOrderPayWays:self.orderId completion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            NSDictionary*dic=respondObject.data;
            NSArray * arr= [PayWayMode mj_objectArrayWithKeyValuesArray:dic.allValues];
            [orderView setPayWayArray:[PayMode sortbyPay:arr]];
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
}

-(void)Complete:(PayWayMode *)mode andPayMoney:(double)money{
    //埋点
    [self reportPayEvent:[NSString stringWithFormat: @"%f", money]];
    
    tryQueryCount=0;
    [JHOrderViewModel  OrderPayCheckWithOrderId:self.orderMode.orderId completion:^(RequestModel * _Nonnull respondObject, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.payWayMode=mode;
            switch (mode.Id) {
                case JHPayTypeWxPay:
                    [JHGrowingIO trackOrderEventId:JHTrackorder_pay_paybtn orderCode:self.orderMode.orderCode payWay:@"weixin" suc:@""];
                    [self WXPrepay:money];
                    break;
                case JHPayTypeAliPay:
                    [JHGrowingIO trackOrderEventId:JHTrackorder_pay_paybtn orderCode:self.orderMode.orderCode payWay:@"zhifubao" suc:@""];
                    [self ALiPrepay:money];
                    break;
                case JHPayTypeBank:
                {
                    [JHGrowingIO trackOrderEventId:JHTrackorder_pay_paybtn orderCode:self.orderMode.orderCode payWay:@"xianxiadakuan" suc:@""];
                    JHBankPayInfoViewController * bankInfo=[[JHBankPayInfoViewController alloc]init];
                    bankInfo.orderId=self.orderId;
                    bankInfo.orderCode=self.orderMode.orderCode;
                    [self.navigationController pushViewController:bankInfo animated:YES];
                }
                    break;
                case JHPayTypeAgentPay:
                {
                    [JHGrowingIO trackOrderEventId:JHTrackorder_pay_paybtn orderCode:self.orderMode.orderCode payWay:@"replacePay" suc:@""];
                    JHOrderAgentPayViewController * vc=[[JHOrderAgentPayViewController alloc]init];
                    vc.orderId=self.orderId;
                    vc.money=money;
                    vc.orderMode=self.orderMode;
                    vc.payId=self.payWayMode.Id;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
        else{
            CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
    }];
    [SVProgressHUD show];
}
-(void)WXPrepay:(double)payMoney{
    
//    NSDictionary *parameters=@{ @"payId":[NSString stringWithFormat:@"%d",self.payWayMode.Id],
//                                @"orderId":self.orderId,
//                                @"portalEnum":@"ios",
//                                @"payMoney":[NSString stringWithFormat:@"%.2f",payMoney],
//
//    };
    
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/prepay") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//        [SVProgressHUD dismiss];
//        wxPayMode=[WXPayDataMode mj_objectWithKeyValues: respondObject.data];
//        [self WXPay:wxPayMode];
//        isPaying=YES;
//
//    } failureBlock:^(RequestModel *respondObject) {
//
//        [SVProgressHUD dismiss];
//        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
//    }];
       JHPrepayReqModel * reqMode=[[JHPrepayReqModel alloc]init];
       reqMode.payId=[NSString stringWithFormat:@"%d",self.payWayMode.Id];
       reqMode.payMoney=[NSString stringWithFormat:@"%.2f",payMoney];
       reqMode.orderId=self.orderId;
      [PayMode WXOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            wxPayMode=[WXPayDataMode mj_objectWithKeyValues: respondObject.data];
            [self WXPay:wxPayMode];
            isPaying=YES;
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            
            //预支付失败,也算失败
            //埋点：订单支付成功与失败{"suc":"suc|failed|cancel", "payWay":"weixin|zhifubao"}
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setValue:@"failed" forKey:@"suc"];
            if(self.payWay){
                [dic setValue:self.payWay forKey:@"payWay"];
            }
            if(self.orderMode.orderCode){
                [dic setValue:self.orderMode.orderCode forKey:@"orderCode"];
            }
            //意向金订单埋点
            if(self.orderMode.orderCategoryType==JHOrderCategoryRestoreIntention){
                [JHGrowingIO trackEventId:JHTrackStoneRestore_orderpay variables:dic];
            }
        }
    }];
    
    [SVProgressHUD show];
    
}
-(void)ALiPrepay:(double)payMoney{
    
//    NSDictionary *parameters=@{ @"payId":[NSString stringWithFormat:@"%d",self.payWayMode.Id],
//                                @"orderId":self.orderId,
//                                @"portalEnum":@"ios",
//                                @"payMoney":[NSString stringWithFormat:@"%.2f",payMoney],
//    };
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/aliprepay") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//        [SVProgressHUD dismiss];
//        aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: respondObject.data];
//        [self AliPay:aLiPayMode.token];
//        isPaying=YES;
//
//    } failureBlock:^(RequestModel *respondObject) {
//
//        [SVProgressHUD dismiss];
//        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
//    }];
    
    JHPrepayReqModel * reqMode=[[JHPrepayReqModel alloc]init];
    reqMode.payId=[NSString stringWithFormat:@"%d",self.payWayMode.Id];
    reqMode.payMoney=[NSString stringWithFormat:@"%.2f",payMoney];
    reqMode.orderId=self.orderId;
    [PayMode ALiOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: respondObject.data];
            if (JH_UNION_ENABLE) {
                [self AliPay:aLiPayMode.appPayRequest];
            }
            else{
                [self AliPay:aLiPayMode.token];
                
            }
//#ifdef JH_UNION_PAY
//            [self AliPay:aLiPayMode.appPayRequest];
//#else
//            [self AliPay:aLiPayMode.token];
//#endif
            isPaying=YES;
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            
            //预支付失败,也算失败
            //埋点：订单支付成功与失败{"suc":"suc|failed|cancel", "payWay":"weixin|zhifubao"}
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setValue:@"failed" forKey:@"suc"];
            if(self.payWay){
                [dic setValue:self.payWay forKey:@"payWay"];
            }
            if(self.orderMode.orderCode){
                [dic setValue:self.orderMode.orderCode forKey:@"orderCode"];
            }
            //意向金订单埋点
            if(self.orderMode.orderCategoryType==JHOrderCategoryRestoreIntention){
                [JHGrowingIO trackEventId:JHTrackStoneRestore_orderpay variables:dic];
            }
        }
    }];
    
    [SVProgressHUD show];
}
-(void)WXPay:(WXPayDataMode*)pay{
    
//    PayReq *request = [[PayReq alloc] init] ;
//    request.partnerId = pay.partnerid;
//    request.prepayId= pay.prepayid;
//    request.package = pay.package;
//    request.nonceStr= pay.noncestr;
//    request.timeStamp= pay.timestamp;
//    request.sign= pay.sign;
//    [WXApi sendReq:request];
    [PayMode WXPay:pay];
}

-(void)AliPay:(NSString*)orderString{
    
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
//        if (isPaying) {
//               isPaying=NO;
//               [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//               [self requestPayStatus];
//           }
//    }];
    JH_WEAK(self)
    [PayMode AliPay:orderString callback:^(id obj) {
        JH_STRONG(self)
        NSLog(@"reslut = %@",(NSDictionary*)obj);
        if (isPaying) {
            isPaying=NO;
            [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            [self requestPayStatus];
        }
    } ];
}
-(void)requestPayStatus{
    
      tryQueryCount++;
      NSString *outTradeNo;
     if (wxPayMode&&self.payWayMode.Id==JHPayTypeWxPay) {
         if (JH_UNION_ENABLE) {
             outTradeNo=wxPayMode.outTradeNo;
         }
         else{
             outTradeNo=wxPayMode.out_trade_no;
             
         }
// #ifdef JH_UNION_PAY
//         outTradeNo=wxPayMode.outTradeNo;
// #else
//         outTradeNo=wxPayMode.out_trade_no;
// #endif
        self.payWay=@"weixin";
        self.payWayString=@"微信";
    }
    else  if (aLiPayMode&&self.payWayMode.Id==JHPayTypeAliPay) {
        outTradeNo=aLiPayMode.outTradeNo;
        self.payWay=@"zhifubao";
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
- (void)pushPaySuccess:(PayResultMode*)resultMode {
    if ([self.orderCategory isEqualToString:@"marketAuctionOrder"]) {
        [self backToVc];
        return;
    }
    else if (self.isMarket) {
        JHNewPaySuccessViewController *success = [[JHNewPaySuccessViewController alloc] init];
        success.paymoney=resultMode.payMoney;
        success.orderId=self.orderId;
        [self.navigationController pushViewController:success animated:YES];
        return;
    }
    JHPaySuccessViewController * success=[[JHPaySuccessViewController alloc]init];
    success.paymoney=resultMode.payMoney;
    success.orderId=self.orderId;
    [self.navigationController pushViewController:success animated:YES];
}
-(void)handlePaySuccessStatus:(PayResultMode*)resultMode{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([resultMode.return_code isEqualToString:@"SUCCESS"]) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [JHGrowingIO trackOrderEventId:JHTrackorder_pay_result_weixin orderCode:self.orderMode.orderCode payWay:self.payWay suc:@"true"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
        [self pushPaySuccess:resultMode];
        
        [dic setValue:@"suc" forKey:@"suc"];
    }
    else if ([resultMode.return_code isEqualToString:@"FAIL"]) {
        [JHGrowingIO trackOrderEventId:JHTrackorder_pay_result_weixin orderCode:self.orderMode.orderCode payWay:self.payWay suc:@"false"];
        [dic setValue:@"failed" forKey:@"suc"];
    }
    else if ([resultMode.return_code isEqualToString:@"NOTPAY"]) {

    }
    else if ([resultMode.return_code isEqualToString:@"PAYING"]) {
        
    }
    if (![resultMode.return_code isEqualToString:@"SUCCESS"]){
        [self handlePayFailureStatus];
    }
    
    //埋点：订单支付成功与失败{"suc":"suc|failed|cancel", "payWay":"weixin|zhifubao"}
    if(self.payWay){
      [dic setValue:self.payWay forKey:@"payWay"];
    }
    if(self.orderMode.orderCode){
        [dic setValue:self.orderMode.orderCode forKey:@"orderCode"];
    }
    //意向金订单埋点
    if(self.orderMode.orderCategoryType==JHOrderCategoryRestoreIntention){
        [JHGrowingIO trackEventId:JHTrackStoneRestore_orderpay variables:dic];
    }
}
-(void)handlePayFailureStatus{
    if (tryQueryCount<allTryCount) {
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self requestPayStatus];
           });
       }
       else{
           [MBProgressHUD hideHUDForView:self.view animated:NO];
           [self showFailAlert];
       }
    
}
-(void)showFailAlert{
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"支付提醒" andDesc:[NSString stringWithFormat:@"由于%@支付的原因\n未获得支付结果",self.payWayString] cancleBtnTitle:@"未支付" sureBtnTitle:@"已支付"];
    alert.titleImage.image=[UIImage imageNamed:@"pay_result_tip-icon"];
    JH_WEAK(self)
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.handle = ^{
        JH_STRONG(self)
        JHOrderDetailViewController * orderdetail=[[JHOrderDetailViewController alloc]init];
        orderdetail.orderId=self.orderMode.orderId;
        [self.navigationController pushViewController:orderdetail animated:YES];
    };
    
}
#pragma ------ UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        CGFloat offsetY = scrollView.contentOffset.y;
        NSLog(@"%lf",offsetY);
        alphaValue = offsetY / kHeaderH;
        if (alphaValue >= 1) {
            alphaValue = 1;
        }
        titleHidden = (offsetY < kHeaderH/2);
//        self.navbar.ImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
//        self.navbar.titleLbl.hidden=titleHidden;
        UIImage * image= titleHidden ? kNavBackWhiteShadowImg : kNavBackBlackImg;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
        self.jhTitleLabel.hidden = titleHidden;
        [self.jhLeftButton setImage:image forState:UIControlStateNormal];
        [self.jhLeftButton setImage:image forState:UIControlStateSelected];
//        [self.navbar.comBtn setImage:image forState:UIControlStateNormal];
//        [self.navbar.comBtn setImage:image forState:UIControlStateSelected];
        [self setNeedsStatusBarAppearanceUpdate];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 埋点
/// 提交页面埋点
- (void)reportPageView {
    NSMutableDictionary *par = [NSMutableDictionary new];
    [par setValue: @"收银台页" forKey:@"page_name"];
    [par setValue: self.goodsId ?: @"" forKey:@"commodity_id"];
    [par setValue: self.orderId forKey:@"order_id"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
- (void)reportPayEvent : (NSString *)amount {
    NSMutableDictionary *par = [NSMutableDictionary new];
    [par setValue: @"收银台页" forKey:@"page_position"];
    [par setValue: self.goodsId ?: @"" forKey:@"commodity_id"];
    [par setValue: self.orderId forKey:@"order_id"];
    [par setValue: self.orderMode.orderCategory forKey:@"order_category"];
    [par setValue: amount forKey:@"order_actual_amount"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickPayOrder"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end
