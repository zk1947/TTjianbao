//
//  UIImage+JHCompressImage.h
//  TTjianbao
//
//  Created by apple on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JHCompressImage)

///二分法压缩图片
- (UIImage *)compressedImageFiles:(UIImage *)image imageMaxSizeKB:(CGFloat)fImageKBytes;

///压缩图片
- (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;



@end

NS_ASSUME_NONNULL_END
