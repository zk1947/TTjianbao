//
//  UIImage+JHImageSize.h
//  TTjianbao
//
//  Created by lihui on 2020/4/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JHImageSize)

/**
 根据图片的url获取尺寸

 @param imageURL url
 @return CGSize
 */
+ (CGSize)getImageSizeWithURL:(id)imageURL;



@end

NS_ASSUME_NONNULL_END
