//
//  JHImage.m
//  TTjianbao
//
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHImage.h"

@implementation JHImage

//改变image大小
+ (UIImage *)imageScaleSize:(CGSize)size image:(NSString*)image
{
    UIImage* img = [UIImage imageNamed:image ? : @"publish_delete_topic_img"];
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
