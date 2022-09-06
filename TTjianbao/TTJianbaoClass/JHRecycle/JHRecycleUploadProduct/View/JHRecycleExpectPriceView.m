//
//  JHRecycleExpectPriceView.m
//  TTjianbao
//
//  Created by liuhai on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleExpectPriceView.h"

@interface JHRecycleExpectPriceView ()<UITextFieldDelegate>
@property(nonatomic, strong) UIView * line;
@property(nonatomic, strong) UILabel * identifyLabel;
@end

@implementation JHRecycleExpectPriceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.identifyLabel];
    [self addSubview:self.titleLbl];
    [self addSubview:self.placeholderLbl];
    [self addSubview:self.line];
    
}

- (void)layoutItems{

    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).offset(12);
    }];
    
    [self.identifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(10);
        make.left.equalTo(@0).offset(12);
    }];
    
    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(10);
        make.left.mas_equalTo(self.identifyLabel.mas_right).offset(5);
        make.width.mas_equalTo(ScreenW - 50.f);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.identifyLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"期望价格";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)identifyLabel{
    if (!_identifyLabel) {
        UILabel *label = [UILabel new];
        label.font = JHDINBoldFont(19);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"¥";
        _identifyLabel = label;
    }
    return _identifyLabel;
}

- (UIView *)line{
    if (!_line) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xE6E6E6);
        _line = view;
    }
    return _line;
}

- (UITextField *)placeholderLbl{
    if (!_placeholderLbl) {
        UITextField *label = [UITextField new];
        label.font = JHDINBoldFont(19);
        label.textColor = HEXCOLOR(0xF23730);
        label.placeholder = @"请输入出价";
        label.textAlignment = NSTextAlignmentLeft;
        label.keyboardType  = UIKeyboardTypeDecimalPad;
        label.delegate = self;
        _placeholderLbl = label;
    }
    return _placeholderLbl;
}

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self judgeTextFieldInputDecimals:textField replacementString:string shouldChangeCharactersInRange:range];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
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
    return YES;
}
@end
