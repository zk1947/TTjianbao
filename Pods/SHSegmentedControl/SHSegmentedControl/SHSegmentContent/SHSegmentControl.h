//
//   SHSegmentControl.h
//   SHSegmentedControlTableView
//
//   Created by angle on 2017/10/10.
//   Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h>

#import "UIView+Extension.h"
#import "UIColor+Hex.h"
#import "UIFont+PingFang.h"

typedef enum : NSUInteger {
    /** 默认状态 */
    SHSegmentControlTypeNone,
    /** 涌入放大效果 */
    SHSegmentControlTypeWater,
    /** 右上角小标题 */
    SHSegmentControlTypeSubTitle,
    /** 涌入放大效果+右上角小标题 */
    SHSegmentControlTypeWaterSubTitle,
} SHSegmentControlType;

typedef enum : NSUInteger {
    /** 默认状态 平均分布 呈分散状*/
    SHSegmentControlStyleScatter,
    /** 紧靠屏幕左侧 */
    SHSegmentControlStyleLeft,
    /** 紧挨且居中分布 */
    SHSegmentControlStyleCenter,
    /** 紧靠屏幕右侧 */
    SHSegmentControlStyleRight,
} SHSegmentControlStyle;

@interface SHSegmentControl : UIView
/** 间距 */
@property (nonatomic, assign) CGFloat titleMargin;
/** 默认字体大小 (默认15) */
@property (nonatomic, strong) UIFont  * _Nonnull titleNormalFont;
/** 选中字体大小 (默认15) */
@property (nonatomic, strong) UIFont  * _Nonnull titleSelectFont;
/** 小标题字体大小 */
@property (nonatomic, strong) UIFont  * _Nonnull subTitleFont;
/** 标题偏移量 */
@property (nonatomic, assign) CGFloat offsetX;
/** 字体默认颜色 */
@property (nonatomic, strong) UIColor * _Nonnull titleNormalColor;
/** 小标题默认字体颜色 */
@property (nonatomic, strong) UIColor * _Nonnull subTitleNormalColor;
/** 字体选中颜色 */
@property (nonatomic, strong) UIColor * _Nonnull titleSelectColor;
/** 小标题选中字体颜色 */
@property (nonatomic, strong) UIColor * _Nonnull subTitleSelectColor;
/** 指示器圆角 */
@property (nonatomic, assign) CGFloat progressCornerRadius;
/** 指示器高度（粗细） */
@property (nonatomic, assign) CGFloat progressHeight;
/** 指示器宽度（默认 title宽） */
@property (nonatomic, assign) CGFloat progressWidth;
/** 指示器底部距离（默认0） */
@property (nonatomic, assign) CGFloat progressBottom;
/** 指示器颜色 */
@property (nonatomic, strong) UIColor * _Nonnull progressColor;
/** 下底线颜色 */
@property (nonatomic, strong) UIColor * _Nonnull bottomLineColor;
/** 下底线高度（粗细） 默认0.5f) */
@property (nonatomic, assign) CGFloat bottomLineHeight;
/** 分栏类型 默认SHSegmentControlTypeNone */
@property (nonatomic, assign) SHSegmentControlType type;
/** 分栏分布类型 默认SHSegmentControlStyleScatter */
@property (nonatomic, assign) SHSegmentControlStyle style;
/** 每个 MenuItem 的宽度 */
@property (nonatomic, assign) CGFloat menuItemWidth;
/** 各个 MenuItem 的宽度，可不等，数组内为 NSNumber. */
@property (nonatomic, nullable, copy) NSArray<NSNumber *> *itemsWidths;
/** 放大效果的比例  默认1.2*/
@property (nonatomic, assign) CGFloat itemScale;

/** 获取当前下标 */
@property (nonatomic, assign, readonly) NSInteger selectIndex;
/** 分栏总数 */
@property (nonatomic, assign) NSInteger totalCount;

/** 背景颜色 */
@property (nonatomic, strong) UIColor * _Nonnull backgroundNormalColor;
/** 选中状态背景颜色 */
@property (nonatomic, strong) UIColor * _Nonnull backgroundSelectColor;


/** 分栏点击事件回调block */
@property (nonatomic, copy) void(^ _Nonnull curClick)(NSInteger index);

/** 分栏item 刷新回调 用于自定义设置小标题frame的block 仅限SHSegmentControlTypeSubTitle SHSegmentControlTypeWaterSubTitle 可用  设置block，必须在调用setItmesSubTitle方法之前*/
@property (nonatomic, copy) void(^ _Nonnull reloadSubTitleBlock)(UILabel * _Nullable titleLabel, UILabel * _Nullable subLabel);

/** 设置下标 */
- (void)setSegmentSelectedIndex:(NSInteger)index;

/**
 1.初始化的width，在没有被set为barView/topView前，会作为contentSize的width，可省略titleMargin的设置
 2.被set为barView/topView后，自身的width都会被重置为容器视图SHSegmentedControlTableView的width，而contentSize不再改变
 3.也可自行设置titleMargin，reloadViews一下即可更新contentSize的width，contentSize的width未超容器width时，平均布局
 */

/** 默认初始化方式 */
- (instancetype _Nonnull )initWithFrame:(CGRect)frame;
/** 带分栏信息---初始化 */
- (instancetype _Nonnull )initWithFrame:(CGRect)frame items:(NSArray<NSString *> *_Nonnull)items;


/** 重新设置分栏 */
- (void)restItmes:(NSArray<NSString *> *_Nonnull)items;
/** 设置分栏子标题 （个数和分栏数相同，没有给@""） */
- (void)setItmesSubTitle:(NSArray<NSString *> *_Nonnull)items;
/** 属性设置后，手动刷新，提高性能 */
- (void)reloadViews;

@end
