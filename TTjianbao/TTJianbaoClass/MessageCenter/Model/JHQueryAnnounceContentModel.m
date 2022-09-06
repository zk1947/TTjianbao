//
//  JHQueryAnnounceContentModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHQueryAnnounceContentModel.h"
#import "JHMessageHeader.h"

@implementation JHQueryAnnounceContentModel

@end

@implementation JHQueryAnnounceContentReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.isAppendHtml = 0;
    }
    return self;
}

- (NSString *)uriPath
{//app/mc/auth/msg/announce/content
    return [NSString stringWithFormat:@"%@announce/content",kMessageCenterReqPathPrefix];
}
@end
