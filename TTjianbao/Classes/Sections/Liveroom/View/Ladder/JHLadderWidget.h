//
//  JHLadderWidget.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  直播津贴浮动小视图
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void (^DidClickBlock)(NSInteger index);

@interface JHLadderWidget : UIView

+ (CGSize)widgetSize;

+ (instancetype)ladderWithClickBlock:(dispatch_block_t)block;

///开始倒计时
- (void)startTimerWithTimeInterval:(NSInteger)timeInterval;

///设置可点状态
- (void)setWidgetEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
