//
//  JHNimNotificationBody.m
//  TTjianbao
//
//  Created by jiang on 2019/12/9.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHNimNotificationBody.h"

#define kMsgTypeStoneResell @"stoneResale"

@implementation JHNimNotificationBody

//个人(原石)转售
- (BOOL)stoneResellMsgType
{
    if([self.msgType isEqualToString: kMsgTypeStoneResell])
    {
        return YES;
    }
    return NO;
}
@end
