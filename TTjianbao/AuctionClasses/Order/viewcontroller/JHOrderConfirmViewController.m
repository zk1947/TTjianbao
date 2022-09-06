//
//  JHOrderConfirmViewController.m
//  TTjianbao
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHOrderConfirmViewController.h"
#import "JHOrderConfirmView.h"
#import "AddAdressViewController.h"
#import "JHOrderPayViewController.h"
#import "JHPaySuccessViewController.h"
#import "JHWebViewController.h"
#import "BaseNavViewController.h"
#import "CommAlertView.h"
#import "TTjianbaoBussiness.h"
#import "JHOrderViewModel.h"
#import <IQKeyboardManager.h>
#import "JHOrderPayMaterialAlert.h"
@interface JHOrderConfirmViewController ()<JHOrderConfirmViewDelegate>
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

@implementation JHOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    //    [self initToolsBar];
    //     [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
    //    [self.navbar.comBtn addTarget :self action:@selector(backAction)  forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAddress) name:ADRESSALTERSUSSNotifaction object:nil];
    
   // self.orderCategory = @"mallOrder";
   // self.goodsId = @"8393";
    
    self.isMarketOrder = YES;
    
    [self  initContentView];
    [self requestAddress];
    if (self.activeConfirmOrder) {
        //        [self.navbar setTitle:@"提交订单"];
        self.title = @"提交订单";
        [self requestGoodsConfirmDetail:1];
    }
    else{
        //        [self.navbar setTitle:@"确认订单"];
        self.title = @"确认订单";
        [self requestOrderConfirmDetail];
    }
    NSMutableArray *arr=[self.navigationController.viewControllers mutableCopy];
    for ( UIViewController *vc in arr) {
        if ([vc isKindOfClass:[JHOrderConfirmViewController class]]&&vc != self) {
            [arr removeObject:vc];
            self.navigationController.viewControllers=arr;
            break;
        }
    }
    [JHGrowingIO trackEventId:JHTrackConfirmOrderEnter from:self.fromString];
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
-(void)initContentView{
    orderView=[[JHOrderConfirmView alloc]init];
   
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

-(void)requestOrderConfirmDetail{
    [SVProgressHUD show];
    [JHOrderViewModel requestOrderConfirmDetail:self.orderId completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            self.orderConfirmMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
            [orderView setOrderConfirmMode:self.orderConfirmMode];
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
-(void)requestGoodsConfirmDetail:(NSInteger)goodsCount{
    
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
                if (self.orderConfirmMode.tip.length) {
                    JHTOAST(self.orderConfirmMode.tip);
                }
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
        JHGoodsOrderDetailReqModel * mode = [[JHGoodsOrderDetailReqModel alloc]init];
        mode.goodsId                      = self.goodsId;
        mode.orderType                    = @(self.orderType).stringValue;
        mode.orderCategory                = self.orderCategory;
        mode.goodsCount                   = goodsCount;
        mode.source                       = self.source;
        mode.buyType                      = self.buyType;
        
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
    //    [JHGrowingIO trackOrderEventId:JHTrackconfirm_order_quzhifu orderCode:self.orderConfirmMode.orderCode payWay:@"" suc:@""];
    
//    [JHGrowingIO trackEventId:JHTrackconfirm_order_quzhifu variables:@{@"orderCode":self.orderConfirmMode.orderCode,@"channelType":@(self.orderConfirmMode.orderType),@"channelLocalId":self.orderConfirmMode.channelLocalId ? : @""}];
//
//    [JHUserStatistics noteEventType:kUPEventTypeOrderConfirmed params:@{}];

    NSDictionary * dic = @{@"commodity_id":self.goodsId?:@"",
                           @"commodity_name":self.orderConfirmMode.goodsTitle?:@"",
                           @"order_amount":reqMode.needPayMoney?:@"",
                           @"page_position":@"submitOrder"};
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSubmitOrder" params:dic type:JHStatisticsTypeSensors];
    
    if (isEmpty(self.addressMode.ID)) {
        AddAdressViewController * vc=[AddAdressViewController new];
        vc.fromType=2;
        [self.navigationController pushViewController:vc animated:YES];
        // [self.view makeToast:@"请先添加收货地址" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (isEmpty(reqMode.addressId)) {
        reqMode.addressId=self.addressMode.ID;
    }
    
    if (self.activeConfirmOrder){
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
        [self ConfirmOrder:reqMode];
    }
    
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
                        JHOrderConfirmViewController * order =[[JHOrderConfirmViewController alloc]init];
                        order.orderId=orderMode.beforeOrderId;
                        [self.navigationController pushViewController:order animated:YES];
                         
                    }
                    else{
                        JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                        order.orderId=orderMode.beforeOrderId;
                        [self.navigationController pushViewController:order animated:YES];
                    }
                };
                
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                if ([orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
                    JHPaySuccessViewController * success =[[JHPaySuccessViewController alloc]init];
                    success.paymoney=orderMode.orderPrice;
                    success.orderId=self.orderId;
                    [self.navigationController pushViewController:success animated:YES];
                }
                else{
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                    order.orderId=self.orderId;
                    order.directDelivery = orderMode.directDelivery;
                    [self.navigationController pushViewController:order animated:YES];
                }
            }
            
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
    [SVProgressHUD show];
}
-(void)ConfirmGoodsOrder:(JHOrderConfirmReqModel*)reqMode{
    
    if ([self.orderCategory isEqualToString:@"mallOrder"]){
        [JHOrderViewModel ConfirmNewStoreOrder:reqMode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                JHOrderDetailMode *orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                if ([orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
                    JHPaySuccessViewController * success =[[JHPaySuccessViewController alloc]init];
                    success.paymoney=orderMode.orderPrice;
                    success.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:success animated:YES];
                }
                else{
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
                    order.orderId=orderMode.orderId;
                    order.directDelivery = orderMode.directDelivery;
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
        reqMode.buyType = self.buyType;
        [JHOrderViewModel ConfirmGoodsOrder:reqMode completion:^(RequestModel *respondObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                JHOrderDetailMode *orderMode = [JHOrderDetailMode mj_objectWithKeyValues: respondObject.data];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                if ([orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
                    JHPaySuccessViewController * success =[[JHPaySuccessViewController alloc]init];
                    success.paymoney=orderMode.orderPrice;
                    success.orderId=orderMode.orderId;
                    [self.navigationController pushViewController:success animated:YES];
                }
                else{
                    JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
