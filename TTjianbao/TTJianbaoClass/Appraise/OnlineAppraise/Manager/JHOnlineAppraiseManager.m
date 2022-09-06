//
//  JHOnlineAppraiseManager.m
//  TTjianbao
//
//  Created by lihui on 2020/12/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseManager.h"
#import "JHOnlineAppraiseModel.h"
#import "JHOnlineAppraiseHeader.h"
#import "JHPostDetailModel.h"
#import "FileUtils.h"

@implementation JHOnlineAppraiseManager

+ (void)getOperationUserConfig:(HTTPCompleteBlock)block {
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/common/config") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject.data[@"fixed_user_id"], NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}

+ (void)getOnlineTopicListInfo:(NSString *)userId completeBlock:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/user/pubTopic/%@?from=appraise"), userId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray * topicInfo = [JHOnlineAppraiseModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (block) {
            block(topicInfo, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}


+ (void)getOnlinePostInfo:(NSString *)userId page:(NSInteger)page lastDate:(NSString *)lastDate completeBlock:(HTTPCompleteBlock)block {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v2/user/history");
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:OBJ_TO_STRING(@(page)) forKey:@"page"];
    [params setValue:lastDate forKey:@"last_date"];
    [params setValue:@2 forKey:@"type"];
    [params setValue:OBJ_TO_STRING(userId) forKey:@"user_id"];
    [params setValue:@"appraise" forKey:@"from"];
    
    [HttpRequestTool getWithURL:url Parameters:params successBlock:^(RequestModel * _Nullable respondObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray <JHPostDetailModel *>*data = [JHPostDetailModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"content_list"]];
            NSMutableArray *videoArray = [NSMutableArray array];
            for (JHPostDetailModel *model in data) {
                NSString *url = [model.videoInfo.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                if ([url isNotBlank]) {
                    [videoArray addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(videoArray, NO);
                }
            });
        });
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(nil, YES);
            }
        });
    }];
}

@end
