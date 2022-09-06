//
//  YYLabel+YDAdd.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YYLabel+YDAdd.h"

@implementation YYLabel (YDAdd)

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)color {
    return [YYLabel labelWithFont:font textColor:color asyncDisplay:YES ignoreCommonProperties:NO];
}

+ (YYLabel *)labelWithFont:(UIFont *)font color:(UIColor *)color top:(CGFloat)top left:(CGFloat)left size:(CGSize)size alignment:(NSTextAlignment)alignment {
    YYLabel *label = [YYLabel labelWithFont:font textColor:color asyncDisplay:YES ignoreCommonProperties:NO];
    label.top = top;
    label.left = left;
    label.size = size;
    label.textAlignment = alignment;
    return label;
}

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)color asyncDisplay:(BOOL)async ignoreCommonProperties:(BOOL)ignore {
    YYLabel *label = [YYLabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = color;
    label.displaysAsynchronously = async; //开启异步绘制
    //label.ignoreCommonProperties = ignore; //忽略除了 textLayout 之外的其他属性
    label.fadeOnHighlight = NO;
    label.fadeOnAsynchronouslyDisplay = NO;
    //label.userInteractionEnabled = NO;
    label.exclusiveTouch = YES;
    return label;
}

@end
