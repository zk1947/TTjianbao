//
//  JHTitleTextItemView.m
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTitleTextItemView.h"
#import "TTjianbaoHeader.h"

#define NumbersWithDot     @"0123456789.\n"
#define NumbersWithoutDot  @"0123456789\n"


@interface JHTitleTextItemView ()<UITextFieldDelegate>
@end
@implementation JHTitleTextItemView


- (instancetype)initWithTitle:(NSString *)title textPlace:(NSString *)placeHolder isEdit:(BOOL)isEdit isShowLine:(BOOL)isShowLine
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        self.titleLabel.text = title;
        [self addSubview:self.textField];
        self.textField.placeholder = placeHolder;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.leading.offset(10);
            //            make.width.equalTo(@60);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(15);
            make.top.equalTo(self);
            make.trailing.equalTo(self).offset(-20);
            make.bottom.equalTo(self).offset(-1);
        }];
        
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        if (isShowLine) {
            [self addSubview:self.line];
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self.textField);
                make.bottom.equalTo(self);
                make.height.equalTo(@1);
            }];
        }
        
        
    }
    return self;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = HEXCOLOR(0xf7f7f7);
    }
    return _line;
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _titleLabel.textColor = HEXCOLOR(0x333333);
    }
    
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.font = [UIFont fontWithName:kFontNormal size:13];
        _textField.textColor = HEXCOLOR(0x333333);
        _textField.delegate = self;
    }
    
    return _textField;
}

- (void)openClickActionRightArrowWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_my_right_arrow"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:btn];
    self.textField.textAlignment = NSTextAlignmentRight;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.equalTo(self.textField);
        make.trailing.equalTo(self.textField).offset(10);
    }];
    self.actionBtn = btn;
}

- (void)setIsCarryTwoDote:(BOOL)isCarryTwoDote {
    _isCarryTwoDote = isCarryTwoDote;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
}

//正则表达式（只支持两位小数）
- (BOOL)isValid:(NSString*)checkStr {
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.isCarryTwoDote) {
        //新输入的
        if (string.length == 0) {
            return YES;
        }
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (![string isEqualToString:@""]) {
               NSCharacterSet *cs;
               if ([textField isEqual:self.textField]) {
                   // 小数点在字符串中的位置 第一个数字从0位置开始
                   NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
                   // 判断字符串中是否有小数点，并且小数点不在第一位
                   // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
                   // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
                   if (dotLocation == NSNotFound && range.location != 0) {
                       // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                       /*
                        [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                        在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                        */
                       cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                       if (range.location >= 8) {
                           NSLog(@"单笔金额不能超过亿位");
                           if ([string isEqualToString:@"."] && range.location == 8) {
                               return YES;
                           }
                           return NO;
                       }
                   } else {
                       cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
                   }
                   // 按cs分离出数组,数组按@""分离出字符串
                   NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                   BOOL basicTest = [string isEqualToString:filtered];
                   if (!basicTest) {
                       NSLog(@"只能输入数字和小数点");
                       return NO;
                   }
                   if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
                       NSLog(@"小数点后最多两位");
                       return NO;
                   }
                   if (textField.text.length > 11) {
                       return NO;
                   }
               }
           }
        
        return [self isValid:checkStr];
    }
    return YES;
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}


@end
