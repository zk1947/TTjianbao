//
//  JHMyCouponTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2019/3/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoponPackageMode.h"
typedef void (^JHIntroduceBlock)(int  cellIndex);
NS_ASSUME_NONNULL_BEGIN
@interface JHMyCouponTableViewCell : UITableViewCell
@property (nonatomic, copy) CoponMode *mode;
@property (nonatomic, assign) int cellIndex;
@property (nonatomic, copy) JHActionBlock buttonClick;
@property (nonatomic, copy) JHIntroduceBlock introduceClick;
@property (nonatomic, assign) BOOL isOrderCoupon;
@end

NS_ASSUME_NONNULL_END
