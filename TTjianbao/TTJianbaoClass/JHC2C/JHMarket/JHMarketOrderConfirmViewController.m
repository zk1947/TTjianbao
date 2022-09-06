//
//  JHMarketOrderConfirmViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/6/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderConfirmViewController.h"
#import "JHOrderConfirmView.h"
#import "AddAdressViewController.h"
#import "AdressManagerViewController.h"
#import "JHOrderPayViewController.h"
#import "JHPaySuccessViewController.h"
#import "JHWebViewController.h"
#import "BaseNavViewController.h"
#import "CommAlertView.h"
#import "TTjianbaoBussiness.h"
#import "JHOrderViewModel.h"
#import <IQKeyboardManager.h>
#import "JHOrderPayMaterialAlert.h"
#import "JHNewPaySuccessViewController.h"
#import "JHMarketHomeBusiness.h"

@interface JHMarketOrderConfirmViewController ()<JHOrderConfirmViewDelegate>
{
    JHOrderConfirmView * orderView;
    CommAlertView*  alert;
    NSTimeInterval liveIntime;
}
@property(strong,nonatomic) JHOrderDetailMode* orderConfirmMode;
@property(strong,nonatomic) AdressMode * addressMode;
@property(assign,nonatomic) BOOL isStoneOrder;

@property(assign,nonatomic) BOOL isMarketOrder;
@end

@implementation JHMarketOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    self.view.backgroundColor = HEXCOLOR(0xffffff);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAddress) name:ADRESSALTERSUSSNotifaction object:nil];
    
    self.isMarketOrder = YES;
    
    [self  initContentView];
    [self requestAddress];
    
    if (self.activeConfirmOrder && self.orderId == nil) {
        self.title = @"提交订单";
        [self requestGoodsConfirmDetail:1];
    }
    else{
        self.title = @"确认订单";
        [self requestOrderConfirmDetail];
    }
    NSMutableArray *arr=[self.navigationController.viewControllers mutableCopy];
    for ( UIViewController *vc in arr) {
        if ([vc isKindOfClass:[JHMarketOrderConfirmViewController class]]&&vc != self) {
            [arr removeObject:vc];
            self.navigationController.viewControllers=arr;
            break;
        }
    }
    
    if ([self.orderCategory isEqualToString:@"marketFixedOrder"]) {
        self.title = @"确认订单";
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = YES;
    }
    if (self.isStoneOrder) {
        [self requestRiskInfo];
    }
    [self reportPageView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    liveIntime = time(NULL);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSInteger dur = 0;
    if (liveIntime>0) {
        dur = time(NULL)-liveIntime;
    }
    
    [JHGrowingIO trackEventId:JHTrackConfirmOrderDuration variables:@{@"duration":[NSString stringWithFormat:@"%ld",(long)dur]}];
    
    
}


