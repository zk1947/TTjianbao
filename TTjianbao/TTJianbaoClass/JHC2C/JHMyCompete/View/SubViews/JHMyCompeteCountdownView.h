//
//  JHMyCompeteCountdownView.h
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 倒计时视图
@interface JHMyCompeteCountdownView : UIView

///倒计时显示
@property (nonatomic, strong) UILabel *countdownLable;

/// 设置倒计时时间
/// @param deadline 时间
/// @param expString 提示语
/// @param completion
- (void)setTheCompeteCountdownView:(NSString *)deadline
                         expString:(NSString *)expString completion:(void (^ __nullable)(BOOL finished))completion;

- (void)setSecandData:(NSInteger)second expString:(NSString *)expString completion:(void (^ __nullable)(BOOL finished))completion;

- (void)dealTextAlent;

- (void)changeTextAttribute:(UIFont *)font color:(UIColor *)color bgColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
