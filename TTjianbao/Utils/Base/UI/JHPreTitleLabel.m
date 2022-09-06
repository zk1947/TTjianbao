//
//  JHPreTitleLabel.m
//  TTjianbao
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPreTitleLabel.h"

@implementation JHPreTitleLabel
- (void)setText:(NSString *)text {
    [super setText:text];
    if (self.preTitle && self.preTitle.length && text) {
        [super setText:[self.preTitle stringByAppendingString:text]];
    }
}


- (void)setJHAttributedText:(NSString *)attributedText font:(UIFont *)font color:(UIColor *)color {
    
    self.text = attributedText;
    
    if (self.preTitle) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.text];
                  
         [attString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.preTitle.length)];
         [attString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, self.preTitle.length)];
        if (attributedText && attributedText.length>0) {
            NSRange range = NSMakeRange(self.preTitle.length, self.text.length-self.preTitle.length);
            [attString addAttribute:NSFontAttributeName value:font range:range];
            [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        self.attributedText = attString;
    }
    
}
@end
