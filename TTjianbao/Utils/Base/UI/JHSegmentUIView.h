//
//  JHSegmentUIView.h
//  TTjianbao
//  Description:可定制segment、tab
//  Created by Jesse on 2019/11/25.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

#define kTabSideMargin  20

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHSegmentType) {
    JHSegmentTypeDefault,
    JHSegmentTypeUnderline = JHSegmentTypeDefault, //下划线
    JHSegmentTypeCornerButton, //带背景色的圆角按钮
};

typedef NS_ENUM(NSUInteger, JHSegmentThemeType) {
    JHSegmentThemeTypeDefault, //默认主题
    JHSegmentThemeTypeClearColor,  //半透明主题:用户回血直播间使用
};

@protocol JHSegmentUIViewDelegate <NSObject>

- (void)pressSegmentButtonIndex:(NSUInteger)index;

@end

@interface JHSegmentUIView : UIScrollView

@property (nonatomic, weak) id<JHSegmentUIViewDelegate>sDelegate;
/**
 * begin: 可以动态配置,在setSegmentTitle之前使用
 */
@property (nonatomic, assign) BOOL indicateAutoWidth; //是否锁定宽度
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat tabSideMargin; //开头/结尾边距
@property (nonatomic, assign) CGFloat tabIntervalSpace; //tab间距
@property (nonatomic, assign) NSUInteger normalColor;
@property (nonatomic, assign) NSUInteger selectedColor;
@property (nonatomic, assign) NSUInteger btnNormalColor;
@property (nonatomic, assign) NSUInteger btnSelectedColor;
/**
* end: 可以动态配置
*/

- (instancetype)initWithType:(JHSegmentType)type;
//设置主题色
- (void)setSegmentThemeType:(JHSegmentThemeType)type;
/**第N个tab右上方显示红点+数字*/
- (void)setRedDotNum:(NSUInteger)num withIndex:(NSUInteger)index;
- (void)setSegmentTitle:(NSArray*)titles;
- (void)setSegmentIndicateImage:(NSString*)imageStr;
- (void)setSegmentViewShadow; //阴影
- (void)setSegmentViewShadowOffset:(CGSize)offset;
- (void)setSegmentIndicateImageWithTopOffset:(CGFloat)yOffset; //可以更改下划线坐标
- (UIButton*)tabButtonWithIndex:(NSUInteger)index; //获取指定的segmentTab 对应的Buttons
- (void)setSegmentIndicateImage:(NSString*)imageStr topOffset:(CGFloat)yOffset; //可以更改下划线坐标和图片
@end

NS_ASSUME_NONNULL_END
