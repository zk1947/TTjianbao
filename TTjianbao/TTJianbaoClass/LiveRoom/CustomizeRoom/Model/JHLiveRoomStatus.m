//
//  JHLiveRoomStatus.m
//  TTjianbao
//
//  Created by Jesse on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomStatus.h"

@implementation JHLiveRoomStatus

+ (BOOL)isLiveRoomType:(JHLiveRoomType)type channelType:(NSString*)channelType
{
    BOOL ret = NO;
    if(!channelType)
        return ret; //传入为nil,直接返回NO
    
    switch (type)
    {
        case JHLiveRoomTypeSell:
            if([channelType isEqualToString:JHLiveRoomSell])
                ret = YES;
            break;
        
        case JHLiveRoomTypeAppraise:
            if([channelType isEqualToString:JHLiveRoomAppraise])
                ret = YES;
            break;
            
        case JHLiveRoomTypeSellHide:
            if([channelType isEqualToString:JHLiveRoomSellHide])
                ret = YES;
            break;
            
        case JHLiveRoomTypeAppraiseHide:
            if([channelType isEqualToString:JHLiveRoomAppraiseHide])
                ret = YES;
            break;
            
        default:
            break;
    }
    return ret;
}

@end
