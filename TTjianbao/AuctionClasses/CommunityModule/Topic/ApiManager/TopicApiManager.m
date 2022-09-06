//
//  TopicApiManager.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/1.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "TopicApiManager.h"
#import "CTopicModel.h"
#import "CTopicDetailModel.h"
#import "CSaleListModel.h"
#import "TTjianbaoHeader.h"

@implementation TopicApiManager


///全部话题列表页 - 获取全部话题列表（分页）
+ (void)request_topicList:(CTopicModel *)model completeBlock:(HTTPCompleteBlock)block {
    DDLogDebug(@"获取全部话题列表页");
    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        NSArray *dataList = [NSArray modelArrayWithClass:[CTopicData class] json:respondObject.data];
        if (!dataList) {
            dataList = [NSArray new];
        }
        CTopicModel *model = [[CTopicModel alloc] init];
        model.list = dataList.mutableCopy;
        block(model, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///全部话题列表页 - 搜索（分页）
+ (void)request_searchAllTopicList:(CTopicModel *)model keyword:(nullable NSString *)keyword completeBlock:(HTTPCompleteBlock)block {
    DDLogDebug(@"全部话题列表页 - 搜索");
    [HttpRequestTool getWithURL:[model toSearchUrlWithKey:keyword] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        NSArray *dataList = [NSArray modelArrayWithClass:[CTopicData class] json:respondObject.data];
        if (!dataList) {
            dataList = [NSArray new];
        }
        CTopicModel *model = [[CTopicModel alloc] init];
        model.list = dataList.mutableCopy;
        block(model, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)request_topicListWithKeyword:(nullable NSString *)keyword completeBlock:(HTTPCompleteBlock)block {
    DDLogDebug(@"搜索话题列表");
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/topic/search");
    NSDictionary *params = nil;
    if ([keyword isNotBlank]) {
        params = @{@"keyword" : keyword};
    }
    
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
        NSArray *dataList = [NSArray modelArrayWithClass:[CTopicData class] json:respondObject.data];
        CTopicModel *model = [[CTopicModel alloc] init];
        model.list = dataList.mutableCopy;
        block(model, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

//"topic/content"; // 话题主页 /{item_id}
+ (void)request_topicDetail:(CTopicDetailModel *)model completeBlock:(HTTPCompleteBlock)block {
    DDLogDebug(@"获取话题首页（详情）数据");
    if (model.isLoading) { return; }
    model.isFirstReq = NO;
    model.isLoading = YES;
    
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/topic/content/%@"), model.item_id];
    NSLog(@"topic url = %@", url);
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        model.isLoading = NO;
        CTopicDetailModel *data = [CTopicDetailModel modelWithJSON:respondObject.data];
        block(data, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

//话题首页（详情）刷新/加载更多 推荐列表
//"topic/contents/list";  /{item_id}/{last_uniq_id}/{page}
+ (void)request_topicDetailRefresh:(CTopicDetailModel *)model completeBlock:(HTTPCompleteBlock)block {
    DDLogDebug(@"话题首页（详情）刷新/加载更多 推荐列表");
    //if (model.isLoading) { return; }
    //model.isLoading = YES;
    
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/topic/contents/list/%@"),
                     [model toRefreshParams]];
    NSLog(@"topic refresh List url = %@", url);
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        //model.isLoading = NO;
        NSArray *dataList = [NSArray modelArrayWithClass:[JHDiscoverChannelCateModel class] json:respondObject.data];
        //CTopicDetailModel *model = [[CTopicDetailModel alloc] init];
        //model.contentList = dataList.mutableCopy;
        block(dataList, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        //model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)request_saleList:(CSaleListModel *)model completeBlock:(HTTPCompleteBlock)block {
    DDLogDebug(@"获取特卖列表");
    if (model.isLoading) { return; }
    model.isLoading = YES;
    model.isFirstReq = NO;
    
    //http://39.97.164.118:8080/especially/buy/:item_id/:last_id/:page
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/especially/buy/%@"), [model toParams]];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        model.isLoading = NO;
        CSaleListModel *data = [CSaleListModel modelWithJSON:respondObject.data];
        block(data, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)request_orderID:(NSString *)itemId completeBlock:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/especially/order/%@"), itemId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

@end
