//
//  JHMyResaleListModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyResaleListModel.h"

@implementation JHMyResaleListModel

@end

@implementation JHMyResaleListReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageIndex = 0;
        self.pageSize = 10; //初始化默认值
    }
    
    return self;
}

- (NSString *)uriPath
{
    return @"/app/stone-restore/list-my-sale";
}
@end

@implementation JHCancelResaleReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/cancel";
}

+ (void)requestCancelWithStoneId:(NSString*)mid channelId:(NSString*)channelId channelCategory:(NSString*)channelCategory fail:(JHFailure)failre
{
    JHCancelResaleReqModel* model = [JHCancelResaleReqModel new];
    model.stoneRestoreId = mid;
    model.channelId = channelId;//个人中心无需传直播间ID
    model.channelCategory = channelCategory;

    [JH_REQUEST asynPost:model success:^(id respData) {
        
        failre([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        failre(errorMsg);
    }];
}

@end

