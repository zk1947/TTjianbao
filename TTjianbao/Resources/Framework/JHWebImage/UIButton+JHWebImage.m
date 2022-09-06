//
//  UIButton+JHWebImage.m
//  TTjianbao
//
//  Created by Jesse on 2020/11/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIButton+JHWebImage.h"
#import "UIButton+WebCache.h"

@implementation UIButton (JHWebImage)

- (void)jhSetImageWithURL:(nullable NSURL *)url forState:(UIControlState)state
{
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)jhSetImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholder:(nullable UIImage *)placeholder
{
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)jhSetImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholder:(nullable UIImage *)placeholder options:(SDWebImageOptions)options completed:(nullable JHWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        completedBlock(image,  error);
    }];
}

@end
