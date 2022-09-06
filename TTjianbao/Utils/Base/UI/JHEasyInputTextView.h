//
//  JHEasyInputTextView.h
//  JHEasyInputTextView
//
//  Created by lihui on 2020/11/13.
//
///键盘上的输入框 - 可选择图片 发送表情
typedef enum : NSUInteger {
    ActionClickEmoji,  // 表情点击
    ActionClickPicture,  //图片点击
} ActionClickType;

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHEasyInputTextView : UIView
// 回调事件,埋点用
@property (nonatomic, copy) void(^actionClickBlock)(ActionClickType type);
///占位文字
@property (nonatomic,   copy) NSString *placeholder;
///输入框背景色
@property (nonatomic, strong) UIColor *bgColor;
///文字大小
@property (nonatomic, strong) UIFont *font;
///显示字数
@property (nonatomic, assign) BOOL showLimitNum;
///限制字数的颜色
@property (nonatomic, strong) UIColor *limitNumColor;
///限制字数
@property (nonatomic, assign) NSInteger limitNum;
///最小行数 默认是1 == isDefault
@property (nonatomic, assign) NSInteger minNumbersOfLine;
///最大行数 默认是0
@property (nonatomic, assign) NSInteger maxNumbersOfLine;
///是否显示选择图片的按钮 默认显示
@property (nonatomic, assign) BOOL showSelectPicture;
///是否显示选择表情的按钮 默认显示
@property (nonatomic, assign) BOOL showSelectEmoj;
///当前控制器
@property (nonatomic, copy) NSString *currenViewController;


/// 1-评论
@property (nonatomic, assign) NSInteger type;


/// 初始化输入框
/// @param font font description
/// @param limitNum 字数限制
/// @param maxNumbersOfLine 最大行数 默认是1
+ (void)showInputTextViewWithFontSize:(UIFont *)font
                             limitNum:(NSInteger)limitNum
                 inputBackgroundColor:(UIColor *)inputBackgroundColor
                     maxNumbersOfLine:(NSInteger)maxNumbersOfLine
                currentViewController:(NSString *)currentViewController;


- (JHEasyInputTextView *)initInputTextViewWithFontSize:(UIFont *)font
                                              limitNum:(NSInteger)limitNum
                                  inputBackgroundColor:(UIColor *)inputBackgroundColor
                                      maxNumbersOfLine:(NSInteger)maxNumbersOfLine
                                 currentViewController:(NSString *)currentViewController;
///展示输入框
- (void)show;

///发布内容
- (void)toPublish:(void(^)(NSDictionary *inputInfos))publishBlock;

@end

NS_ASSUME_NONNULL_END