-(void)requestOrderConfirmDetail{
    [SVProgressHUD show];
    [JHOrderViewModel requestOrderConfirmDetail:self.orderId completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.orderConfirmMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
            
            self.orderConfirmMode.isC2C = YES;
            
            [orderView setOrderConfirmMode:self.orderConfirmMode];
            
            [orderView dispayMarketView];
            //判断原石消费是否超额
            if ([self.orderConfirmMode.channelCategory isEqualToString:@"roughOrder"]) {
                self.isStoneOrder=YES;
                [self requestRiskInfo];
            }
            //获取服务费信息
            [self requestIntention];
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
}
-(void)requestGoodsConfirmDetail:(NSInteger)goodsCount {
    /// 一口价
    if ([self.orderCategory isEqualToString:@"marketFixedOrder"]) {
        JHNewStoreOrderDetailReqModel * mode =[[JHNewStoreOrderDetailReqModel alloc]init];
        mode.productId = self.goodsId;
        mode.showId = self.showId;
        mode.orderCategory = self.orderCategory;
        mode.productCount = goodsCount;
        
        [JHOrderViewModel requestNewStoreConfirmDetailC2C:mode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                self.orderConfirmMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                //后台没返  等返了删了
                self.orderConfirmMode.orderCategory = @"marketFixedOrder";
                self.orderConfirmMode.isC2C = YES;
                [orderView setOrderConfirmMode:self.orderConfirmMode];
                
                [orderView dispayMarketView];
            }
            else{
                
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
        }];
        [SVProgressHUD show];
        return;
    }
    /// 拍卖
    if ([self.orderCategory isEqualToString:@"marketAuctionOrder"]) {
        JHNewStoreOrderDetailReqModel * mode =[[JHNewStoreOrderDetailReqModel alloc]init];
        mode.productId = self.goodsId;
        mode.showId = self.showId;
        mode.orderCategory = self.orderCategory;
        mode.productCount = goodsCount;
        
        [JHOrderViewModel requestNewStoreConfirmDetailC2C:mode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                self.orderConfirmMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                //后台没返  等返了删了
                self.orderConfirmMode.orderCategory = @"marketFixedOrder";
                self.orderConfirmMode.isC2C = YES;
                [orderView setOrderConfirmMode:self.orderConfirmMode];
                
                [orderView dispayMarketView];
            }
            else{
                
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
        }];
        [SVProgressHUD show];
        return;
    }

    if ([self.orderCategory isEqualToString:@"mallOrder"]) {
        JHNewStoreOrderDetailReqModel * mode =[[JHNewStoreOrderDetailReqModel alloc]init];
        mode.productId=self.goodsId;
        mode.showId=self.showId;
        mode.productCount=goodsCount;
        [JHOrderViewModel requestNewStoreConfirmDetail:mode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                self.orderConfirmMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                //后台没返  等返了删了
                self.orderConfirmMode.orderCategory = @"mallOrder";
                
                [orderView setOrderConfirmMode:self.orderConfirmMode];
            }
            else{
                
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
        }];
        [SVProgressHUD show];
    }
    else{
        JHGoodsOrderDetailReqModel * mode =[[JHGoodsOrderDetailReqModel alloc]init];
        mode.goodsId=self.goodsId;
        mode.orderType=@(self.orderType).stringValue;
        mode.orderCategory=self.orderCategory;
        mode.goodsCount=goodsCount;
        mode.source=self.source;
        
        [JHOrderViewModel requestGoodsConfirmDetail:mode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                self.orderConfirmMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                //  self.orderConfirmMode.goodsCount=goodsCount;
                [orderView setOrderConfirmMode:self.orderConfirmMode];
                [self requestIntention];
            }
            else{
                //            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
        }];
        [SVProgressHUD show];
    }
    
}
-(void)requestIntention{
    if (self.orderConfirmMode.orderCategoryType==JHOrderCategoryRestore||
        self.orderConfirmMode.orderCategoryType==JHOrderCategoryResaleOrder) {
        
        JHIntentionReqModel * mode=[[JHIntentionReqModel alloc]init];
        mode.goodsCode=self.goodsId;
        mode.orderId=self.orderId;
        [JHOrderViewModel requestOrderIntentionByOrderId:mode completion:^(RequestModel *respondObject, NSError *error) {
            JHStoneIntentionInfoModel * mode = [JHStoneIntentionInfoModel mj_objectWithKeyValues: respondObject.data];
            [orderView setIntentionMode:mode];
            
        } ];
    }
}
-(void)requestAddress{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/address/default") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        self.addressMode = [AdressMode  mj_objectWithKeyValues: respondObject.data];
        [orderView setAddressMode:self.addressMode];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}

