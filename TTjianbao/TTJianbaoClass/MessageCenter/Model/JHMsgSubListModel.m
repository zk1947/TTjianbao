//
//  JHMsgSubListModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListModel.h"

@implementation JHMsgSubListModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"target" : [JHRouterModel class]};
}
@end

@implementation JHMsgSubListShowModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.groupArray = [NSMutableArray array];
    }
    return self;
}
@end

@implementation JHMsgSubListReqModel
{
    NSString* subPath;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageNo = 0;
        self.pageSize = 10;
    }
    return self;
}

//需要重写啊
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@%@",kMessageCenterReqPathPrefix, subPath];
}

- (void)setRequestSubpath:(NSString*)type
{
    subPath = type;
}

@end

 //社区互动消息-点赞列表-清除
@implementation JHMsgSubListClearLikeModel
- (NSString *)uriPath
{//@"/mc/app/mc/auth/msg/like"
    return [NSString stringWithFormat:@"%@like",kMessageCenterReqPathPrefix];
}
@end

 //社区互动消息-评论列表-清除
@implementation JHMsgSubListClearCommentModel
- (NSString *)uriPath
{//@"/mc/app/mc/auth/msg/comment"
    return [NSString stringWithFormat:@"%@comment",kMessageCenterReqPathPrefix];
}
@end
