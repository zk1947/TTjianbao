//
//  ELUtils.m
//  ELBooks
//
//  Created by Eric on 12-8-25.
//  Copyright 2012 zhaopin. All rights reserved.
//

#import "ELUtils.h"

void showAlertMessage(NSString *message)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}

void showMessage(NSString *message){
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//限制字数
float getTextLength(NSString *text)
{
    if (text) {
        unsigned short cc = 8198;
        NSString *checker = [NSString stringWithFormat:@"%C", cc]; // %C为大写
        if ([text rangeOfString:checker].length) {
            text= [text stringByReplacingOccurrencesOfString:checker withString:@""];
        }
    }
    float num = 0;
    for (int i =0; i<[text length]; i++) {
        
        NSRange  range = {i,1};
        
        NSString  *str = [text substringWithRange:range];
        
        if (![str isEqualToString:@""] || str != nil)
        {
            int  charLenth = (int)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            if (charLenth == 3) {
                num += 1;
            }
            if (charLenth == 1) {
                num += 0.5;
            }
        }
        else
        {
            num += 0.5;
        }
    }
//    return ceilf(num);
    return num;
}

