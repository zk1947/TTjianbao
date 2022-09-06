//
//  GrowingManager+Lottery.h
//  TTjianbao
//
//  Created by wuyd on 2020/8/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  0元抽奖埋点
//

#import "GrowingManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 页面来源
 */

///0元抽首页
#define JHFromLotteryHome @"freeLotteryHome"

///0元抽往期历史
#define JHFromLotteryHistory @"freeLotteryHistory"


@interface GrowingManager (Lottery)

///tab切换
+ (void)lotterySwitchTab:(NSDictionary *)params;

///进入详情页事件：{"from" : "h5 / freeLotteryHome / freeLotteryHistory"} - h5，0元抽首页，0元抽往期历史
+ (void)lotteryEnterPageName:(NSString *)pageName from:(NSString *)from;

///tab页面浏览时长
+ (void)lotteryBrowseDuration:(NSDictionary *)params;

///点击：点击0元参与抽奖按钮
+ (void)lotteryClickJoin:(NSDictionary *)params;

///点击：首页直接点击立即分享按钮
+ (void)lotteryClickShare:(NSDictionary *)params;

///点击：在提示分享弹框上点立即分享按钮
+ (void)lotteryClickDialogShare:(NSDictionary *)params;

///点击：开启/关闭提醒按钮
+ (void)lotteryClickRemind:(NSDictionary *)params;

///点击：点击0元抽奖规则按钮
+ (void)lotteryClickRule:(NSDictionary *)params;

///点击：填写地址按钮
+ (void)lotteryClickAddAddress:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
