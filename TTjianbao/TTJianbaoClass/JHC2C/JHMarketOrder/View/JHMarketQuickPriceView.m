//
//  JHMarketQuickPriceView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketQuickPriceView.h"
#import "JHMarketOrderViewModel.h"
#import "UIView+JHGradient.h"
#import "IQKeyboardManager.h"


static NSInteger const LimitNum = 6;

@interface JHMarketQuickPriceView()<UITextFieldDelegate>
/** backView*/
@property (nonatomic, strong) UIView *backView;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton *closeButton;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 现价*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 现价值*/
@property (nonatomic, strong) UILabel *priceValueLabel;
/** 调价后*/
@property (nonatomic, strong) UILabel *nowPriceLabel;
/** 调价后输入框*/
@property (nonatomic, strong) UITextField *nowPriceTextField;
/** 下划线*/
@property (nonatomic, strong) UIView *lineView;
/** 打折View*/
@property (nonatomic, strong) UIView *discountView;
/** 确定按钮*/
@property (nonatomic, strong) UIButton *ensureButton;
/** 选中的按钮*/
@property (nonatomic, strong) UIButton *selectButton;
@end
@implementation JHMarketQuickPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        [self configUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *rectValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [rectValue CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-keyboardSize.height + (self.backView.height - self.lineView.bottom));
        }];
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)buttonClickAction:(UIButton *)sender {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = self.productId;
    params[@"productPrice"] = [self.nowPriceTextField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    [JHMarketOrderViewModel updateProductPrice:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"价格修改成功");
            if (self.completeBlock) {
                self.completeBlock();
            }
            [self close];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (void)textFiledDidChange:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.text = @"¥";
    }
    
    // 1. 去空格
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 2. 保证输入数字的有效性
    if ( textField.text.length > 0 ) {
        // 1. 防止输入多个小数点
        if ( [textField.text componentsSeparatedByString:@"."].count > 2 ) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
        // 2. 控制精度
        if ( [textField.text componentsSeparatedByString:@"."].count == 2 && [[textField.text componentsSeparatedByString:@"."] lastObject].length > 2 ) {
            
            NSString *firstString = [[textField.text componentsSeparatedByString:@"."] firstObject];
            NSString *lastString = [[textField.text componentsSeparatedByString:@"."] lastObject];
            textField.text = [NSString stringWithFormat:@"%@.%@", firstString, [lastString substringToIndex:2]];
        }
        // 3.如果第一位是0则后面必须输入点，否则不能输入
        if ([textField.text hasPrefix:@"0"] && textField.text.length > 1) {
             NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
             if (![secondStr isEqualToString:@"."]) {
                 textField.text = [textField.text substringToIndex:textField.text.length - 1];
             }
         }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger textLength = textField.attributedText.string.length;
    if (textLength > LimitNum && string.length > range.length) {
        return NO;
    }
    
    return YES;
}

- (void)setOriPrice:(NSString *)oriPrice {
    _oriPrice = oriPrice;
    self.priceValueLabel.text = [NSString stringWithFormat:@"¥%@", oriPrice];
}

- (void)configUI {
    [self addSubview:self.backView];
    [self.backView addSubview:self.closeButton];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.priceValueLabel];
    [self.backView addSubview:self.nowPriceLabel];
    [self.backView addSubview:self.nowPriceTextField];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.discountView];
    [self.backView addSubview:self.ensureButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenW, 334 + UI.bottomSafeAreaHeight));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(13);
        make.centerX.mas_equalTo(self.backView);
        make.height.mas_equalTo(24);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(20);
        make.right.equalTo(self.backView).offset(-10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(28);
        make.left.equalTo(self.backView).offset(15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
    [self.priceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right);
        make.right.mas_equalTo(self.backView).offset(-15);
    }];
    
    [self.nowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(30);
        make.left.equalTo(self.backView).offset(15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
    [self.nowPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nowPriceLabel);
        make.left.equalTo(self.nowPriceLabel.mas_right);
        make.right.mas_equalTo(self.backView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nowPriceLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.height.mas_equalTo(1);
    }];
    
    [self.discountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(17);
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.height.mas_equalTo(86);
    }];
    
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.discountView.mas_bottom).offset(20);
        make.centerX.equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(150, 44));
    }];
}

- (void)discountButtonClickAction:(UIButton *)sender {
    self.selectButton.selected = NO;
    self.selectButton = sender;
    self.selectButton.selected = YES;
    
    double count = [sender.titleLabel.text stringByReplacingOccurrencesOfString:@"折" withString:@""].doubleValue;
    self.nowPriceTextField.text = [NSString stringWithFormat:@"¥%.2f", count / 10.0 * self.oriPrice.doubleValue];
}

- (void)close {
    [self removeFromSuperview];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"c2c_class_alert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:17];
        _titleLabel.text = @"快速调价";
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _priceLabel.text = @"现价";
    }
    return _priceLabel;
}

- (UILabel *)priceValueLabel {
    if (_priceValueLabel == nil) {
        _priceValueLabel = [[UILabel alloc] init];
        _priceValueLabel.textColor = HEXCOLOR(0x333333);
        _priceValueLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _priceValueLabel.text = @"¥0";
    }
    return _priceValueLabel;
}

- (UILabel *)nowPriceLabel {
    if (_nowPriceLabel == nil) {
        _nowPriceLabel = [[UILabel alloc] init];
        _nowPriceLabel.textColor = HEXCOLOR(0x333333);
        _nowPriceLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _nowPriceLabel.text = @"调价后";
    }
    return _nowPriceLabel;
}

- (UITextField *)nowPriceTextField {
    if (_nowPriceTextField == nil) {
        _nowPriceTextField = [[UITextField alloc] init];
        _nowPriceTextField.delegate = self;
        _nowPriceTextField.borderStyle = UITextBorderStyleNone;
        _nowPriceTextField.text = @"¥";
        _nowPriceTextField.textColor = HEXCOLOR(0x333333);
        _nowPriceTextField.font = [UIFont fontWithName:kFontNormal size:14];
        [_nowPriceTextField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
        _nowPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _nowPriceTextField;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xe6e6e6);
    }
    return _lineView;
}

- (UIView *)discountView {
    if (_discountView == nil) {
        _discountView = [[UIView alloc] init];
        
        CGFloat margin = 10;
        CGFloat width = (kScreenWidth - 30 - margin * 2) / 3;
        NSArray *array = @[@(9), @(8), @(7), @(6), @(5), @(4)];
        for (int i = 0; i < array.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[NSString stringWithFormat:@"%@折", array[i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
            [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xf5f5f5)] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xfcec9d)] forState:UIControlStateSelected];
            button.frame = CGRectMake(i % 3 * (width + margin), i / 3 * (margin + 38), width, 38);
            button.layer.cornerRadius = 4;
            button.clipsToBounds = YES;
            button.adjustsImageWhenHighlighted = NO;
            [button addTarget:self action:@selector(discountButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_discountView addSubview:button];
        }
    }
    return _discountView;
}

- (UIButton *)ensureButton {
    if (_ensureButton == nil) {
        _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
        _ensureButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_ensureButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _ensureButton.layer.cornerRadius = 22;
        _ensureButton.clipsToBounds = YES;
        [_ensureButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_ensureButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureButton;
}


@end
