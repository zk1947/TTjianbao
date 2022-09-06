//
//  JHStoneDetailStoneBottomView.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailStoneActionBottomView : UIView

/// 解释 按钮
@property (nonatomic, strong) UIButton *explainButton;

/// 1:讲解   2:砍价   3:一口价
@property (nonatomic, copy) void(^bottonClickBlock)(NSInteger index);

+(CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
