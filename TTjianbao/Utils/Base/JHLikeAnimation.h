//
//  JHLikeAnimation.h
//  TTjianbao
//
//  Created by lihui on 2020/10/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 点赞动画

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLikeAnimation : UIImageView

- (instancetype)initWithFrame:(CGRect)frame animationImageName:(NSString *)imageName;

- (void)beginAnimation;


/// 双击点赞动画
/// @param super_view 父视图
/// @param praiseBlock 点赞回调
+ (void)praiseAnimationWithSuperView:(UIView * __nullable)super_view praiseBlock:(dispatch_block_t __nullable)praiseBlock;

@end

NS_ASSUME_NONNULL_END
