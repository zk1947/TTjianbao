//
//  UIImageView+JHWebImage.m
//  TTjianbao
//
//  Created by Jesse on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIImageView+JHWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (JHWebImage)

- (void)jhSetImageWithURL:(nullable NSURL *)url
{
    [self jhSetImageWithURL:url placeholder:nil options:0 progress:nil completed:nil];
}

- (void)jhSetImageWithURL:(nullable NSURL *)url placeholder:(nullable UIImage *)placeholder
{
    [self jhSetImageWithURL:url placeholder:placeholder options:0 progress:nil completed:nil];
}

- (void)jhSetImageWithURL:(nullable NSURL *)url placeholder:(nullable UIImage *)placeholder completed:(nullable JHWebImageCompletionBlock)completedBlock
{
    [self jhSetImageWithURL:url placeholder:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)jhSetImageWithURL:(nullable NSURL *)url placeholder:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable JHWebImageProgressBlock)progressBlock completed:(nullable JHWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error);
        }
    }];
}

@end
