//
//  JHRecyclePublishButtonView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePublishButtonView.h"
#import "CommAlertView.h"
#import "JHRecyclePriceController.h"
#import "JHRecyclePriceListViewController.h"
#import "JHRecyclePublishedViewModel.h"
#import "MBProgressHUD.h"
#import "JHRecycleDetailViewController.h"
#import "JHRecyclePriceController.h"
#import "JHRecyclePriceListViewController.h"
#import "JHRecycleOrderDetailViewController.h"
@interface JHRecyclePublishButtonView()
/** 详情*/
@property (nonatomic, strong) UIButton *detailButton;
/** 下架*/
@property (nonatomic, strong) UIButton *offShelvesButton;
/** 确认*/
@property (nonatomic, strong) UIButton *dealButton;
/** 删除*/
@property (nonatomic, strong) UIButton *deleteButton;
/** 上架*/
@property (nonatomic, strong) UIButton *onSaleButton;
@end

@implementation JHRecyclePublishButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)setStatusType:(PublishedStatusType)statusType fromIndex:(NSInteger)fromIndex {
    _statusType = statusType;
    _fromIndex = fromIndex;
    if (fromIndex == 1) {
        [self.dealButton setTitle:@"查看报价" forState:UIControlStateNormal];
    }else {
        [self.dealButton setTitle:@"确认报价" forState:UIControlStateNormal];
    }
    [self initializeConstraints];
    // 按钮通过数组传过去,顺序为逆序显示的
    switch (statusType) {
        case PublishedStatusTypeNoPrice:  //无报价
            [self remakeConstraintsWithArray:fromIndex == 1 ? @[self.offShelvesButton] : @[self.offShelvesButton, self.detailButton]];
            break;
        case PublishedStatusTypeHavePrice:  //有报价
            [self remakeConstraintsWithArray:@[self.dealButton, self.offShelvesButton]];
            break;
        case PublishedStatusTypeFailure:  //失效
            [self remakeConstraintsWithArray:@[self.onSaleButton, self.deleteButton]];
            break;
        case PublishedStatusTypeRefused:  //被平台拒绝
            [self remakeConstraintsWithArray:@[self.deleteButton]];
            break;
            
        default:
            break;
    }
    
}

// 重新定义button的约束,使该显示的显示 该隐藏的隐藏
- (void)remakeConstraintsWithArray:(NSArray <UIButton *>*)buttonsArray {
    UIButton *lastButton;
    for (int i = 0; i < buttonsArray.count; i++) {
        UIButton *button = buttonsArray[i];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(84);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            if (i == 0) {
                make.right.mas_equalTo(self);
            }else {
                make.right.mas_equalTo(lastButton.mas_left).offset(-10);
            }
        }];
        lastButton = button;
    }
}
// 按钮点击事件
- (void)buttonClickAction:(UIButton *)sender {
    if (self.clickActionBlock) {
        self.clickActionBlock(sender.tag);
    }
    switch (sender.tag) {
        case PublishButtonTagDetail:
        {
            JHRecycleDetailViewController *detailVc = [[JHRecycleDetailViewController alloc] init];
            detailVc.productId = self.productId;
            detailVc.identityType = 2;
            [self.viewController.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case PublishButtonTagOffShelves:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"commodity_id"] = self.productId;
            params[@"operation_type"] = @"off";
            if (self.fromIndex == 1) {
                params[@"page_position"] = @"recyclingDetails";
            }else{
                params[@"page_position"] = @"myPublished";
            }
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickShelf" params:params type:JHStatisticsTypeSensors];
            
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"下架商品,视为放弃回收报价,请您再次确认" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self offShelvesRequest:YES];
            };
        }
            break;
        case PublishButtonTagDeal:
            if (self.fromIndex == 1) { //详情页来的
                JHRecyclePriceListViewController *priceListView = [[JHRecyclePriceListViewController alloc] init];
                priceListView.productId = self.productId;
                priceListView.fromPageIsDismiss = YES;
                @weakify(self);
                priceListView.completePriceBlock = ^{
                    @strongify(self);
                    if (self.refreshUIBlock) {
                        self.refreshUIBlock();
                    }
                };
                [self.viewController.navigationController pushViewController:priceListView animated:YES];
            } else {
                NSString *desc = [NSString stringWithFormat:@"您确认接受(%@)的宝贝报价:¥%@", self.bidModel.shopName, self.bidModel.bidPriceYuan];
                CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
                @weakify(self);
                alert.handle = ^{
                    @strongify(self);
                    [self dealRequest];
                };
            }
            break;
        case PublishButtonTagDelete:
        {
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"确认要删除吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self deleteRequest];
            };
        }
            break;
        case PublishButtonTagOnSale:
        {
            [self offShelvesRequest:NO];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"commodity_id"] = self.productId;
            params[@"operation_type"] = @"again";
            if (self.fromIndex == 1) {
                params[@"page_position"] = @"recyclingDetails";
            }else{
                params[@"page_position"] = @"myPublished";
            }
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickShelf" params:params type:JHStatisticsTypeSensors];
        }
            break;
            
        default:
            break;
    }
}

