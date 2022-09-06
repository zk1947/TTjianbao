//
//  JHAppraiseReplyViewModel.m
//  TTjianbao
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAppraiseReplyViewModel.h"

@implementation JHAppraiseReplyViewModel

+ (void)getAppraiseChannelList:(HTTPCompleteBlock)block {
    NSString *url= COMMUNITY_FILE_BASE_STRING(@"/channel/appraiseChannelList");
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

+ (void)getAppraiseContentList:(NSInteger)is_comment
                          page:(NSInteger)page
                     channelId:(NSInteger)channelId
                       success:(void (^)(RequestModel *request))success
                       failure:(void (^)(RequestModel *request))failure {

    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/content/appraiseList/%ld/%ld/%ld"), is_comment, page, channelId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel *respondObject) {
        failure(respondObject);
    }];
}

+ (void)getUserReplyList:(JHAppraiserUserReplyModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取宝友回复列表数据");
    if (model.isLoading) {return;}
    model.isLoading = YES;
    model.isFirstReq = NO;
    
    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        //JHShopWindowListModel *aModel = [JHShopWindowListModel modelWithJSON:respondObject.data];
        NSArray *dataList = [NSArray modelArrayWithClass:[JHAppraiserUserReplyData class] json:respondObject.data];
        JHAppraiserUserReplyModel *aModel = [[JHAppraiserUserReplyModel alloc] init];
        aModel.list = dataList.mutableCopy;
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

@end
