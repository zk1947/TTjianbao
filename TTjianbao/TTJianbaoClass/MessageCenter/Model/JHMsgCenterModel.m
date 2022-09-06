//
//  JHMsgCenterModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgCenterModel.h"

@implementation JHMsgCenterSyncReqModel

- (NSString *)uriPath
{//@"/mc//app/mc/auth/msg/sync"
    return [NSString stringWithFormat:@"%@sync",kMessageCenterReqPathPrefix];
}
@end

@implementation JHMsgCenterReqModel 

- (NSString *)uriPath
{//@"/mc/app/mc/auth/msg/total"
    return [NSString stringWithFormat:@"%@total",kMessageCenterReqPathPrefix];
}
@end

@implementation JHMsgCenterRemoveReqModel

- (NSString *)uriPath
{//@"/mc/app/mc/auth/msg/total/remove"
    return [NSString stringWithFormat:@"%@total/remove",kMessageCenterReqPathPrefix];
}
@end

@implementation JHMsgCenterUnreadReqModel

- (NSString *)uriPath
{//@"/app/mc/auth/msg/unread/count"
    return [NSString stringWithFormat:@"%@unread/count",kMessageCenterReqPathPrefix];
}
@end

@implementation JHMsgCenterModel

@end

@implementation JHMsgCenterSubUnreadModel

@end

@implementation JHMsgCenterUnreadModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"typeCounts": [JHMsgCenterSubUnreadModel class]
    };
}
@end

