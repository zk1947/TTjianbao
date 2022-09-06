//
//  JHMarketPriceAlert.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketPriceAlert.h"
#import "JHMarketOrderViewModel.h"

@interface JHMarketPriceAlert()
/** 提示View*/
@property (nonatomic, strong) UIView *backView;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton *closeButton;
/** 修改价格*/
@property (nonatomic, strong) UILabel *changeLabel;
/** 宝贝价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 价格输入框*/
@property (nonatomic, strong) UITextField *priceTextField;
/** 运费*/
@property (nonatomic, strong) UILabel *freightLabel;
/** 运费输入框*/
@property (nonatomic, strong) UITextField *freightTextField;
/** 提示文字*/
@property (nonatomic, strong) UILabel *alertLabel;
/** 修改按钮*/
@property (nonatomic, strong) UIButton *changeButton;
@end

@implementation JHMarketPriceAlert

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        [self configUI];
    }
    return self;
}
- (void)buttonClickAction:(UIButton *)sender {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderId;
    params[@"expressFee"] = [self.freightTextField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    params[@"orderPrice"] = [self.priceTextField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    [JHMarketOrderViewModel updatePrice:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"价格修改成功");
            if (self.successCompleteBlock) {
                self.successCompleteBlock();
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

- (void)setOriPrice:(NSString *)oriPrice {
    _oriPrice = oriPrice;
    self.priceTextField.text = [NSString stringWithFormat:@"¥%@", oriPrice];
}

- (void)setFrePrice:(NSString *)frePrice {
    _frePrice = frePrice;
    self.freightTextField.text = [NSString stringWithFormat:@"¥%@", frePrice];
}

- (void)configUI {
    [self addSubview:self.backView];
    [self.backView addSubview:self.closeButton];
    [self.backView addSubview:self.changeLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.priceTextField];
    [self.backView addSubview:self.freightLabel];
    [self.backView addSubview:self.freightTextField];
    [self.backView addSubview:self.alertLabel];
    [self.backView addSubview:self.changeButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(308, 261));
    }];
    
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(20);
        make.centerX.mas_equalTo(self.backView);
        make.height.mas_equalTo(20);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(20);
        make.right.equalTo(self.backView).offset(-10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.changeLabel.mas_bottom).offset(20);
        make.right.equalTo(self.backView).offset(-18);
        make.width.mas_equalTo(191);
        make.height.mas_equalTo(38);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceTextField);
        make.right.equalTo(self.priceTextField.mas_left).offset(-15);
    }];
    
    [self.freightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceTextField.mas_bottom).offset(10);
        make.right.equalTo(self.backView).offset(-18);
        make.width.mas_equalTo(191);
        make.height.mas_equalTo(38);
    }];
    
    [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.freightTextField);
        make.right.equalTo(self.freightTextField.mas_left).offset(-15);
    }];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.freightTextField.mas_bottom).offset(14);
        make.centerX.equalTo(self.backView);
        make.height.mas_equalTo(20);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.backView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
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

- (UILabel *)changeLabel {
    if (_changeLabel == nil) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.textColor = HEXCOLOR(0x333333);
        _changeLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _changeLabel.text = @"修改商品价格";
    }
    return _changeLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _priceLabel.text = @"宝贝价格:";
    }
    return _priceLabel;
}

- (UITextField *)priceTextField {
    if (_priceTextField == nil) {
        _priceTextField = [[UITextField alloc] init];
        _priceTextField.borderStyle = UITextBorderStyleRoundedRect;
        _priceTextField.text = @"¥30";
        _priceTextField.textColor = HEXCOLOR(0x333333);
        _priceTextField.font = [UIFont fontWithName:kFontNormal size:14];
        _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_priceTextField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _priceTextField;
}

- (UILabel *)freightLabel {
    if (_freightLabel == nil) {
        _freightLabel = [[UILabel alloc] init];
        _freightLabel.textColor = HEXCOLOR(0x333333);
        _freightLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _freightLabel.text = @"运      费:";
    }
    return _freightLabel;
}

- (UITextField *)freightTextField {
    if (_freightTextField == nil) {
        _freightTextField = [[UITextField alloc] init];
        _freightTextField.borderStyle = UITextBorderStyleRoundedRect;
        _freightTextField.text = @"¥30";
        _freightTextField.textColor = HEXCOLOR(0x333333);
        _freightTextField.font = [UIFont fontWithName:kFontNormal size:14];
        _freightTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_freightTextField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _freightTextField;
}

- (UILabel *)alertLabel {
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.textColor = HEXCOLOR(0x999999);
        _alertLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _alertLabel.text = @"提示：修改后，系统将更新订单的宝贝价格";
    }
    return _alertLabel;
}

- (UIButton *)changeButton {
    if (_changeButton == nil) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setTitle:@"提交修改" forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_changeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _changeButton.layer.cornerRadius = 20;
        _changeButton.clipsToBounds = YES;
        _changeButton.layer.borderWidth = 1;
        _changeButton.layer.borderColor = HEXCOLOR(0xbdbfc2).CGColor;
        [_changeButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}



@end
