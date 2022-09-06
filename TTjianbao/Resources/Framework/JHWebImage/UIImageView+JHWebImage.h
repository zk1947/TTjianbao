//
//  UIImageView+JHWebImage.h
//  TTjianbao
//  Description:封装SDWebImage中,UIImageView扩展
//  Created by Jesse on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWebImageHeader.h"

//NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (JHWebImage)

- (void)jhSetImageWithURL:(nullable NSURL *)url;

- (void)jhSetImageWithURL:(nullable NSURL *)url
                        placeholder:(nullable UIImage *)placeholder;

- (void)jhSetImageWithURL:(nullable NSURL *)url
                        placeholder:(nullable UIImage *)placeholder
                          completed:(nullable JHWebImageCompletionBlock)completedBlock;

- (void)jhSetImageWithURL:(nullable NSURL *)url
                        placeholder:(nullable UIImage *)placeholder
                            options:(SDWebImageOptions)options
                           progress:(nullable JHWebImageProgressBlock)progressBlock
                          completed:(nullable JHWebImageCompletionBlock)completedBlock;

@end

//NS_ASSUME_NONNULL_END
