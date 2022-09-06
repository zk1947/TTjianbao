//
//  JHLine.h
//  TTjianbao
//  Description:1渐变线:默认横向 2虚实线:默认实线
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGradientView.h"

//默认横向渐变线
@interface JHGradientLine : JHGradientView

@end

//普通虚实线
@interface JHCustomLine : UIView

/** 颜色 */
@property (nonatomic, strong) UIColor *color;
/** 是否为实心线 */
@property (nonatomic, assign) BOOL isSolid;
/** 单截实线长度 */
@property (nonatomic, assign) CGFloat solidWidth;
/** 单截虚线长度 */
@property (nonatomic, assign) CGFloat dashWidth;

- (instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color;
- (instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color isSolid:(BOOL)isSolid;
/**
 *  初始化时没有设置frame，后续设置frame
 */
- (void)refreshFrame:(CGRect)frame;

@end


