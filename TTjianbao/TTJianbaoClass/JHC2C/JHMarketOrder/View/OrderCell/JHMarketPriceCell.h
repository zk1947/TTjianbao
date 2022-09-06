//
//  JHMarketPriceCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHMarketOrderModel;
@interface JHMarketPriceCell : UITableViewCell
@property (nonatomic, strong) JHMarketOrderModel *model;
@end

NS_ASSUME_NONNULL_END
