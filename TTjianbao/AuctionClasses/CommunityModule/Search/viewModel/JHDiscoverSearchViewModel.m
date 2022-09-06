//
//  JHDiscoverSearchViewModel.m
//  TTjianbao
//
//  Created by mac on 2019/5/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHDiscoverSearchViewModel.h"

@implementation JHDiscoverSearchViewModel
//热门话题
+ (void)getSearchKeyWordWithChannel_id:(NSInteger)channelId
                                 success:(void (^)(RequestModel *request))success
                                 failure:(void (^)(RequestModel *request))failure {
    //新增话题：修改首页搜索接口
    //NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/search/keyword/%ld"),channelId];
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/search/recommend/%ld"),channelId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

//社区关键词
+ (void)getHotKeyHordData:(HTTPCompleteBlock)block {
    NSString *url= COMMUNITY_FILE_BASE_STRING(@"/content/communityHotKeywords");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

//直播关键词
+ (void)getLiveHotKeyHordData:(HTTPCompleteBlock)block {
    NSString *url= FILE_BASE_STRING(@"/channelHotWord/find");
    [HttpRequestTool postWithURL:url Parameters:@{} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

// 特卖商城关键词
+ (void)getStoreHotKeyHordData:(HTTPCompleteBlock)block {
    
    NSString *url= COMMUNITY_FILE_BASE_STRING(@"/v1/shop/hot_words");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///获取C2C热搜词
+ (void)getC2CHotKeyHordData:(HTTPCompleteBlock)block{
    NSString *url= FILE_BASE_STRING(@"/anon/operation/ctocTopSearchList");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}







//这里没有调用的地方,暂时注释掉
//+ (void)searchInfoWithChannelId:(NSInteger)channel_id
//                              q:(NSString *)q
//                              type:(NSString *)type
//                           page:(NSInteger)page
//                              success:(void (^)(RequestModel *request))success
//                              failure:(void (^)(RequestModel *request))failure {
//    
//    NSDictionary * parameters=@{
//                                @"channel_id":@(channel_id),
//                                @"q":q,
//                                @"type":@([type intValue]),
//                                @"page":@(page)
//                                };
//    
//    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/search")  Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
//        success(respondObject);
//    } failureBlock:^(RequestModel *respondObject) {
//        
//        failure(respondObject);
//    }];
//}
@end
