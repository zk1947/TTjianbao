//
//  NSObject+JHTools.m
//  TTjianbao
//
//  Created by apple on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NSObject+JHTools.h"

@implementation NSObject (JHTools)

//字典转JSON
+(NSString *)convertJSONWithDic:(NSDictionary *)dic {
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        return @"字典转JSON出错";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSAttributedString *)paraStyleTextRetract:(NSString *)paraString FontSize:(CGFloat)size {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;//对齐
    paraStyle.headIndent = 0.0f;//行首缩进
    //字体大小号字乘以2 即首行空出两个字符
    CGFloat emptylen = size * 2;
    paraStyle.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle.tailIndent = 100.0f;//行尾缩进
    paraStyle.lineSpacing = 1.0f;//行间距
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:paraString attributes:@{NSParagraphStyleAttributeName:paraStyle}];
    return attrText;
}


@end
