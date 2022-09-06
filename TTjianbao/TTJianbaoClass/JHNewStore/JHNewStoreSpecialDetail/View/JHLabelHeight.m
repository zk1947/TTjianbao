//
//  JHLabelHeight.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLabelHeight.h"

@implementation JHLabelHeight

- (void)setTextToLabel:(NSString *)descStr {
    self.numberOfLines = 3;
    if (!descStr) {
        return;
    }
    UIFont *font13 = [UIFont systemFontOfSize:13];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:descStr];
    [attrStr addAttribute:NSFontAttributeName value:font13 range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, attrStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    self.attributedText = attrStr;
}

- (CGFloat)getLabelHeight{
    CGFloat textHeight = [self sizeThatFits:CGSizeMake(ScreenW-24, 67)].height + 5 ;
    return textHeight;
}
@end
