//
//  JHNimNotificationModel.m
//  TTjianbao
//
//  Created by jiang on 2019/12/9.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHNimNotificationModel.h"

@implementation JHNimNotificationModel
+ (NSDictionary*)mj_objectClassInArray
{
    return @{
                @"body" : [JHStoneMessageModel class]
             };
}
@end
