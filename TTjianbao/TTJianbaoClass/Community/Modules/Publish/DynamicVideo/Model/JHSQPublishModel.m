//
//  JHSQPublishModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPublishModel.h"

@implementation JHSQPublishCoverModel

@end

@implementation JHSQPublishModel

- (NSMutableArray *)topic
{
    if(!_topic)
    {
        _topic = [NSMutableArray new];
    }
    return _topic;
}

- (JHSQPublishCoverModel *)cover_info
{
    if(!_cover_info)
    {
        _cover_info = [JHSQPublishCoverModel new];
    }
    return _cover_info;
}

@end
