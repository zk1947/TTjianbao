//
//  JHTopBottomLabelAndTFView.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^TFEditingChangedBlock)(NSString *text);
typedef void (^TFScanCodeClickBlock)(UIButton *btn);
typedef void (^TFTipClickBlock)(UIButton *btn);
typedef void (^TFVerificationCodeClickBlock)(UIButton *btn);
typedef Boolean (^TFTextFieldShouldReturnBlock)(UITextField *textField);
typedef void (^TFTextFieldDidEndEditingBlock)(UITextField *textField);
typedef Boolean (^TFTextFieldShouldChangeCharactersInRangeBlock)(UITextField *textField,NSRange range,NSString *string);

@interface JHTopBottomLabelAndTFView : BaseView
@property (nonatomic, assign) Boolean TFEnabled; /// TF是否可以点击，默认可以点击;
@property (nonatomic, assign) Boolean isShowLine; /// 是否要显示line, 1：显示,默认显示;
@property (nonatomic, assign) Boolean isCutDisplay; /// 是否要分割显示 默认不分割
@property (nonatomic, assign) Boolean isClickVerificationCodeBtn; /// 默认 0;
@property(nonatomic) UIKeyboardType keyboardType; /// 设置键盘弹出的类型
@property(nonatomic) UIReturnKeyType returnKeyType;  /// 设置键盘确认建，默认是next
@property(nonatomic, copy) TFEditingChangedBlock tfEditingChangedBlock;
@property(nonatomic, copy) TFScanCodeClickBlock tfScanCodeClickBlock;
@property(nonatomic, copy) TFTipClickBlock tfTipClickBlock;
@property(nonatomic, copy) TFVerificationCodeClickBlock tfVerificationCodeClickBlock;
@property(nonatomic, copy) TFTextFieldShouldReturnBlock textFieldShouldReturnBlock;
@property(nonatomic, copy) TFTextFieldDidEndEditingBlock textFieldDidEndEditingBlock;
@property(nonatomic, copy) TFTextFieldShouldChangeCharactersInRangeBlock textFieldShouldChangeCharactersInRangeBlock;

- (instancetype)initWithLabel:(NSString *)lbStr TFPlaceHolder:(NSString *)tfPlaceHoldStr TFText:(NSString *)tfStr;
- (NSString *)getTFText;
- (UITextField *)getTF;
- (void)setErrorTip:(NSString *)str;
- (void)errorLabelHidden:(Boolean)hidden;
- (void)displayScanCodeBtn;
- (void)displayIphoneNoTipBtn;
- (void)displayVerificationCodeBtn;
- (void)countDown:(UIButton *)btn;
 
@end

NS_ASSUME_NONNULL_END
