//
//  JHOrderConfirmViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPaySuccessViewController.h"
#import "JHPaySuccessView.h"
#import "JHQYChatManage.h"
#import "PanNavigationController.h"
#import "JHOrderConfirmViewController.h"
#import "JHAuthorize.h"

@interface JHPaySuccessViewController ()
{
    JHPaySuccessView * orderView;
}

@property (nonatomic, strong) OrderMode *orderModel;
@end

@implementation JHPaySuccessViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.title = @"支付成功";
    [self.jhLeftButton removeFromSuperview];
    
    NSMutableArray *arr=[self.navigationController.viewControllers mutableCopy];
    for ( UIViewController *vc in arr) {
        if ([vc isKindOfClass:[JHOrderConfirmViewController class]]) {
            [arr removeObject:vc];
            self.navigationController.viewControllers=arr;
            break;
        }
    }
    [self  initContentView];
    [self requestInfo];
    [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypePaymentSuccess];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)requestInfo{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/detail?orderId=%@&userType=%@"),self.orderId,@"0"];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        OrderMode *orderMode = [OrderMode mj_objectWithKeyValues: respondObject.data];
        self.orderModel = orderMode;
        [orderView setMode:orderMode];
        
        [[JHQYChatManage shareInstance] sendTextWithViewcontroller:self ToShop:orderMode.sellerCustomerId title:orderMode.goodsTitle andOrderId:orderMode.orderId isPayFinish:YES];
        
        [self reportPageView];
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
            if ([nav isKindOfClass:[PanNavigationController class]]) {
                nav.isForbidDragBack = YES;
            }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
            if ([nav isKindOfClass:[PanNavigationController class]]) {
                nav.isForbidDragBack = NO;
                
    }
}
-(void)backActionButton:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initContentView{
    
    orderView=[[JHPaySuccessView alloc]init];
    [self.view addSubview:orderView];
    
    [orderView setPayMoney:_paymoney];
    
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        
    }];
}
#pragma mark - 埋点
/// 提交页面埋点
- (void)reportPageView {
    NSDictionary *par = @{
        @"page_name" : @"支付成功页",
        @"order_id" : self.orderId,
        @"commodity_id" : self.orderModel.onlyGoodsId,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end


