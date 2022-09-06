//
//  NSString+UISize.m
//  TXLiteAVDemo
//
//  Created by cui on 2018/12/17.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "NSString+UISize.h"

@implementation NSString (UISize)

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font
{
    return [self textSizeIn:size font:font breakMode:NSLineBreakByWordWrapping];
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)breakMode
{
    return [self textSizeIn:size font:afont breakMode:NSLineBreakByWordWrapping align:NSTextAlignmentLeft];
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment
{
    NSLineBreakMode breakMode = abreakMode;
    UIFont *font = afont;
    
    CGSize contentSize = CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = alignment;
    
    NSDictionary* attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    contentSize = [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    contentSize = CGSizeMake((int)contentSize.width + 1, (int)contentSize.height + 1);
    return contentSize;
}


-(CGFloat)getStringHeight:(UIFont*)font width:(CGFloat)width size:(CGFloat)minSize
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    [attributedString addAttributes:attrSyleDict range:NSMakeRange(0, self.length)];
    
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return stringRect.size.height;
}

-(CGFloat)getStringWidth:(UIFont*)font height:(CGFloat)height size:(CGFloat)minSize{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  font, NSFontAttributeName,
                                  nil];
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    
    return stringRect.size.width;
}

-(CGFloat)getStringHeight:(UIFont*)font width:(CGFloat)width maxLineCount:(int)lineCount
{
    if (self.length == 0) {
        return 0;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    [attributedString addAttributes:attrSyleDict range:NSMakeRange(0, self.length)];
    CGFloat height = [@"是" getStringHeight:font width:100 size:0];
    
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(width, height* lineCount) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return stringRect.size.height;
}

+ (CGSize)getSpaceLabelHeight:(NSString *)string font:(UIFont*)font maxSize:(CGSize)maxSize withlineSpacing:(float)lineSpacing {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [string boundingRectWithSize:maxSize options: NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}
@end
