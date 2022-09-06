//
//  JHStoneLiveWindowGuideView.h
//  TTjianbao
//  Description:引导
//  Created by yaoyao on 2019/12/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneLiveWindowGuideView : BaseView
@property (nonatomic, strong) UIButton *knowBtn;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UIImageView *localImg;

+ (void)showGuideView;
+ (void)showGuideViewWithIndex:(NSInteger)index;

+ (void)showPersonGuideY:(CGFloat)y;
@end

NS_ASSUME_NONNULL_END
