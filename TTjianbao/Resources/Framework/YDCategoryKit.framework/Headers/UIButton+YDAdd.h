//
//  UIButton+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 2019/7/19.
//  Copyright © 2019 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YDAdd)

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color;

/*! 网络请求时开始转圈 */
- (void)startQueryAnimate;
/*! 网络请求完停止转圈 */
- (void)stopQueryAnimate;

@end

NS_ASSUME_NONNULL_END
