//
//  JHLikeAnimation.m
//  TTjianbao
//
//  Created by lihui on 2020/10/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLikeAnimation.h"

@implementation JHLikeAnimation

- (instancetype)initWithFrame:(CGRect)frame animationImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<21; i++) {
            [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%02d", imageName, i]]];
        }
        self.animationImages = array;
        self.animationRepeatCount = 0;
        self.animationDuration = 0.5;
    }
    return self;
}

- (void)beginAnimation {
    [self startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAnimating];
        [self removeFromSuperview];
    });
}

/// 双击点赞动画
/// @param super_view 父视图
/// @param praiseBlock 点赞回调
+ (void)praiseAnimationWithSuperView:(UIView *)super_view praiseBlock:(dispatch_block_t)praiseBlock{
    JHLikeAnimation *imageView = [[JHLikeAnimation alloc] initWithFrame:CGRectZero animationImageName:@"dis_like_000"];
    [super_view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(super_view);
        make.size.mas_equalTo(CGSizeMake(180, 180));
    }];
    if (praiseBlock) {
        praiseBlock();
    }
    [imageView beginAnimation];
}

@end
