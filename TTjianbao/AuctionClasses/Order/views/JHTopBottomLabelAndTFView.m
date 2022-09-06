//
//  JHTopBottomLabelAndTFView.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTopBottomLabelAndTFView.h"
#import "JHLine.h"
#import "BYTimer.h"

@interface JHTopBottomLabelAndTFView()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *userNamelabel;
@property (nonatomic, strong) UILabel *errorTipLabel;
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) JHCustomLine *line;
@property (nonatomic, strong) BYTimer *timer;
@end

@implementation JHTopBottomLabelAndTFView

- (instancetype)initWithLabel:(NSString *)lbStr TFPlaceHolder:(NSString *)tfPlaceHoldStr TFText:(NSString *)tfStr {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.userNamelabel];
        [self addSubview:self.errorTipLabel];
        [self addSubview:self.accountTF];
        
        [self.userNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.f);
            make.top.mas_equalTo(10.f);
        }];
        
        [self.errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNamelabel.mas_right).mas_offset(10.f);
            make.right.mas_lessThanOrEqualTo(-12.f);
            make.bottom.mas_equalTo(self.userNamelabel).mas_offset(-1.f);
        }];
        
        [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.f);
            make.right.mas_equalTo(-12.f);
            make.top.mas_equalTo(self.userNamelabel.mas_bottom).mas_offset(12.f);
        }];
        
        _line = [[JHCustomLine alloc] init];
        _line.backgroundColor = HEXCOLOR(0xFFDDDDDD);
        [self addSubview:_line];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.);
            make.left.mas_equalTo(12.f);
            make.right.mas_equalTo(-12.f);
        }];
        
        self.userNamelabel.text = lbStr;
        self.accountTF.placeholder = tfPlaceHoldStr;
        self.accountTF.text = tfStr;
    }
    return  self;
}

- (void)dealloc {
    [self.timer stopGCDTimer];
}

- (NSString *)getTFText {
    return self.accountTF.text;
}

- (UITextField *)getTF {
    return self.accountTF;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    _returnKeyType = returnKeyType;
    self.accountTF.returnKeyType = _returnKeyType;
}

- (void)setTFEnabled:(Boolean)TFEnabled {
    _TFEnabled = TFEnabled;
    self.accountTF.userInteractionEnabled = _TFEnabled;
}

- (void)setIsShowLine:(Boolean)isShowLine {
    _isShowLine = isShowLine;
    self.line.hidden = !_isShowLine;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    _accountTF.keyboardType = _keyboardType;
}

- (void)scanCodeAction:(UIButton *)btn {
    if (self.tfScanCodeClickBlock) {
        self.tfScanCodeClickBlock(btn);
    }
}

- (void)iphoneNoTipAction:(UIButton *)btn {
    if (self.tfTipClickBlock) {
        self.tfTipClickBlock(btn);
    }
}

- (void)verificationCodeAction:(UIButton *)btn {
    self.isClickVerificationCodeBtn = YES;
    if (self.tfVerificationCodeClickBlock) {
        self.tfVerificationCodeClickBlock(btn);
    }
}

- (void)errorLabelHidden:(Boolean)hidden {
    self.errorTipLabel.hidden = hidden;
}

- (void)setErrorTip:(NSString *)str {
    self.errorTipLabel.text = str;
}

- (void)displayScanCodeBtn {
    UIButton *btn = [UIButton jh_buttonWithImage:[UIImage imageNamed:@"icon_add_bankCard_scanCode"] target:self action:@selector(scanCodeAction:) addToSuperView:self];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(self.accountTF);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
        
    [self.accountTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(btn.mas_left).mas_offset(-12);
        make.top.mas_equalTo(self.userNamelabel.mas_bottom).mas_offset(12.f);
    }];
    [self setNeedsLayout];
}

- (void)displayIphoneNoTipBtn {
    UIButton *btn = [UIButton jh_buttonWithImage:[UIImage imageNamed:@"icon_add_bankCard_iphone_tip"] target:self action:@selector(iphoneNoTipAction:) addToSuperView:self];
    
    [self.userNamelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(10.f);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNamelabel.mas_right);
        make.centerY.mas_equalTo(self.userNamelabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.errorTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_right).mas_offset(10.f);
        make.right.mas_lessThanOrEqualTo(-12.f);
        make.bottom.mas_equalTo(self.userNamelabel).mas_offset(-1.f);
    }];

    [self setNeedsLayout];
}

