//
//  JHTopicDetailReqModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTopicDetailReqModel.h"

@implementation JHTopicDetailBaseReqModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setRequestSourceType:JHRequestHostTypeSocial];
    }
    return self;
}

- (NSString *)uriPath
{
    return @"/v2/topic/topic";
}

@end

///话题信息列表
@implementation JHTopicDetailListReqModel

- (NSString *)uriPath
{
    return @"/v2/topic/list";
}

@end

