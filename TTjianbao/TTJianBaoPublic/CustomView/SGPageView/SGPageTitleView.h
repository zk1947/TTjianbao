//
//  SGPageTitleView.h
//  TTjianbao
//
//  Created by YJ on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import <UIKit/UIKit.h>

@class SGPageTitleView;

typedef enum : NSUInteger
{
    SGIndicatorTypeDefault, //指示器默认长度与按钮宽度相等
    SGIndicatorTypeEqual, //指示器宽度等于按钮文字宽度
} SGIndicatorType;

@protocol SGPageTitleViewDelegate <NSObject>

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex;

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView repeatClickIndex:(NSInteger)index;

@end

@interface SGPageTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate channelModels:(NSArray *)models;

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate channelModels:(NSArray *)models;


//指示器
@property (nonatomic, strong) UIView *indicatorView;

/** 普通状态标题文字颜色，默认黑色 */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中状态标题文字颜色，默认红色 */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器颜色，默认红色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 选中的按钮下标, 如果这个属性和 indicatorStyle 属性同时存在，则此属性在前 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 指示器样式 */
@property (nonatomic, assign) SGIndicatorType indicatorStyle;
/** 是否让标题有渐变效果，默认为 YES */
@property (nonatomic, assign) BOOL isTitleGradientEffect;
/** 是否让指示器滚动，默认为跟随内容的滚动而滚动 */
@property (nonatomic, assign) BOOL isIndicatorScroll;
/** 是否显示指示器，默认为 YES */
@property (nonatomic, assign) BOOL isShowIndicator;
/** 是否需要弹性效果，默认为 YES */
@property (nonatomic, assign) BOOL isNeedBounces;

/** 给外界提供的方法，获取 SGContentView 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

@end
