//
//  UIImage+JHCompressImage.m
//  TTjianbao
//
//  Created by apple on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UIImage+JHCompressImage.h"

@implementation UIImage (JHCompressImage)

- (UIImage *)compressedImageFiles:(UIImage *)image imageMaxSizeKB:(CGFloat)fImageKBytes {
    //二分法压缩图片
    CGFloat compression = 1;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSUInteger fImageBytes = fImageKBytes * 1000;//需要压缩的字节Byte，iOS系统内部的进制1000
    if (imageData.length <= fImageBytes){
        return [UIImage imageWithData:imageData];
    }
    CGFloat max = 1;
    CGFloat min = 0;
    //指数二分处理，s首先计算最小值
    compression = pow(2, -6);
    imageData = UIImageJPEGRepresentation(image, compression);
    if (imageData.length < fImageBytes) {
        //二分最大10次，区间范围精度最大可达0.00097657；最大6次，精度可达0.015625
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            imageData = UIImageJPEGRepresentation(image, compression);
            //容错区间范围0.9～1.0
            if (imageData.length < fImageBytes * 0.9) {
                min = compression;
            } else if (imageData.length > fImageBytes) {
                max = compression;
            } else {
                break;
            }
        }
        return [UIImage imageWithData:imageData];
    }
 
    // 对于图片太大上面的压缩比即使很小压缩出来的图片也是很大，不满足使用。
    //然后再一步绘制压缩处理
    UIImage *resultImage = [UIImage imageWithData:imageData];
    while (imageData.length > fImageBytes) {
        @autoreleasepool {
            CGFloat ratio = (CGFloat)fImageBytes / imageData.length;
            //使用NSUInteger不然由于精度问题，某些图片会有白边
        NSLog(@">>>>>>>>>>>>>>>>>%f>>>>>>>>>>>>%f>>>>>>>>>>>%f",resultImage.size.width,sqrtf(ratio),resultImage.size.height);
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
//            resultImage = [self drawWithWithImage:resultImage Size:size];
//            resultImage = [self scaledImageWithData:imageData withSize:size scale:resultImage.scale orientation:UIImageOrientationUp];
            resultImage = [self thumbnailForData:imageData maxPixelSize:MAX(size.width, size.height)];
            imageData = UIImageJPEGRepresentation(resultImage, compression);
        }
    }
 
//   整理后的图片尽量不要用UIImageJPEGRepresentation方法转换，后面参数1.0并不表示的是原质量转换。
    return [UIImage imageWithData:imageData];
}

- (UIImage *)thumbnailForData:(NSData *)data maxPixelSize:(NSUInteger)size {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
        (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
        (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(size),
        (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
    });
    CFRelease(source);
    CFRelease(provider);
    if (!imageRef) {
        return nil;
    }
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return toReturn;
}



#pragma mark - 压缩图片
- (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    UIImage *OriginalImage = image;
    // 执行这句代码之后会有一个范围 例如500m 会是 100k～500k
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    
    // 执行while循环 如果第一次压缩不会小于100k 那么减小尺寸在重新开始压缩
    while (dataKBytes > size) {
        while (dataKBytes > size && maxQuality > 0.1f) {
            maxQuality = maxQuality - 0.1f;
            data = UIImageJPEGRepresentation(image, maxQuality);
            dataKBytes = data.length / 1000.0;
            if(dataKBytes <= size) {
                return [UIImage imageWithData:data];
            }
        }
        OriginalImage =[self compressOriginalImage:OriginalImage toWidth:OriginalImage.size.width * 0.8];
        image = OriginalImage;
        data = UIImageJPEGRepresentation(image, 1.0);
        dataKBytes = data.length / 1000.0;
        maxQuality = 0.9f;
    }
    return [UIImage imageWithData:data];
}

#pragma mark - 改变图片的大小
-(UIImage *)compressOriginalImage:(UIImage *)image toWidth:(CGFloat)targetWidth {
    CGSize imageSize = image.size;
    CGFloat Originalwidth = imageSize.width;
    CGFloat Originalheight = imageSize.height;
    CGFloat targetHeight = Originalheight / Originalwidth * targetWidth;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [image drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
