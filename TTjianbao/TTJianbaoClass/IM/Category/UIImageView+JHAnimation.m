//
//  UIImageView+JHAnimation.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIImageView+JHAnimation.h"

@implementation UIImageView (JHAnimation)
- (void)startAnimationWithImages : (NSArray<NSString *> *)images {
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    for (NSString *imageName in images) {
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    // 设置动画图片
    self.animationImages = imageArr;
    
    // 设置动画的播放次数
    self.animationRepeatCount = 0;
    
    // 设置播放时长
    // 1秒30帧, 一张图片的时间 = 1/30 = 0.03333 20 * 0.0333
    self.animationDuration = 1.0;
    
    // 开始动画
    [self startAnimating];
}

@end
