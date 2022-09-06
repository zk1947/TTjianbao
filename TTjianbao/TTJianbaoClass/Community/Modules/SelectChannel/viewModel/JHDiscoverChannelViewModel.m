//
//  JHDiscoverChannelViewModel.m
//  TTjianbao
//
//  Created by mac on 2019/5/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHDiscoverChannelViewModel.h"
#import "JHAPPAsyncConfigManager.h"

@implementation JHDiscoverChannelViewModel

+ (void)getChannelListWithSuccess:(void (^)(RequestModel *request))success
                          failure:(void (^)(RequestModel *request))failure {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/channel/allChannelList");
    NSLog(@"lastUpdateTime = %ld", (long)[JHAPPAsyncConfigManager shareInstance].curChannleVerModel.data);
    [HttpRequestTool getWithURL:url Parameters:@{@"channel_last_update_time":@([JHAPPAsyncConfigManager shareInstance].curChannleVerModel.data)} successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

+ (void)submitChannelWithIds:(NSString *)channelIds
                     success:(void (^)(RequestModel *request))success
                     failure:(void (^)(RequestModel *request))failure {
    //点击直播按钮
    NSDictionary * parameters=@{
                                @"channel_ids":[channelIds stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                                };
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/channel/select")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        
        success(respondObject);
        
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

+ (void)getSelectedChannelListWithSuccess:(void (^)(RequestModel *request))success
                                  failure:(void (^)(RequestModel *request))failure {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/channel/selectList?");
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

//获取频道分类列表
+ (void)getChannelCateListWithChannel_id:(NSInteger)channelId
                               direction:(NSString *)direction
                                 last_id:(NSString *)last_id
                                    page:(NSInteger)page
                                 success:(void (^)(RequestModel *request))success
                                 failure:(void (^)(RequestModel *request))failure {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/content/list?channel_id=%ld&direction=%@&last_id=%@&page=%ld"),channelId, direction, last_id , page];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

+ (void)deleteRecommentUserWithItem_type:(NSInteger)item_type
                                 item_id:(NSString *)item_id
                              entry_type:(NSInteger)entry_type
                                entry_id:(NSString *)entry_id
                              success:(void (^)(RequestModel *request))success
                              failure:(void (^)(RequestModel *request))failure {
    ///auth/user/notLikeRecommendUser/
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/user/notLike/%ld/%@/%ld/%@"), item_type, item_id, entry_type, entry_id];
    
    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        
        success(respondObject);
        
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

//关注用户
+ (void)focusRecommentUserWithUserId:(NSString *)user_id
                          fans_count:(NSInteger)fans_count
                             success:(void (^)(RequestModel *request))success
                             failure:(void (^)(RequestModel *request))failure {
    
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/follow/%@/%ld"), user_id, fans_count];
    
    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        
        success(respondObject);
        
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

//取消关注
+ (void)cancleFocusRecommentUserWithUserId:(NSString *)user_id
                                fans_count:(NSInteger)fans_count
                                   success:(void (^)(RequestModel *request))success
                                   failure:(void (^)(RequestModel *request))failure {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/follow/%@/%ld"), user_id, fans_count];
    
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

+ (void)likeItemWithItemid:(NSString *)item_id
                 item_type:(NSInteger)item_type
             itemLikeCount:(NSInteger)item_like_count
                   success:(void (^)(RequestModel *request))success
                   failure:(void (^)(RequestModel *request))failure {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/like/%ld/%@/%ld"), item_type, item_id, item_like_count];
    [Growing track:@"like" withVariable:@{@"value":@(1)}];
    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        
        success(respondObject);
        
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

+ (void)cancleLikeItemWithItemid:(NSString *)item_id
                       item_type:(NSInteger)item_type
                   itemLikeCount:(NSInteger)item_like_count
                         success:(void (^)(RequestModel *request))success
                         failure:(void (^)(RequestModel *request))failure {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/like/%ld/%@/%ld"), item_type, item_id, item_like_count];
    [Growing track:@"like" withVariable:@{@"value":@(0)}];
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

//删除帖子
+ (void)deleteContentWithItemId:(NSString *)item_id
                       itemType:(NSInteger)item_type
                        success:(void (^)(RequestModel *request))success
                        failure:(void (^)(RequestModel *request))failure {
    
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/content/%ld/%@"), item_type, item_id];
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

///获取推荐头部话题列表的数据
+ (void)getHotTopicList:(succeedBlock)success failure:(failureBlock)failure {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/topic/recommend");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

+ (void)getFollowStatus:(void (^)(RequestModel *request))success
                          failure:(void (^)(RequestModel *request))failure {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/content/getFollowRecommendTag");

    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

@end
