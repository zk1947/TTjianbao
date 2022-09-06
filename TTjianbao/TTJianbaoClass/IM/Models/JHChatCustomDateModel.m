//
//  JHChatDateModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatCustomDateModel.h"

@implementation JHChatCustomDateModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = JHChatCustomTypeDate;
    }
    return self;
}
- (NSString *)encodeAttachment
{
    return [self mj_JSONString];
}
@end

@implementation JHChatCustomDateInfo

@end
