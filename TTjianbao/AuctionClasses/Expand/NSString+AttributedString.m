//
//  NSString+AttributedString.m
//    
//
//  Created by yaoyao on 2017/9/30.
//  Copyright © 2017年 yaoyao. All rights reserved.
//

#import "NSString+AttributedString.h"
#import "CommHelp.h"

@implementation NSString (AttributedString)
- (NSMutableAttributedString *)attributedSubString:(NSString *)subString font:(UIFont *)font color:(UIColor *)color allColor:(UIColor *)allColor allfont:(UIFont *)allFont {
    NSRange range = [self rangeOfString:subString];
    
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
//    [descStyle setLineSpacing:3];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    
     [attString addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, self.length)];
    
    [attString addAttribute:NSFontAttributeName value:allFont range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSFontAttributeName value:font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
   
    return attString;
}

- (NSMutableAttributedString *)attributedFontSize:(CGFloat)fontSize color:(UIColor *)color {
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    [descStyle setLineSpacing:3];
    descStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attString addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, self.length)];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    return attString;
}

- (NSMutableAttributedString *)attributedFont:(UIFont*)font color:(UIColor *)color range:(NSRange)range{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    [attString addAttribute:NSFontAttributeName value:font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
   
    return attString;
    
}
- (NSMutableAttributedString *)attributedFontSize:(CGFloat)fontSize color:(UIColor *)color lineSpace:(NSInteger)space {
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    [descStyle setLineSpacing:space];
    descStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attString addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, self.length)];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    return attString;
}
- (NSMutableAttributedString *)attributedTailFontSize:(CGFloat)fontSize color:(UIColor *)color {
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    [descStyle setLineSpacing:3];
    descStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attString addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, self.length)];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    return attString;
}

- (NSMutableAttributedString *)attributedFontSize:(CGFloat)fontSize color:(UIColor *)color firstLineHeadIndent:(CGFloat)indent{
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    [descStyle setLineSpacing:3];
    descStyle.paragraphSpacing = 10;

    descStyle.firstLineHeadIndent = indent;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attString addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, self.length)];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    return attString;
}

- (NSMutableAttributedString *)formatePriceFontSize:(CGFloat)fontSize color:(UIColor *)color {
    if (!self) {
        return [[NSMutableAttributedString alloc] initWithString:@" "];
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontBoldDIN size:fontSize] range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
    if ([self hasSuffix:@"万"] || [self hasSuffix:@"亿"]) {
        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize*10/12.] range:NSMakeRange(self.length-1, 1)];

    }
    return attString;
}


- (NSMutableAttributedString *)attributedSubString:(NSString *)subString subString:(NSString *)subs font:(UIFont *)font color:(UIColor *)color  sfont:(UIFont *)sfont scolor:(UIColor *)scolor allColor:(UIColor *)allColor allfont:(UIFont *)allFont {
    
    NSRange range = [self rangeOfString:subString];
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attString addAttribute:NSFontAttributeName value:allFont range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, self.length)];
    [attString addAttribute:NSFontAttributeName value:font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    range = [self rangeOfString:subs];
    [attString addAttribute:NSFontAttributeName value:sfont range:range];

    [attString addAttribute:NSForegroundColorAttributeName value:scolor range:range];

    return attString;
    
    
}
- (NSMutableAttributedString *)attributedShadow{
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2;//阴影半径，默认值3
    shadow.shadowColor = [CommHelp toUIColorByStr:@"#666666"];;
    shadow.shadowOffset = CGSizeMake(1, 1);//阴影偏移量，x向右偏移，y向下偏移，默认是（0，-3）
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:self attributes:@{NSShadowAttributeName:shadow}];
    
    return attributedText;
}

+ (NSMutableAttributedString *)mergeStrings:(NSMutableArray *)items {
    
    NSString *sumString = @"";
    for (NSInteger i=0; i < items.count; i ++) {
        NSDictionary *dict = items[i];
        sumString = [NSString stringWithFormat:@"%@%@", sumString, dict[@"string"]];
    }
    NSMutableAttributedString *sumAttributedString = [[NSMutableAttributedString alloc]initWithString:sumString];
    NSInteger startCount = 0;
    for (NSInteger i=0; i < items.count; i ++) {
        NSDictionary *dict = items[i];
        NSString *itemString = dict[@"string"];
        NSRange rangel = NSMakeRange(startCount, itemString.length);
        [sumAttributedString addAttribute:NSForegroundColorAttributeName value:dict[@"color"] range:rangel];
        [sumAttributedString addAttribute:NSFontAttributeName value:dict[@"font"] range:rangel];
        startCount += itemString.length;
    }
    return sumAttributedString;
}

@end
