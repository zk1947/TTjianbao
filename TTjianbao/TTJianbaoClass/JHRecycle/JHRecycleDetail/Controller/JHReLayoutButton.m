//
//  JHReLayoutButton.m
//  TTjianbao
//
//  Created by user on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHReLayoutButton.h"

@implementation JHReLayoutButton
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (void)layoutSubviews
{
    [super layoutSubviews];


    if (self.imageView.image == nil || self.titleLabel.text.length == 0) {
        return;
    }
    
    // 水平调整后
    if (self.titleLabel.center.y == self.imageView.center.y && self.titleLabel.frame.origin.x < self.imageView.frame.origin.x) {
        return;
    }
    
    // 垂直调整后
    if (self.titleLabel.center.x == self.imageView.center.x) {
        return;
    }
    
    
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
    
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    
    CGFloat margin = self.margin;
    
    CGSize buttonSize = self.bounds.size;
    
    switch (self.layoutType) {
        case RelayoutTypeNone:
            
            return;
            break;
        case RelayoutTypeUpDown:
        {
            
            
            margin = margin ? :8;
            CGFloat height = titleFrame.size.height + imageFrame.size.height + margin;
            
            CGFloat imageCenterY = (buttonSize.height - height) * 0.5 + imageFrame.size.height * 0.5;
            self.imageView.center = CGPointMake(buttonSize.width * 0.5, imageCenterY);
            
            
            CGFloat titleCenterY = CGRectGetMaxY(self.imageView.frame) + margin + titleFrame.size.height * 0.5;
            self.titleLabel.center = CGPointMake(buttonSize.width * 0.5, titleCenterY);
        }
            break;
        case RelayoutTypeRightLeft:
        {
            margin = margin ? :5;
            CGFloat totalWidth = titleFrame.size.width + imageFrame.size.width + margin;
            CGFloat titleCenterX = (buttonSize.width - totalWidth) * 0.5 + titleFrame.size.width * 0.5;
            self.titleLabel.center = CGPointMake(titleCenterX, buttonSize.height * 0.5);

            
            CGFloat imageCenterX = CGRectGetMaxX(self.titleLabel.frame) + margin + imageFrame.size.width * 0.5;
            
            self.imageView.center = CGPointMake(imageCenterX, buttonSize.height * 0.5);

        }
            break;
        default:
            break;
    }
    
       
}

@end
