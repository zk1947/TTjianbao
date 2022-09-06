//
//  GrowingManager+Lottery.m
//  TTjianbao
//
//  Created by wuyd on 2020/8/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "GrowingManager+Lottery.h"

@implementation GrowingManager (Lottery)

///tab切换（首个页面也要统计）
+ (void)lotterySwitchTab:(NSDictionary *)params {
    [Growing track:@"freelottery_tab_switch" withVariable:params];
}

///页面进入事件：{"from" : "h5 / freeLotteryHome / freeLotteryHistory"} - h5，0元抽首页，0元抽往期历史
+ (void)lotteryEnterPageName:(NSString *)pageName from:(NSString *)from {
    [Growing track:@"page_create" withVariable:@{@"from" : from,
                                                 @"page_name" : pageName
    }];
}

///tab页面浏览时长
+ (void)lotteryBrowseDuration:(NSDictionary *)params {
    [Growing track:@"freelottery_tab_page_browse" withVariable:params];
}

///点击：点击0元参与抽奖按钮
+ (void)lotteryClickJoin:(NSDictionary *)params {
    [Growing track:@"freelottery_join_click" withVariable:params];
}

///点击：首页直接点击立即分享按钮
+ (void)lotteryClickShare:(NSDictionary *)params {
    [Growing track:@"freelottery_item_share_click" withVariable:params];
}

///点击：在提示分享弹框上点立即分享按钮
+ (void)lotteryClickDialogShare:(NSDictionary *)params {
    [Growing track:@"freelottery_dialog_share_click" withVariable:params];
}

///点击：开启/关闭提醒按钮
+ (void)lotteryClickRemind:(NSDictionary *)params {
    [Growing track:@"freelottery_remind_switch" withVariable:params];
}

///点击：点击0元抽奖规则按钮
+ (void)lotteryClickRule:(NSDictionary *)params {
    [Growing track:@"freelottery_rule_click" withVariable:params];
}

///点击：填写地址按钮
+ (void)lotteryClickAddAddress:(NSDictionary *)params {
    [Growing track:@"freelottery_write_address_click" withVariable:params];
}

@end
