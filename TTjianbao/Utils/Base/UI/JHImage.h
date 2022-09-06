//
//  JHImage.h
//  TTjianbao
//  Description:自定义image,改变大小
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHImage : UIImage

//改变image大小
+ (UIImage *)imageScaleSize:(CGSize)size image:(NSString*)image;
@end

