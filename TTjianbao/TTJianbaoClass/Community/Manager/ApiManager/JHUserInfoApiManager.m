//
//  JHUserInfoApiManager.m
//  TTjianbao
//
//  Created by lihui on 2020/6/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoApiManager.h"
#import "JHSQModel.h"
#import "JHUserInfoCommentModel.h"

@implementation JHUserInfoApiManager

//获取个人中心信息
+ (void)homePageWithUserId:(NSString *)user_id
                   success:(void (^)(RequestModel *request))success
                   failure:(void (^)(RequestModel *request))failure {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/user/homePage/%@"), user_id];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

//关注用户
+ (void)followUserAction:(NSString *)userId
                     fansCount:(NSInteger)fansCount
                 completeBlock:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/follow/%@/%ld"), userId, fansCount];
    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///取消关注用户
+ (void)cancelFollowUserAction:(NSString *)userId
                 fansCount:(NSInteger)fansCount
             completeBlock:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/follow/%@/%ld"), userId, fansCount];
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

+ (void)getUserHistoryStasticsWithUserId:(NSString *)userId
                           CompleteBlock:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/user/history?type=0&user_id=%@"), userId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

+ (void)getUserHistory:(JHPersonalInfoType)type
                UserId:(NSString *)userId
                  Page:(NSInteger)page
                  LastId:(NSString *)lastId
         CompleteBlock:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/user/history?type=%ld&user_id=%@&page=%ld&last_id=%@"), (long)type, userId, (long)page, lastId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///点赞
+ (void)sendCommentLikeRequest:(NSInteger)itemType
                        itemId:(NSString *)itemId
                       likeNum:(NSInteger)likeNum
                         block:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/like/%ld/%@/%ld"),
                    (long)itemType, itemId, (long)likeNum];
//    [Growing track:@"like" withVariable:@{@"value":@(1)}];
    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

///取消点赞
    
+ (void)sendCommentUnLikeRequest:(NSInteger)itemType
                          itemId:(NSString *)itemId
                         likeNum:(NSInteger)likeNum
                           block:(HTTPCompleteBlock)block {

    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/like/%ld/%@/%ld"),
                    (long)itemType, itemId, (long)likeNum];
//    [Growing track:@"like" withVariable:@{@"value":@(0)}];
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        //block(nil, YES); //不用返回了
    }];
}




@end
