//
//  UIButton+JHWebCache.m
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIButton+JHWebCache.h"

@implementation UIButton (JHWebCache)

- (void)jh_setButtonImageWithUrl:(NSString *)urlStr {
    NSURL * url = [NSURL URLWithString:urlStr];
    // 根据图片的url下载图片数据
    dispatch_queue_t jhQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
    dispatch_async(jhQueue, ^{
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:img forState:UIControlStateNormal];
        });
    });
}

- (void)jh_setButtonImageWithUrl:(NSString *)urlStr controlState:(UIControlState)state {
    NSURL * url = [NSURL URLWithString:urlStr];
    // 根据图片的url下载图片数据
    dispatch_queue_t jhQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
    dispatch_async(jhQueue, ^{
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:img forState:state];
        });
    });
}

@end