-(void)Complete:(JHOrderConfirmReqModel*)reqMode{

    //判断用户是否被平台处罚
    [self cheakUserIsLimit:2 completion:^(BOOL isLimit) {
        if (isLimit) return;
    
        if(![orderView isSelectedProtocol]){
            [self.view makeToast:@"请阅读并勾选宝友集市交易协议" duration:1.0 position:CSToastPositionCenter];
            return;
        }

        [self reportGoPay:reqMode.needPayMoney?:@""];
        
        if (!self.addressMode.ID) {
            AddAdressViewController * vc=[AddAdressViewController new];
            vc.fromType=2;
            [self.navigationController pushViewController:vc animated:YES];
            // [self.view makeToast:@"请先添加收货地址" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        reqMode.addressId=self.addressMode.ID;
        
        if (self.activeConfirmOrder && self.orderId == nil){
            reqMode.onlyGoodsId=self.goodsId;
            reqMode.orderCategory=self.orderCategory;
            reqMode.orderType=@(self.orderType).stringValue;
            reqMode.source=self.source;
            reqMode.parentOrderId=self.parentOrderId;
            reqMode.showId=self.showId;
            NSLog(@"%@",[reqMode mj_keyValues]);
            [self ConfirmGoodsOrder:reqMode];
        }
        else{
            reqMode.orderId=self.orderConfirmMode.orderId;
            NSLog(@"%@",[reqMode mj_keyValues]);
    //        [self ConfirmOrder:reqMode];
            [self makeConfirmOrder : reqMode];
        }
        
    }];
}

///判断用户是否被平台处罚或IM拉黑
- (void)cheakUserIsLimit:(int)limitType completion:(void(^)(BOOL isLimit))completion{
    @weakify(self);
    [JHMarketHomeBusiness cheakUserIsLimit:limitType sellerId:0 completion:^(NSString * _Nullable reason, int level) {
        @strongify(self);
        BOOL isLimit;
        if (reason.length>0) {
            if (level == 1) {
//                NSMutableAttributedString *attStr = [self matchString:reason];
//                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andMutableDesc:attStr cancleBtnTitle:@"确定"];
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:reason cancleBtnTitle:@"确定"];
                [alert show];
            }else{
                [self.view makeToast:reason duration:1.0 position:CSToastPositionCenter];
            }
            isLimit = YES;
        }else{
            isLimit = NO;
        }
        if (completion) {
            completion(isLimit);
        }
    }];
}

- (NSMutableAttributedString *)matchString:(NSString *)string{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    //提取[]中字符串正则表达式
    NSString *regexStr = @"(?<=\\[)[^\\]]+";
    //提取正则
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *object in matches) {
        NSRange attRange = NSMakeRange(object.range.location-1, object.range.length+2);
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:HEXCOLOR(0xFE4200)
                             range:attRange];
        }
    return attributeStr;
}

