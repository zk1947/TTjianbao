//
//  UserFriendApiManager.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UserFriendApiManager.h"
#import "CUserFriendModel.h"

@implementation UserFriendApiManager

+ (void)request_userFriendList:(CUserFriendModel *)model completeBlock:(HTTPCompleteBlock)block {
    DDLogDebug(@"获取关注/粉丝列表");
    if (model.isLoading) { return; }
    model.isLoading = YES;
    
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/user/list/%@"),
                     [model toParams]];
    NSLog(@"topic refresh List url = %@", url);
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        model.isLoading = NO;
        NSArray *dataList = [NSArray modelArrayWithClass:[CUserFriendData class] json:respondObject.data];
        CUserFriendModel *aModel = [[CUserFriendModel alloc] init];
        aModel.list = dataList.mutableCopy;
        block(aModel, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

//关注 post
+ (void)followWithUserId:(NSInteger)userId fansCount:(NSInteger)fansCount completeBlock:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/follow/%ld/%ld"), (long)userId, (long)fansCount];
    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

//取消关注 delete
+ (void)cancelFollowWithUserId:(NSInteger)userId fansCount:(NSInteger)fansCount completeBlock:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/follow/%ld/%ld"), (long)userId, (long)fansCount];
    
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        block(respondObject, NO);
    } failureBlock:^(RequestModel *respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
    
}

@end
