//
//  JHWebImage.h
//  TTjianbao
//  Description:封装SDWebImage,方便以后更新
//  Created by Jesse on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHWebImageHeader.h"
#import <SDWebImage/SDWebImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface JHWebImage : NSObject

///MARK:--manager
+ (void)cancelAllRequest;
+ (void)loadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options completed:(JHWebImageCompletionBlock)completedBlock;

///MARK:--Cache
+ (NSUInteger)totalDiskSize;
+ (void)clearCacheMemory;
+ (void)clearDiskWithCompletion:(nullable JHWebImageCallbackBlock)completion;
+ (nullable UIImage *)imageFromCacheForKey:(nullable NSString *)key;
+ (nullable UIImage *)imageFromDiskCacheForKey:(nullable NSString *)key;
+ (void)storeImage:(nullable UIImage *)image forKey:(nullable NSString *)key completion:(nullable JHWebImageCallbackBlock)completionBlock;

///MARK:--download
+ (void)downloadImageWithURL:(NSURL *)url completed:(JHWebImageCompletionBlock)completedBlock;
@end

NS_ASSUME_NONNULL_END