- (void) makeConfirmOrder:(JHOrderConfirmReqModel*)reqMode {
    [SVProgressHUD show];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue: self.orderConfirmMode.orderId forKey:@"orderId"];
    [dict setValue: reqMode.addressId forKey:@"addressId"];
    [dict setValue: reqMode.bountyAmount forKey:@"bountyAmount"];
    [dict setValue: reqMode.orderDesc forKey:@"orderDesc"];
    
    [JHOrderViewModel mekeOrderC2cOrder:dict completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHOrderDetailMode *orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
            if ([orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
                JHNewPaySuccessViewController *success = [[JHNewPaySuccessViewController alloc]init];
                success.paymoney=orderMode.orderPrice;
                success.orderId=self.orderId;
                [self.navigationController pushViewController:success animated:YES];
            }
            else{
                JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                order.isMarket = YES;
                order.goodsId = self.goodsId;
                order.orderId=self.orderId;
                [self.navigationController pushViewController:order animated:YES];
            }
        }else {
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
}
-(void)ConfirmOrder:(JHOrderConfirmReqModel*)reqMode{
    [JHOrderViewModel ConfirmOrder:reqMode completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHOrderDetailMode *orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
            if (orderMode.isSkipBeforeOrderId) {
                JHOrderPayMaterialAlert *alert = [[JHOrderPayMaterialAlert alloc]init];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
                @weakify(self);
                
                alert.handle = ^{
                    @strongify(self);
                    
                    if ([orderMode.beforeOrderStatus isEqualToString:@"waitack"]) {
                        JHNewPaySuccessViewController *success = [[JHNewPaySuccessViewController alloc]init];
                        success.paymoney=orderMode.orderPrice;
                        success.orderId=self.orderId;
                        [self.navigationController pushViewController:success animated:YES];
                    }
                    else{
                        JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                        order.isMarket = YES;
                        order.goodsId = self.goodsId;
                        order.orderId=self.orderId;
                        [self.navigationController pushViewController:order animated:YES];
                    }
                };
            }
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
    [SVProgressHUD show];
}
-(void)ConfirmGoodsOrder:(JHOrderConfirmReqModel*)reqMode{
    
    if ([self.orderCategory isEqualToString:@"marketFixedOrder"]) {
        reqMode.onlyGoodsId = self.goodsId;
        [JHOrderViewModel buildOrderC2cOrder:reqMode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                JHOrderDetailMode *orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                if ([orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
                    JHNewPaySuccessViewController * success =[[JHNewPaySuccessViewController alloc]init];
                    success.paymoney=orderMode.orderPrice;
                    success.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:success animated:YES];
                }
                else{
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                    order.isMarket = YES;
                    order.goodsId = self.goodsId;
                    order.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:order animated:YES];
                }
            }
            else{
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
        }];
        
        [SVProgressHUD show];
        return;
    }
    
    if ([self.orderCategory isEqualToString:@"mallOrder"]){
        [JHOrderViewModel ConfirmNewStoreOrder:reqMode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                JHOrderDetailMode *orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                if ([orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
                    JHNewPaySuccessViewController * success =[[JHNewPaySuccessViewController alloc]init];
                    success.paymoney=orderMode.orderPrice;
                    success.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:success animated:YES];
                }
                else{
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                    order.isMarket = YES;
                    order.goodsId = self.goodsId;
                    order.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:order animated:YES];
                }
            }
            else{
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
        }];
        
        [SVProgressHUD show];
        
    }
    else{
        [JHOrderViewModel ConfirmGoodsOrder:reqMode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                JHOrderDetailMode *orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                if ([orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
                    JHNewPaySuccessViewController * success =[[JHNewPaySuccessViewController alloc]init];
                    success.paymoney=orderMode.orderPrice;
                    success.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:success animated:YES];
                }
                else{
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                    order.isMarket = YES;
                    order.goodsId = self.goodsId;
                    order.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:order animated:YES];
                }
            }
            else{
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
        }];
        
        [SVProgressHUD show];
        
    }
    
}


- (void)reCatuAction {
    
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/riskTtest.html");
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)requestRiskInfo{
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/user/risk") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JHRiskDataModel *model = [JHRiskDataModel mj_objectWithKeyValues:respondObject.data];
        if (model.is_over==1) {
            JH_WEAK(self)
            if (alert) {
                [alert removeFromSuperview];
                alert=nil;
            }
            alert=[[CommAlertView alloc]initWithTitle:@"风险评估" andDesc:@"您的原石订单已超额，需要风险评估才能进行下一步操作" cancleBtnTitle:@"稍后再说" sureBtnTitle:@"现在评估"];
            [self.view addSubview:alert];
            alert.handle = ^{
                JH_STRONG(self)
                [self  reCatuAction];
            };
            alert.cancleHandle = ^{
                JH_STRONG(self)
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
-(void)initContentView{
    orderView=[[JHOrderConfirmView alloc]initWithFrameForC2C:CGRectZero];
    orderView.delegate=self;
    
    orderView.activeConfirmOrder=self.activeConfirmOrder;
    [self.view addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
    }];
    JH_WEAK(self)
    orderView.goodsCountAction = ^(id obj) {
        JH_STRONG(self)
        NSNumber * number=(NSNumber*)obj;
        [self requestGoodsConfirmDetail:[number integerValue]];
    };
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 埋点
/// 提交页面埋点
- (void)reportPageView {
    NSDictionary *par = @{
        @"page_name" : @"提交订单页",
        @"commodity_id" : self.goodsId ?: @"",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 点击支付
- (void)reportGoPay : (NSString *)amount {
    NSMutableDictionary *par = [NSMutableDictionary new];
    [par setValue: @"提交订单页" forKey:@"page_position"];
    [par setValue: self.goodsId  ?: @"" forKey:@"commodity_id"];
    [par setValue: amount forKey:@"order_actual_amount"];
    [par setValue: self.orderConfirmMode.orderCategory forKey:@"order_category"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSubmitOrder"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end
