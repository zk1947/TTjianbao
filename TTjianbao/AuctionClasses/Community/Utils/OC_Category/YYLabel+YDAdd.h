//
//  YYLabel+YDAdd.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YYLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYLabel (YDAdd)

/*!
 * 创建YYLabel，默认异步展示
 * ignoreCommonProperties：NO
 */
+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)color;

+ (YYLabel *)labelWithFont:(UIFont *)font color:(UIColor *)color top:(CGFloat)top left:(CGFloat)left size:(CGSize)size alignment:(NSTextAlignment)alignment;

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)color asyncDisplay:(BOOL)async ignoreCommonProperties:(BOOL)ignore;

@end

NS_ASSUME_NONNULL_END
