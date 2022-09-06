//
//  JHRecycleBidPopView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/4/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleBidPopView.h"

@interface JHRecycleBidPopView ()
@end

@implementation JHRecycleBidPopView

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        //小数点不能为第一位
        if (textField.text.length == 0 && [string isEqualToString:@"."]) {
            return NO;
        }
        //第一位是0，后面必须是小数点
        if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
            self.isReturn = NO;
        }
        if (textField.text.length == 0 && ![string isEqualToString:@"0"]) {
            self.isReturn = YES;
        }

        if (textField.text.length == 1 && !self.isReturn && ![string isEqualToString:@"."]) {
            return NO;
        }
        //小数点在字符串中的位置 第一个数字从0位置开始
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        if (dotLocation == NSNotFound && range.location != 0) {
            //没有小数点,最大数值
            if (range.location >= 8){
                NSLog(@"单笔金额不能超过亿位");
                if ([string isEqualToString:@"."] && range.location == 8) {
                    return YES;
                }
                return NO;
            }
        }
        //判断输入多个小数点,禁止输入多个小数点
        if (dotLocation != NSNotFound){
            if ([string isEqualToString:@"."]) return NO;
        }
        //判断小数点后最多两位
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            return NO;
        }
        //判断总长度
        if (textField.text.length > 10) {
            return NO;
        }
    }
    return YES;
}

@end
