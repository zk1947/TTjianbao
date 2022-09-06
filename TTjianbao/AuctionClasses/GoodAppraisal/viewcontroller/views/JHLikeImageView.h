//
//  JHLikeImageView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/4/16.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLikeImageView : UIImageView
- (instancetype)initDragWithFrame:(CGRect)frame;
- (instancetype)initVideoDragWithFrame:(CGRect)frame;

/**
 默认 0.5 后消失
 */
- (void)beginAnimation;

/**
during 时间后消失
 @param during 动画持续时间
 */
- (void)beginAnimationDuring:(CGFloat)during;


/**
 开始动画 需要手动结束
 */
- (void)startAnimation;


/**
 结束动画
 */
- (void)endAnimation;
@end

@interface JHLodingImageView : UIImageView
- (void)beginAnimation;
- (void)endAnimation;
@end

NS_ASSUME_NONNULL_END
