//
//  UIInputTextField.m
//  ZhangcaiLicaishi
//
//  Created by Wujg on 15/3/17.
//  Copyright (c) 2015年 hetang. All rights reserved.
//

#import "UIInputTextField.h"

@implementation UIInputTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = kColor333;
        self.font = [UIFont systemFontOfSize:15.0];
        self.keyboardType = UIKeyboardTypeDefault;
        self.keyboardAppearance = UIKeyboardAppearanceDefault;
        self.returnKeyType = UIReturnKeyNext;
        self.secureTextEntry = NO;
        self.clearsOnBeginEditing = NO;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;//清除键
        self.adjustsFontSizeToFitWidth = NO;
        self.autocorrectionType = UITextAutocorrectionTypeNo;//是否纠错
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;//单词首字母是否大写
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
        
        self.borderStyle = UITextBorderStyleNone;
        [self.layer setBorderWidth:0.0f];
        [self.layer setCornerRadius:0.0];
        [self.layer setBorderColor:[UIColor clearColor].CGColor];
    }
    return self;
}

#pragma mark -
#pragma mark - 重写UITextField方法
//控制placeHolder的位置
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    //不减30，如果内容右对齐，并且添加了textField的rightView，会覆盖右面的视图
//    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y+1.0, bounds.size.width-30.0, bounds.size.height);
//    return inset;
//}

@end
