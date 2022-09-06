//
//  JHLotteryHitDetailView.h
//  TTjianbao
//
//  Created by lihui on 2020/8/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///0元抽界面 - 展示收货地址或者物流信息的view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryHitDetailView : UIView

- (void)setIcon:(NSString *)icon Title:(NSString *)title Detail:(NSString *)detail Desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
