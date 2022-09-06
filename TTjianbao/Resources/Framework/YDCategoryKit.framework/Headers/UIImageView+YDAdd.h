//
//  UIImageView+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YDAdd)

- (void)doCircleFrame;
- (void)doNotCircleFrame;
- (void)doBorderWidth:(CGFloat)width color:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end
