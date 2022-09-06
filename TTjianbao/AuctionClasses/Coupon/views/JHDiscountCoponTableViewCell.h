//
//  JHDiscountCoponTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/2/5.
//  Copyright © 2020年 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoponPackageMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHDiscountCoponTableViewCell : UITableViewCell
@property (nonatomic, copy) CoponMode *mode;
@property (nonatomic, copy) JHActionBlock buttonClick;
@property (nonatomic, assign) BOOL isOrderCoupon;
@end

NS_ASSUME_NONNULL_END
