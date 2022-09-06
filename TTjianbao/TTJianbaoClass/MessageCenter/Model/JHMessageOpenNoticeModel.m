//
//  JHMessageOpenNoticeModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageOpenNoticeModel.h"

@implementation JHMessageOpenNoticeModel

+ (NSMutableArray*)dataArray
{
    NSMutableArray* array = [NSMutableArray array];
    
    JHMessageOpenNoticeModel* discount = [JHMessageOpenNoticeModel new];
    discount.image = @"img_msg_notice_discount";
    discount.title = @"优惠活动信息";
    discount.desc = @"每月最少节约1888元";
    [array addObject:discount];
    
    JHMessageOpenNoticeModel* friends = [JHMessageOpenNoticeModel new];
    friends.image = @"img_msg_notice_interact";
    friends.title = @"宝友互动消息";
    friends.desc = @"及时了解宝友回复信息";
    [array addObject:friends];
    
    JHMessageOpenNoticeModel* transport = [JHMessageOpenNoticeModel new];
    transport.image = @"img_msg_notice_transport";
    transport.title = @"物流发货通知";
    transport.desc = @"及时了解物流状态";
    [array addObject:transport];
    
    return array;
}

@end
