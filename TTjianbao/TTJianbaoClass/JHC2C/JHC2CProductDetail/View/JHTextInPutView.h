//
//  JHTextInPutView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHTextInPutView : UIView

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


- (JHTextInPutView *)initInputTextViewWithFontSize:(UIFont *)font
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
