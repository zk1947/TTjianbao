//
//  CommAlertView.h
//  TTjianbao
//
//  Created by jiang on 2019/9/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef Boolean (^TFTextFieldShouldReturnBlock)(UITextField *textField);

@interface CommAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title  andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle  sureBtnTitle:(NSString *)completeTitle;
- (instancetype)initWithTitle:(NSString *)title  andMutableDesc:(NSMutableAttributedString *)mutableDesc  cancleBtnTitle:(NSString *)cancleTitle  sureBtnTitle:(NSString *)completeTitle andIsLines:(BOOL)isLines;
@property(strong,nonatomic)UIImageView *titleImage;
@property(strong,nonatomic)JHFinishBlock cancleHandle;
@property(strong,nonatomic)JHFinishBlock handle;
@property(nonatomic, copy) TFTextFieldShouldReturnBlock textFieldShouldReturnBlock;
//输入框键盘样式
@property (nonatomic, assign) UIKeyboardType tfKeyboardType;

- (instancetype)initWithTitle:(NSString *)title  andDesc:(NSString *)desc  cancleBtnTitle:(NSString *)cancleTitle;
- (instancetype)initWithTitle:(NSString *)title  andMutableDesc:(NSMutableAttributedString *)mdesc  cancleBtnTitle:(NSString *)cancleTitle;
- (void)addCloseBtn;
- (void)addBackGroundTap;
- (void)show;
-(void) setDesFont:(UIFont *)font;
- (void)displayTextFiledWithPlaceHoldStr:(NSString *)placeHoldStr;
- (NSString *)getTextFiledText;
-(void)setDescTextAlignment:(NSTextAlignment)align;

- (void)dealTitleToCenter;

@property(strong,nonatomic)JHFinishBlock closeBlock;//关闭埋点
@end

NS_ASSUME_NONNULL_END
