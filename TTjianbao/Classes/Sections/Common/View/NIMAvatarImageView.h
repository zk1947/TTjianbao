//
//  NIMAvatarImageView.h
//  NIMKit
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

typedef void(^SDWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);

@interface NIMAvatarImageView : UIControl
@property (nonatomic,strong)    UIImage *image;
@property (nonatomic,assign)    BOOL    clipPath;
@property (nonatomic,assign)    BOOL    isShowBorder;

@end

@interface NIMAvatarImageView (SDWebImageCache)
- (NSURL *)nim_imageURL;

- (void)nim_setImageWithURL:(NSURL *)url;
- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)nim_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;
- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
//- (void)nim_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDImageLoaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
//- (void)nim_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDImageLoaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
//- (void)nim_cancelCurrentImageLoad;
//- (void)nim_cancelCurrentAnimationImagesLoad;
@end

