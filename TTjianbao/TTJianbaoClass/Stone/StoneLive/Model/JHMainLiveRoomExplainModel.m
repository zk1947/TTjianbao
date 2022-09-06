//
//  JHMainLiveRoomExplainModel.m
//  TTjianbao
//
//  Created by Jesse on 4/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMainLiveRoomExplainModel.h"

@implementation JHMainLiveRoomExplainModel

- (void)asynRequestWithResponse:(JHResponse)response
{
    [JH_REQUEST asynPost:self success:^(id respData) {
        if(response)
        {
            response(respData, [JHRespModel nullMessage]);
        }
    } failure:^(NSString *errorMsg) {
        if(response)
        {
            response([JHRespModel nullMessage], errorMsg);
        }
    }];
}

///主播-开始讲解/停止讲解
- (NSString *)uriPath
{
    return @"/app/stone-restore/stone-explain-opt";
}
@end
