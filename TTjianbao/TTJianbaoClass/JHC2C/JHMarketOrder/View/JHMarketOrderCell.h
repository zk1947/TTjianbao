//
//  JHMarketOrderCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHMarketOrderModel;
@interface JHMarketOrderCell : UITableViewCell
@property (nonatomic, strong) JHMarketOrderModel *model;
// 是否是买家
@property (nonatomic, assign) BOOL isBuyer;
/** 刷新单条数据*/
@property (nonatomic, copy) void(^reloadCellDataBlock)(BOOL iSdelete);
/** 点击了支付按钮*/
@property (nonatomic, copy) void(^payButtonClick)(void);
@end

NS_ASSUME_NONNULL_END
