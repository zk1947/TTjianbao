//
//  JHStoreDetailCouponViewController.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponViewController : UIViewController
@property (nonatomic, strong) NSDictionary *parameter;
/// 刷新上层页面-当关注、优惠券领取状态改变时触发。
@property (nonatomic, strong) RACSubject *refreshUpper;

@end

NS_ASSUME_NONNULL_END
