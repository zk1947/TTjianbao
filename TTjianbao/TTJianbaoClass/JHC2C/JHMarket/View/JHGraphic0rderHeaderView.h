//
//  JHGraphic0rderHeaderView.h
//  TTjianbao
//
//  Created by miao on 2021/6/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHOrderDetailMode;

NS_ASSUME_NONNULL_BEGIN

@interface JHGraphic0rderHeaderView : UIView

/// 刷新头部的信息
/// @param orderDetailMode 头部的视图
- (void)updateGraphic0rderHeaderView:(JHOrderDetailMode *)orderDetailMode;

/// 倒计时为0
@property (nonatomic, copy) dispatch_block_t countDownFinshBlock;

@end

NS_ASSUME_NONNULL_END
