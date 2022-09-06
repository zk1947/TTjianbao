//
//  JHWebImage.m
//  TTjianbao
//
//  Created by Jesse on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHWebImage.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>
#import "UIImageView+YYWebImage.h"

@implementation JHWebImage

#pragma mark - manager
+ (void)cancelAllRequest
{
    [[SDWebImageManager sharedManager] cancelAll];
}

+ (void)loadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options completed:(JHWebImageCompletionBlock)completedBlock
{
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:options context:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        completedBlock(image, error);
    }];
}

#pragma mark - Cache
+ (NSUInteger)totalDiskSize
{
    return [[SDImageCache sharedImageCache] totalDiskSize];
}

+ (void)clearCacheMemory
{
    [[SDImageCache sharedImageCache] clearMemory];
}

+ (void)clearDiskWithCompletion:(nullable JHWebImageCallbackBlock)completion
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:(SDWebImageNoParamsBlock)completion];
}

+ (nullable UIImage *)imageFromCacheForKey:(nullable NSString *)key
{
    return [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
}

+ (nullable UIImage *)imageFromDiskCacheForKey:(nullable NSString *)key
{
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key options:0 context:nil];
}

+ (void)storeImage:(nullable UIImage *)image forKey:(nullable NSString *)key completion:(nullable JHWebImageCallbackBlock)completionBlock
{
    BOOL toDisk = YES; //默认传YES
    [[SDImageCache sharedImageCache] storeImage:image imageData:nil forKey:key toDisk:toDisk completion:(SDWebImageNoParamsBlock)completionBlock];
}

#pragma mark - download
+ (void)downloadImageWithURL:(NSURL *)url completed:(JHWebImageCompletionBlock)completedBlock
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        completedBlock(image, error);
    }];
}

@end
