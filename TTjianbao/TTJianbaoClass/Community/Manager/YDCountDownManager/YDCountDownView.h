//
//  YDCountDownView.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/25.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  ❗️倒计时视图❗️
//

#import <UIKit/UIKit.h>
#import <SDAutoLayout/SDAutoLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDCountDownConfig : NSObject


#pragma mark - 标题属性
/** 标题-提示信息<还剩xxx> */
@property (nonatomic, copy) NSString *title;
/** 标题字体 */
@property (nonatomic, strong) UIFont *titleFont;
/** 标题字体颜色 */
@property (nonatomic, strong) UIColor *titleColor;

#pragma mark - 天数属性
/** 天数字体 */
@property (nonatomic, strong) UIFont *ddFont;
/** 天数字体颜色 */
@property (nonatomic, strong) UIColor *ddColor;
/** 天数背景色 */
@property (nonatomic, strong) UIColor *ddBgColor;

#pragma mark - 时分秒属性
/** 时分秒字体 */
@property (nonatomic, strong) UIFont *timeFont;
/** 时分秒字体颜色 */
@property (nonatomic, strong) UIColor *timeColor;
/** 时分秒色块背景色 */
@property (nonatomic, strong) UIColor *timeBgColor;

#pragma mark - 分隔符属性
/** 分隔符字体 */
@property (nonatomic, strong) UIFont *spFont;
/** 分隔符字体颜色 */
@property (nonatomic, strong) UIColor *spColor;

@end


@interface YDCountDownView : UIView

@property (nonatomic, strong) YDCountDownConfig *config;

+ (instancetype)countDownWithConfig:(YDCountDownConfig *)config endBlock:(dispatch_block_t)endBlock;

/** 设置倒计时时间，timeValue是未经转换的总秒数 */
- (void)setCountDownTime:(NSInteger)timeValue;

/** 单独设置天、时分秒 */
- (void)setDD:(NSInteger)ddValue hh:(NSInteger)hhValue mm:(NSInteger)mmValue ss:(NSInteger)ssValue;

/** 设置倒计时结束样式 */
- (void)showEndStyle;

@end

NS_ASSUME_NONNULL_END
