//
//  JHOrdePayGradationViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrdePayGradationViewController.h"
#import "JHOrdePayGradationView.h"
#import "JHPaySuccessViewController.h"
#import "JHBankPayInfoViewController.h"
#import "WXApi.h"
#import "WXPayDataMode.h"
#import "PayMode.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoUtil.h"
#import "TTjianbaoBussiness.h"

@interface JHOrdePayGradationViewController ()<JHOrdePayGradationViewDelegate>
{
    JHOrdePayGradationView * orderView;
    WXPayDataMode * wxPayMode;
    ALiPayDataMode * aLiPayMode;
    BOOL isPaying;
    
}
@property(strong,nonatomic) OrderMode* orderMode;
@property(strong,nonatomic) PayWayMode* payWayMode;
@end

@implementation JHOrdePayGradationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar setTitle:@"分次支付"];
    self.title = @"分次支付";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

    [self  initContentView];
    [self requestInfo];
    [self requestPayWays];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}
-(void)initContentView{
    
    orderView=[[JHOrdePayGradationView alloc]init];
    orderView.delegate=self;
    [self.view addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        
    }];
}
-(void)enterFore{
    
    if (isPaying) {
        [self requestPayStatus];
        isPaying=NO;
    }
}

-(void)requestInfo{
    
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/paying?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        self.orderMode = [OrderMode mj_objectWithKeyValues: respondObject.data];
        [orderView setOrderMode:self.orderMode];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}

-(void)requestPayWays{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/payway/all") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary*dic=respondObject.data;
        NSMutableArray * arr= [PayWayMode mj_objectArrayWithKeyValuesArray:dic.allValues];
        for (PayWayMode * mode in arr) {
            if (mode.Id==JHPayTypeBank) {
                [arr removeObject:mode];
                break;
            }
        }
        [orderView setPayWayArray:[self sortbyPay:arr]];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
-(NSArray *)sortbyPay:(NSArray *)array{
    
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        PayWayMode *mode1 = (PayWayMode *)obj1;
        PayWayMode *mode2 = (PayWayMode *)obj2;
        if (mode1.sort > mode2.sort) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (mode1.sort < mode2.sort){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
        
    }];
    return sorteArray;
}
//weixin|zhifubao|xianxiadakuan|multi
-(void)Complete:(PayWayMode *)mode andPayMoney:(double)money{
    
    
    [JHOrderViewModel  OrderPayCheckWithOrderId:self.orderMode.orderId completion:^(RequestModel * _Nonnull respondObject, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.payWayMode=mode;
            switch (mode.Id) {
                case JHPayTypeWxPay:
                [self WXPrepay:money];
            [JHGrowingIO trackOrderEventId:JHTrackorder_pay_mul_paybtn orderCode:self.orderMode.orderCode payWay:@"weixin" suc:@""];
                    break;
                  case JHPayTypeAliPay:
                    [self ALiPrepay:money];
                     [JHGrowingIO trackOrderEventId:JHTrackorder_pay_mul_paybtn orderCode:self.orderMode.orderCode payWay:@"zhifubao" suc:@""];
                    break;
                case JHPayTypeBank:
                {
                    JHBankPayInfoViewController * bankInfo=[[JHBankPayInfoViewController alloc]init];
                    bankInfo.orderId=self.orderId;
                    [self.navigationController pushViewController:bankInfo animated:YES];
                       [JHGrowingIO trackOrderEventId:JHTrackorder_pay_mul_paybtn orderCode:self.orderMode.orderCode payWay:@"xianxiadakuan" suc:@""];
                }
                    break;
                default:
                    break;
            }
        }
        else{
            [self.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
        }
    }];
    [SVProgressHUD show];
    
}
-(void)WXPrepay:(double)payMoney{
    
    NSDictionary *parameters=@{ @"payId":[NSString stringWithFormat:@"%d",self.payWayMode.Id],
                                @"orderId":self.orderId,
                                @"portalEnum":@"ios",
                                @"payMoney":[NSString stringWithFormat:@"%.2f",payMoney]
                                };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/prepay") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        wxPayMode=[WXPayDataMode mj_objectWithKeyValues: respondObject.data];
        [self WXPay:wxPayMode];
        isPaying=YES;
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
    
}
-(void)ALiPrepay:(double)payMoney{
    
    NSDictionary *parameters=@{ @"payId":[NSString stringWithFormat:@"%d",self.payWayMode.Id],
                                @"orderId":self.orderId,
                                @"portalEnum":@"ios",
                                 @"payMoney":[NSString stringWithFormat:@"%.2f",payMoney]
                                };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/aliprepay") Parameters:parameters isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: respondObject.data];
        [self AliPay:aLiPayMode.token];
        isPaying=YES;
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
    
}
-(void)WXPay:(WXPayDataMode*)pay{
    
    PayReq *request = [[PayReq alloc] init] ;
    request.partnerId = pay.partnerid;
    request.prepayId= pay.prepayid;
    request.package = pay.package;
    request.nonceStr= pay.noncestr;
    request.timeStamp= pay.timestamp;
    request.sign= pay.sign;
    [WXApi sendReq:request completion:^(BOOL success) {
        
    }];
}

-(void)AliPay:(NSString*)orderString{
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        
        
    }];
}
-(void)requestPayStatus{
    
    NSString *outTradeNo;
    NSString * payWay;
    if (wxPayMode&&self.payWayMode.Id==JHPayTypeWxPay) {
        if (JH_UNION_ENABLE) {
            outTradeNo=wxPayMode.outTradeNo;
        }
        else{
            outTradeNo=wxPayMode.out_trade_no;
            
        }
//#ifdef JH_UNION_PAY
//        outTradeNo=wxPayMode.outTradeNo;
//#else
//        outTradeNo=wxPayMode.out_trade_no;
//#endif
        payWay=@"weixin";
    }
    else  if (aLiPayMode&&self.payWayMode.Id==JHPayTypeAliPay) {
        outTradeNo=aLiPayMode.outTradeNo;
         payWay=@"zhifubao";
    }
    
    
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/pay/auth/order/status?outTradeNo=") stringByAppendingString:OBJ_TO_STRING(outTradeNo)] Parameters:nil  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        PayResultMode  * resultMode=[PayResultMode mj_objectWithKeyValues: respondObject.data];
        
        if ([resultMode.return_code isEqualToString:@"SUCCESS"]) {
             [JHGrowingIO trackOrderEventId:JHTrackorder_pay_mul_result_weixin orderCode:self.orderMode.orderCode payWay:payWay suc:@"true"];
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
            JHPaySuccessViewController * success=[[JHPaySuccessViewController alloc]init];
            success.paymoney=resultMode.payMoney;
            success.orderId=self.orderId;
            [self.navigationController pushViewController:success animated:YES];
        }
        else if ([resultMode.return_code isEqualToString:@"FAIL"]) {
              [JHGrowingIO trackOrderEventId:JHTrackorder_pay_mul_result_weixin orderCode:self.orderMode.orderCode payWay:payWay suc:@"false"];
            [self.view makeToast:@"支付失败"];
        }
        else if ([resultMode.return_code isEqualToString:@"PAYING"]) {
            
            [[UIApplication sharedApplication].keyWindow makeToast:@"正在支付中,请稍后查询结果" duration:2.0 position:CSToastPositionCenter];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        
    }];
    
    [SVProgressHUD show];
    
}
-(BOOL)isNeedPay{
    
    double payMoney=[self.orderMode.orderPrice doubleValue]-[self.orderMode.payedMoney doubleValue];
    NSLog(@"%.2f",payMoney);
    if (payMoney<=0) {
        return NO;
    }
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

