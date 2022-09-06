//
//  JHGoodManagerFilterMoneyTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerFilterMoneyTableViewCell.h"
#import "JHGoodManagerSingleton.h"

@interface JHGoodManagerFilterMoneyTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *lowPriceTextField;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UITextField *highPriceTextField;
@end

@implementation JHGoodManagerFilterMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _lowPriceTextField                     = [[UITextField alloc] init];
    _lowPriceTextField.textAlignment       = NSTextAlignmentCenter;
    _lowPriceTextField.placeholder         = @"最低价";
    _lowPriceTextField.font                = [UIFont fontWithName:kFontNormal size:12.f];
    _lowPriceTextField.layer.cornerRadius  = 15.f;
    _lowPriceTextField.layer.masksToBounds = YES;
    _lowPriceTextField.backgroundColor     = HEXCOLOR(0xF5F5F5);
    _lowPriceTextField.delegate            = self;
    _lowPriceTextField.keyboardType        = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_lowPriceTextField];
    [_lowPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18.f);
        make.top.equalTo(self.contentView.mas_top).offset(7.f);
        make.width.mas_equalTo(141.f);
        make.height.mas_equalTo(30.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    /// 横划线
    _lineView                 = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0x999999);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lowPriceTextField.mas_right).offset(6.f);
        make.centerY.equalTo(self.lowPriceTextField.mas_centerY);
        make.width.mas_equalTo(6.f);
        make.height.mas_equalTo(1.f);
    }];
    
    _highPriceTextField                     = [[UITextField alloc] init];
    _highPriceTextField.textAlignment       = NSTextAlignmentCenter;
    _highPriceTextField.placeholder         = @"最高价";
    _highPriceTextField.font                = [UIFont fontWithName:kFontNormal size:12.f];
    _highPriceTextField.layer.cornerRadius  = 15.f;
    _highPriceTextField.layer.masksToBounds = YES;
    _highPriceTextField.backgroundColor     = HEXCOLOR(0xF5F5F5);
    _highPriceTextField.delegate            = self;
    _highPriceTextField.keyboardType        = UIKeyboardTypeDecimalPad;
    _highPriceTextField.clearButtonMode     = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:_highPriceTextField];
    [_highPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(6.f);
        make.centerY.equalTo(self.lowPriceTextField.mas_centerY);
        make.width.mas_equalTo(141.f);
        make.height.mas_equalTo(30.f);
    }];
}

- (void)keyboardDismiss {
    [self.lowPriceTextField resignFirstResponder];
    [self.highPriceTextField resignFirstResponder];
}

- (void)resetAllStatus {
    self.lowPriceTextField.text = nil;
    self.highPriceTextField.text = nil;
    
    [JHGoodManagerSingleton shared].minPrice = @"";
    [JHGoodManagerSingleton shared].maxPrice = @"";
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self judgeTextFieldInputDecimals:textField replacementString:string shouldChangeCharactersInRange:range];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.lowPriceTextField.text.length >0) {
        [JHGoodManagerSingleton shared].minPrice = self.lowPriceTextField.text;
    } else {
        [JHGoodManagerSingleton shared].minPrice = @"";
    }
    
    if (self.highPriceTextField.text.length >0) {
        [JHGoodManagerSingleton shared].maxPrice = self.highPriceTextField.text;
    } else {
        [JHGoodManagerSingleton shared].maxPrice = @"";
    }
}



#pragma mark - 判断输入的内容小数点后俩位
- (BOOL)judgeTextFieldInputDecimals:(UITextField *)textField
                  replacementString:(NSString *)string
      shouldChangeCharactersInRange:(NSRange)range {
    // 1 不能直接输入小数点
    if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )  return NO;
    // 2 输入框第一个字符为“0”时候，第二个字符如果不是“.”,那么文本框内的显示内容就是新输入的字符[textField.text length] == 1  防止例如0.5会变成5
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && [textField.text length] == 1 && ![string isEqualToString:@"."]){
        textField.text = string;
        return NO;
    }
    // 3 保留两位小数
    NSUInteger remain = 2;
    NSRange pointRange = [textField.text rangeOfString:@"."];
    // 拼接输入的最后一个字符
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    // 输入框内存在小数点， 不让再次输入“.” 或者 总长度-包括小数点之前的长度>remain 就不能再输入任何字符
    if(pointRange.length > 0 &&([string isEqualToString:@"."] || strlen - (pointRange.location + 1) > remain))
        return NO;
    // 4 小数点已经存在情况下可以输入的字符集  and 小数点还不存在情况下可以输入的字符集
    NSCharacterSet *numbers = (pointRange.length > 0)?[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] : [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSString *buffer;
    // 判断string在不在numbers的字符集合内
    BOOL scan = [scanner scanCharactersFromSet:numbers intoString:&buffer];
    
    if ( !scan && ([string length] != 0) ) { // 包括输入空格scan为NO， 点击删除键[string length]为0
        return NO;
    }
    if (pointRange.length > 0) { /// 包含小数
        if (textField.text.length > 11) {
            if ([string isEqualToString:@""]) {

            } else {
                return NO;
            }
        }
    } else { /// 不包含小数
        if (textField.text.length > 7) {
            if ([string isEqualToString:@""] || [string isEqualToString:@"."]) {

            } else {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - 判断输入的内容小数点后俩位且第一位可以输入0
- (BOOL)inputJudge:(UITextField *)textField
 replacementString:(NSString *)string
shouldChangeCharactersInRange:(NSRange)range {
    /// 小数点前6位，小数点后2位
    /// 当前输入的字符是'.'
    if ([string isEqualToString:@"."]) {
        // 已输入的字符串中已经包含了'.'或者""
        if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
            return NO;
        } else {
            return YES;
        }
    } else {// 当前输入的不是'.'
        // 第一个字符是0时, 第二个不能再输入0
        if (textField.text.length == 1) {
            unichar str = [textField.text characterAtIndex:0];
            if (str == '0' && [string isEqualToString:@"0"]) {
                return NO;
            }
            if (str != '0' && str != '1') {// 1xx或0xx
                return YES;
            } else {
                if (str == '1') {
                    return YES;
                } else {
                    if ([string isEqualToString:@""]) {
                        return YES;
                    } else {
                        return NO;
                    }
                }
            }
        }
        
        // 已输入的字符串中包含'.'
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
            [str insertString:string atIndex:range.location];
            if (str.length >= [str rangeOfString:@"."].location + 4) {
                return NO;
            }
            NSLog(@"str.length = %ld, str = %@, string.location = %ld", str.length, string, range.location);
        } else {
            if (textField.text.length > 5) {
                NSLog(@"da ye----%@",textField.text);
                return range.location < 11; //控制小数点之前是几位
            }
        }
    }
    NSLog(@"textField.text----%@",textField.text);
    NSString *str  = [NSString stringWithFormat:@"%@%@",textField.text,string];
    NSLog(@"str---%@",str);
    return YES;
}

#pragma mark - 输入不带小数且首位不能是0
- (BOOL)inputNumberWithoutDecimals:(UITextField *)textField
                 replacementString:(NSString *)string
     shouldChangeCharactersInRange:(NSRange)range {
    if([textField.text length] == 0) {
        if ([string length] > 0) {
            unichar finalStr = [string characterAtIndex:0];
            if (finalStr == '0') {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }
    return YES;
}


@end
