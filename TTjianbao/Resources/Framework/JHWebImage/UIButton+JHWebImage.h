//
//  UIButton+JHWebImage.h
//  TTjianbao
//  Description:封装SDWebImage中,UIButton扩展
//  Created by Jesse on 2020/11/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWebImageHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (JHWebImage)

- (void)jhSetImageWithURL:(nullable NSURL *)url forState:(UIControlState)state;
- (void)jhSetImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholder:(nullable UIImage *)placeholder;
- (void)jhSetImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholder:(nullable UIImage *)placeholder options:(SDWebImageOptions)options completed:(nullable JHWebImageCompletionBlock)completedBlock;
@end

NS_ASSUME_NONNULL_END