#pragma 数据请求交互
// 商品下架/上架
- (void)offShelvesRequest:(BOOL)offSale {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operateType"] = offSale ? @"1" : @"0";
    params[@"productId"] = self.productId;
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecyclePublishedViewModel onOrOffSalePublishedRequest:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        if (!error) {
            [JHNotificationCenter postNotificationName:@"RecycleGoodsNumChangeNotification" object:offSale? @"0" : @"1"];

            JHTOAST(offSale ? @"下架成功" : @"上架成功");
            if (self.refreshUIBlock) {
                self.refreshUIBlock();
            }
        } else {
            JHTOAST(error.userInfo[@"NSLocalizedDescription"]);
        }
    }];
}
// 删除
- (void)deleteRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = self.productId;
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecyclePublishedViewModel deletePublishedRequest:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        if (!error) {
            JHTOAST(@"删除成功");
            if (self.refreshUIBlock) {
                self.refreshUIBlock();
            }
            if (self.fromIndex == 1) { //详情页的删除 需要返回到上级
                [self.viewController.navigationController popViewControllerAnimated:YES];
            }
        } else {
            JHTOAST(error.userInfo[@"NSLocalizedDescription"]);
        }
    }];
}
// 确认报价
- (void)dealRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bidId"] = self.bidModel.bidId;
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecyclePublishedViewModel confirmPrice:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        if (!error) {
            if (self.refreshUIBlock) {
                self.refreshUIBlock();
            }
            [JHNotificationCenter postNotificationName:@"RecycleGoodsNumChangeNotification" object:@"0"];

            JHRecycleOrderDetailViewController *orderDetailView = [[JHRecycleOrderDetailViewController alloc] init];
            orderDetailView.orderId = data[@"orderId"];
            [JHRootController.navigationController pushViewController:orderDetailView animated:YES];
            
            NSMutableDictionary *paramsUp = [NSMutableDictionary dictionary];
            paramsUp[@"commodity_id"] = self.publishModel.productId;
            paramsUp[@"recycler_id"] = self.bidModel.businessId;
            paramsUp[@"page_position"] = @"myPublished";
            paramsUp[@"recovery_quoted_price"] = @([self.bidModel.bidPriceYuan floatValue]);
            paramsUp[@"remaining_time"] = @(self.publishModel.timeDuring*1000);
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickConfirmPrice" params:paramsUp type:JHStatisticsTypeSensors];
            
        } else {
            JHTOAST(error.userInfo[@"NSLocalizedDescription"]);
        }
    }];
}

- (void)configUI {
    [self addSubview:self.dealButton];
    [self addSubview:self.detailButton];
    [self addSubview:self.deleteButton];
    [self addSubview:self.onSaleButton];
    [self addSubview:self.offShelvesButton];
    
    for (UIButton *button in @[self.dealButton, self.detailButton, self.deleteButton, self.onSaleButton, self.offShelvesButton]) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];
    }
}

//初始化约束,设置宽度为0,按钮全部隐藏
- (void)initializeConstraints {
    
    for (UIButton *button in @[self.dealButton, self.detailButton, self.deleteButton, self.onSaleButton, self.offShelvesButton]) {
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (UIButton *)dealButton {
    if (_dealButton == nil) {
        _dealButton = [self getButtonWithColor:YES name:@"确认报价" tag:PublishButtonTagDeal];
    }
    return _dealButton;
}
- (UIButton *)detailButton {
    if (_detailButton == nil) {
        _detailButton = [self getButtonWithColor:NO name:@"查看详情" tag:PublishButtonTagDetail];
    }
    return _detailButton;
}
- (UIButton *)onSaleButton {
    if (_onSaleButton == nil) {
        _onSaleButton = [self getButtonWithColor:YES name:@"重新上架" tag:PublishButtonTagOnSale];
    }
    return _onSaleButton;
}
- (UIButton *)offShelvesButton {
    if (_offShelvesButton == nil) {
        _offShelvesButton = [self getButtonWithColor:NO name:@"商品下架" tag:PublishButtonTagOffShelves];
    }
    return _offShelvesButton;
}
- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [self getButtonWithColor:NO name:@"删除" tag:PublishButtonTagDelete];
    }
    return _deleteButton;
}
// 初始化按钮
- (UIButton *)getButtonWithColor:(BOOL )backColor name:(NSString *)name tag:(PublishButtonTag )tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.layer.cornerRadius = 15;
    button.clipsToBounds = YES;
    if (backColor) { //需要填充按钮颜色
        button.backgroundColor = HEXCOLOR(0xffd70f);
    }else {
        button.layer.borderColor = HEXCOLOR(0xbdbfc2).CGColor;
        button.layer.borderWidth = 0.5;
    }
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end
