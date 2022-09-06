//
//  UILabel+JHAutoSetLineNumbers.m
//  TTjianbao
//
//  Created by user on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UILabel+JHAutoSetLineNumbers.h"
#import "JHSizeCalculationHelper.h"

@implementation UILabel (JHAutoSetLineNumbers)
- (void)autoSetLineNumbers:(NSInteger)max {
    if (self.width == 0) {
        self.numberOfLines = max;
        return;
    }
    CGSize titleSize = [JHSizeCalculationHelper calculationTextWidthWith:self.text font:self.font];
    NSInteger textLineCount = titleSize.height / self.font.lineHeight;
    NSInteger lines = ceil(titleSize.width / self.width);
    if (lines > 1) {
        NSInteger fillNumbers = self.text.length;
        NSMutableString *fillChars = [[NSMutableString alloc] initWithString:@""];
        for (int i = 0; i < fillNumbers; i++) {
            [fillChars appendString:@"    "];
        }
        self.text = [NSString stringWithFormat:@"%@%@", self.text, fillChars];
    }
    NSInteger num = MIN(MAX(textLineCount, lines), max);
    self.numberOfLines = MAX(1, num);
}
@end
