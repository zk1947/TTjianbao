//
//  UILabel+TextAlignment.m
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UILabel+TextAlignment.h"
#import <CoreText/CoreText.h>
#import "NSObject+Cast.h"

@implementation UILabel (TextAlignment)
- (void)changeAlignmentBothSides {
    if (isEmpty(self.text)) {
        return;
    }
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:self.font} context:nil].size;
    CGFloat margin = (self.frame.size.width - textSize.width)/(self.text.length -1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length -1)];
    self.attributedText = attributedString;
}

@end
