//
//  JHReLayoutButton.h
//  TTjianbao
//
//  Created by user on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 IB_DESIGNABLE 动态刷新类
 IBInspectable 可视化属性
 */

typedef NS_ENUM(NSInteger,RelayoutType) {
    /// 系统默认样式
    RelayoutTypeNone = 0,
    /// 上图下文
    RelayoutTypeUpDown = 1,
    /// 左文右图
    RelayoutTypeRightLeft = 2,
};

IB_DESIGNABLE

@interface JHReLayoutButton : UIButton

/** 布局样式*/
@property (assign,nonatomic) IBInspectable NSInteger  layoutType;
@property (assign,nonatomic) IBInspectable CGFloat  margin;

@end

NS_ASSUME_NONNULL_END
