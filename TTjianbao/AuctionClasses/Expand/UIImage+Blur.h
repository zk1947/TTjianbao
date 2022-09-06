//
//  UIImage+Blur.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/27.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end
