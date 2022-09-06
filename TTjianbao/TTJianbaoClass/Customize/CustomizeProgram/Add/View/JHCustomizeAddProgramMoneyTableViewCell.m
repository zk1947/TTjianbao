//
//  JHCustomizeAddProgramMoneyTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddProgramMoneyTableViewCell.h"
#import "IQKeyboardManager.h"

@interface JHCustomizeAddProgramMoneyTableViewCell () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *serverLabel;
@property (nonatomic, strong) UILabel     *materialLabel;
@property (nonatomic, strong) UITextField *servertextField;
@property (nonatomic, strong) UITextField *materialtextField;
@property (nonatomic, strong) UILabel     *finalMoneyLable;
@property (nonatomic, strong) UILabel     *moneyLabel;
@end

@implementation JHCustomizeAddProgramMoneyTableViewCell

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
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    
    self.contentView.layer.cornerRadius = 8.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
   
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text          = @"方案金额";
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.width.mas_equalTo(60.f);
        make.height.mas_equalTo(21.f);
    }];
    
    /// 服务费
    _serverLabel               = [[UILabel alloc] init];
    _serverLabel.textColor     = HEXCOLOR(0x333333);
    _serverLabel.textAlignment = NSTextAlignmentLeft;
    _serverLabel.text          = @"服务费";
    _serverLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_serverLabel];
    [_serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.width.mas_equalTo(36.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _servertextField = [[UITextField alloc] init];
    _servertextField.textAlignment = NSTextAlignmentRight;
    _servertextField.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _servertextField.delegate      = self;
    _servertextField.placeholder   = @"￥在此输入金额";
    _servertextField.keyboardType  = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_servertextField];
    [_servertextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.serverLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 材料费
    _materialLabel               = [[UILabel alloc] init];
    _materialLabel.textColor     = HEXCOLOR(0x333333);
    _materialLabel.textAlignment = NSTextAlignmentLeft;
    _materialLabel.text          = @"材料费";
    _materialLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_materialLabel];
    [_materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serverLabel.mas_left);
        make.top.equalTo(self.serverLabel.mas_bottom).offset(15.f);
        make.width.mas_equalTo(36.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _materialtextField = [[UITextField alloc] init];
    _materialtextField.textAlignment = NSTextAlignmentRight;
    _materialtextField.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _materialtextField.delegate      = self;
    _materialtextField.placeholder   = @"￥在此输入金额";
    _materialtextField.keyboardType  = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_materialtextField];
    [_materialtextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.materialLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 分割线
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = HEXCOLOR(0xF0F0F0).CGColor;
    lineLayer.frame = CGRectMake(10.f, 124.f, ScreenW-40.f, 1.f);
    [self.layer addSublayer:lineLayer];
    
    /// 总金额
    _finalMoneyLable               = [[UILabel alloc] init];
    _finalMoneyLable.textColor     = HEXCOLOR(0x333333);
    _finalMoneyLable.textAlignment = NSTextAlignmentLeft;
    _finalMoneyLable.text          = @"总额";
    _finalMoneyLable.font          = [UIFont fontWithName:kFontMedium size:12.f];
    [self.contentView addSubview:_finalMoneyLable];
    [_finalMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.materialLabel.mas_left);
        make.top.equalTo(self.materialLabel.mas_bottom).offset(31.f);
        make.width.mas_equalTo(36.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    /// 总额
    _moneyLabel               = [[UILabel alloc] init];
    _moneyLabel.textColor     = HEXCOLOR(0xFF4200);
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    _moneyLabel.text          = @"￥0";
    _moneyLabel.font          = [UIFont fontWithName:kFontMedium size:12.f];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.finalMoneyLable.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
}

- (BOOL)checkTextFieldIsLegal {
    if (self.servertextField.text.length < 1) {
        return NO;
    }
    return YES;
}

- (NSString *)allMoneyText {
    CGFloat servertext   = 0.f;
    CGFloat materialtext = 0.f;
    if (!isEmpty(self.servertextField.text)) {
        servertext = [self.servertextField.text floatValue];
    }
    if (!isEmpty(self.materialtextField.text)) {
        materialtext = [self.materialtextField.text floatValue];
    }
    return [NSString stringWithFormat:@"%.2f",servertext + materialtext];
}

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.servertextField.text >0 || self.materialtextField.text >0) {
        if (self.moneyHasValue) {
            self.moneyHasValue(YES);
        }
    } else {
        if (self.moneyHasValue) {
            self.moneyHasValue(NO);
        }
    }
    return [self judgeTextFieldInputDecimals:textField replacementString:string shouldChangeCharactersInRange:range];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[self allMoneyText]];
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

- (NSString *)getServertext {
    if (!isEmpty(self.servertextField.text)) {
        return self.servertextField.text;
    }
    return @"0";
}

- (NSString *)getMaterialtext {
    if (!isEmpty(self.materialtextField.text)) {
        return self.materialtextField.text;
    }
    return @"0";
}

@end
