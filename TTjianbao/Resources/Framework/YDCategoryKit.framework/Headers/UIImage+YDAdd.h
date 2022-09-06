//
//  UIImage+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 2017/8/8.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (YDAdd)

+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

- (UIImage*)scaledToSize:(CGSize)targetSize;
- (UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
- (UIImage*)scaledToMaxSize:(CGSize )size;
//+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
//+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset;

+ (UIImage *)imageWithFileType:(NSString *)fileType;

- (NSData *)dataSmallerThan:(NSUInteger)dataLength;
- (NSData *)dataForCodingUpload;

//在图片上绘制文字
+ (UIImage *)drawText:(NSString *)text forImage:(UIImage *)image textPoint:(CGPoint)textPoint;

@end
