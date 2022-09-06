//
//  UITextField+PlaceHolderColor.m
//  TTjianbao
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UITextField+PlaceHolderColor.h"



@implementation UITextField (PlaceHolderColor)
- (void)placeHolderColor:(UIColor *)color {
    if (self.placeholder) {
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName : color}];
        self.attributedPlaceholder = placeholderString;
    }
}
@end
