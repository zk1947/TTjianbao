//
//  JHBottomAnimationView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/// 约束 带动画的底部弹框
@interface JHBottomAnimationView : UIView

//要有动画，必须有这个值
@property (nonatomic, assign) CGFloat bottomAnimationViewHeight;

@property (nonatomic, weak) UIView *bottomAnimationView;

- (void)show;

- (void)dissmiss;

@end

NS_ASSUME_NONNULL_END
