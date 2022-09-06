//
//  JHHomeActivityMode.m
//  TTjianbao
//
//  Created by jiang on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHHomeActivityMode.h"
@implementation JHHomeActivityInfoMode

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"target" : @"iosTarget",

             };
}

@end
@implementation JHHomeTipMode

@end
@implementation JHHomeActivityMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"padageComerId" : @"newComerId",
             };
}

@end

@implementation LiveRoomTip

@end
