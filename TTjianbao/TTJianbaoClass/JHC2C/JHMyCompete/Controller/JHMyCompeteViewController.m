//
//  JHMyCompeteViewController.m
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteViewController.h"
#import "JHMyCompeteMainView.h"
//#import "JHPlayerViewController.h"
#import "JHMyCompeteDelegate.h"
#import "JHMyCompeteCollectionViewCell.h"
#import "JHMyCompeteModel.h"
#import "JHC2CProductDetailController.h"
#import "JHMarketOrderViewModel.h"
#import "JHAuctionOrderDetailViewController.h"
#import "JHOrderPayViewController.h"
#import "JHStoreDetailViewController.h"

@interface JHMyCompeteViewController ()<
JHMyCompeteDelegate
>

/// 容器View
@property (nonatomic, weak) JHMyCompeteMainView *mainView;

//@property (nonatomic, strong) JHPlayerViewController *playerController;

@end

@implementation JHMyCompeteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhTitleLabel.text = @"我的参拍";
    self.jhNavBottomLine.hidden = NO;
    
    [self p_drawMainView];
    [self p_makeLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *logParams = @{JHLogCAppPage_pageName:@"集市我的参拍页"};
    [JHAllStatistics jh_allStatisticsWithEventId:JHLogCAppPage_eventId
                                          params: logParams
                                            type:JHStatisticsTypeSensors];
}

#pragma mark - Private Methods
- (void)p_drawMainView {
    JHMyCompeteMainView *competeMainView = [[JHMyCompeteMainView alloc]init];
    competeMainView.myVc = self;
    [competeMainView setDelegate:self];
    @weakify(self);
    competeMainView.buttonActionBlock = ^(JHMyAuctionListItemModel * _Nonnull model, BOOL isPay) {
        @strongify(self);
//        if (isPay) {
//            [self getOrderDetail:model];
//        }else{
            
            if (model.sellerType == 0) {
                JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
                detailVC.productId = [NSString stringWithFormat:@"%ld",model.productId];
                detailVC.fromPage = @"";
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                JHC2CProductDetailController *detailVC = [[JHC2CProductDetailController alloc] init];
                detailVC.productId = [NSString stringWithFormat:@"%ld",model.productId];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            
//        }
    };
    [self.view addSubview:competeMainView];
    self.mainView = competeMainView;
}

- (void)p_makeLayout {
    
    @weakify(self);
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
            
    }];
    
}

#pragma mark -- 获取订单详情
- (void)getOrderDetail:(JHMyCompeteModel *)model{
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = model.orderId;
    [JHMarketOrderViewModel orderDetail:params isBuyer:true Completion:^(NSError * _Nullable error, JHMarketOrderModel * _Nullable orderModel) {
        [SVProgressHUD dismiss];
        if (!error) {
            if (orderModel.orderStatus.integerValue == 1) {
                [self pushOrderConfirm:model];
            }else if (orderModel.orderStatus.integerValue == 2){
                [self pushOrderPay:model];
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}
- (void)pushOrderConfirm:(JHMyCompeteModel *)model{
    JHAuctionOrderDetailViewController * order=[[JHAuctionOrderDetailViewController alloc]init];
    order.orderId= model.orderId;
    order.orderCategory = @"marketAuctionOrder";
    [self.navigationController pushViewController:order animated:YES];
}
- (void)pushOrderPay:(JHMyCompeteModel *)model{
    //下面是支付页面
    JHOrderPayViewController *order =[[JHOrderPayViewController alloc]init];
    order.orderId=model.orderId;
    order.goodsId = [NSString stringWithFormat:@"%ld",model.productId];
    order.isMarket = YES;
    [self.navigationController pushViewController:order animated:YES];
}



#pragma mark - JHMyCompeteDelegate


//- (void)playMyCompeteVideo:(UIView *)superView
//                  videoUrl:(NSString *)videoUrl {
//    self.playerController.view.frame = superView.bounds;
//    [self.playerController setSubviewsFrame];
//    [superView addSubview:self.playerController.view];
//    self.playerController.urlString = videoUrl;
//}
//
//- (void)stopMyCompeteVideo {
//    //没有满足条件的 释放视频
//    [self.playerController stop];
//    [self.playerController.view removeFromSuperview];
//}

- (void)jumpGoodsDetailsWith:(JHMyAuctionListItemModel *)model{
    if (model.sellerType == 0) {
        JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
        detailVC.productId = [NSString stringWithFormat:@"%ld",model.productId];
        detailVC.fromPage = @"";
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        JHC2CProductDetailController *detailVC = [[JHC2CProductDetailController alloc] init];
        detailVC.productId = [NSString stringWithFormat:@"%ld",model.productId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    //上报
    NSDictionary *dic = @{
        @"commodity_id":[NSString stringWithFormat:@"%ld",model.productId],
        @"commodity_name":model.productName,
        @"model_type":@"我的参拍",
        @"page_position":@"我的参拍页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:dic type:JHStatisticsTypeSensors];
}

#pragma mark - set/get
//- (JHPlayerViewController *)playerController {
//    if (_playerController == nil) {
//        _playerController = [[JHPlayerViewController alloc] init];
//        _playerController.muted = YES;
//        _playerController.looping = YES;
//        _playerController.hidePlayButton = YES;
//        [self addChildViewController:_playerController];
//    }
//    return _playerController;
//}

@end