- (void)displayVerificationCodeBtn {
    UIButton *btn = [UIButton jh_buttonWithTitle:@"获取验证码" fontSize:14 textColor:HEXCOLOR(0xFF408FFE) target:self action:@selector(verificationCodeAction:) addToSuperView:self];
//    btn.backgroundColor = UIColor.redColor;
    [btn setTitleColor:HEXCOLOR(0xFF999999) forState:UIControlStateDisabled];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.width.mas_equalTo(74.f);
        make.centerY.mas_equalTo(self.accountTF);
    }];
    
    JHCustomLine *line = [[JHCustomLine alloc] init];
    line.backgroundColor = HEXCOLOR(0xFFDDDDDD);
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(1.f);
        make.centerY.mas_equalTo(self.accountTF);
        make.right.mas_equalTo(btn.mas_left).mas_equalTo(-8.f);
    }];
        
    [self.accountTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(line.mas_left).mas_offset(-1.f);
        make.top.mas_equalTo(self.userNamelabel.mas_bottom).mas_offset(12.f);
    }];
    
    [self setNeedsLayout];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        return YES;
    }
    
    if (self.textFieldShouldReturnBlock) {
       return self.textFieldShouldReturnBlock(textField);
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    if (self.textFieldShouldChangeCharactersInRangeBlock) {
        return self.textFieldShouldChangeCharactersInRangeBlock(textField,range,string);
    }
    
    if (self.isCutDisplay) {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 21) {
            return NO;
        }
        
        [textField setText:newString];
        
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        return;
    }
    
    if (self.textFieldDidEndEditingBlock) {
        self.textFieldDidEndEditingBlock(textField);
    }
}

- (void)editingChanged:(UITextField *)tf {
    if (self.tfEditingChangedBlock) {
        self.tfEditingChangedBlock(tf.text);
    }
}

-(void)countDown:(UIButton *)btn {
    if (!self.timer) {
        self.timer = [[BYTimer alloc] init];
    }
    
    [self.timer createTimerWithTimeout:60.f handlerBlock:^(int presentTime) {
        [btn setTitle:[NSString stringWithFormat:@"%ds后重新获取",presentTime] forState:UIControlStateNormal];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(98.f);
        }];
        btn.enabled = NO;
    } finish:^{
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        btn.enabled = YES;
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(74.f);
        }];
    }];
}

- (UILabel *)userNamelabel {
    if (!_userNamelabel) {
        _userNamelabel = [[UILabel alloc] init];
        _userNamelabel.numberOfLines = 1;
        _userNamelabel.textAlignment = NSTextAlignmentLeft;
        _userNamelabel.lineBreakMode = NSLineBreakByWordWrapping;
        _userNamelabel.font = [UIFont boldSystemFontOfSize:16.f];
        _userNamelabel.textColor = HEXCOLOR(0x333333);
    }
    return _userNamelabel;
}

- (UILabel *)errorTipLabel {
    if (!_errorTipLabel) {
        _errorTipLabel = [[UILabel alloc] init];
//        _errorTipLabel.backgroundColor = UIColor.redColor;
        _errorTipLabel.numberOfLines = 1;
        _errorTipLabel.hidden = YES;
//        _errorTipLabel.text = @"这是一条错误提示";
        _errorTipLabel.textAlignment = NSTextAlignmentLeft;
        _errorTipLabel.font = [UIFont systemFontOfSize:11.f];
        _errorTipLabel.textColor = HEXCOLOR(0xFFFC4200);
    }
    return _errorTipLabel;
}

- (UITextField *)accountTF {
    if (!_accountTF) {
        _accountTF = [[UITextField alloc] init];
        _accountTF.backgroundColor = [UIColor clearColor];
        _accountTF.tintColor = HEXCOLOR(0xFFF7B500);
        _accountTF.textColor = HEXCOLOR(0x333333);
        _accountTF.returnKeyType = UIReturnKeyNext;
        _accountTF.userInteractionEnabled = YES;
        _accountTF.delegate = self;
        _accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTF.font = [UIFont systemFontOfSize:14.f];
        [_accountTF addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountTF;
}

@end
