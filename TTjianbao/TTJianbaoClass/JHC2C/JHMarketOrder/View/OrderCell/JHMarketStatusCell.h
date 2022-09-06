//
//  JHMarketStatusCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHMarketOrderModel;
@interface JHMarketStatusCell : UITableViewCell
@property (nonatomic, strong) JHMarketOrderModel *model;
/** 状态文字*/
@property (nonatomic, strong) YYLabel *statusLabel;
/** 是否是买家*/
@property (nonatomic, assign) BOOL isBuyer;
@end

NS_ASSUME_NONNULL_END
