//
//  JHChatCustomTipModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatCustomTipModel.h"

@implementation JHChatCustomTipModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = JHChatCustomTypeTip;
    }
    return self;
}
- (NSString *)encodeAttachment
{
    return [self mj_JSONString];
}
@end

@implementation JHChatCustomTipInfo



@end
