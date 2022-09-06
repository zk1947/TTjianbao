//
//  JHLiveRoomApiManger.m
//  TTjianbao
//
//  Created by lihui on 2020/7/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomApiManger.h"
#import "JHLiveRoomModel.h"
#import "YYKit/YYKit.h"
#import "JHAuthorize.h"
@implementation JHLiveRoomApiManger

#pragma mark -
#pragma mark -  直播间介绍相关

+ (void)getLiveRoomInfo:(NSString *)channelLocalId
          completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:channelLocalId forKey:@"channelLocalId"];
    NSString *url= FILE_BASE_STRING(@"/app/opt/channel/find-anchor-detail");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHLiveRoomModel *model = [JHLiveRoomModel modelWithDictionary:respondObject.data];
        model.channelLocalId = channelLocalId;
        if (block) {
            block(model, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

+ (void)deleteAnchorInfo:(NSString *)broadId
           completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:broadId forKey:@"broadId"];
    NSString *url= FILE_BASE_STRING(@"/app/channel/dummy-anchor/delete");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message?:@"删除失败"];
        if (block) {
            block(respondObject, YES);
        }
    }];
}


+ (void)deleteLiveRoomInfo:(NSString *)channelLocalId
             completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:channelLocalId forKey:@"channelLocalId"];
    NSString *url= FILE_BASE_STRING(@"/app/channel/introduction/delete");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message?:@"删除失败"];
        if (block) {
            block(respondObject, YES);
        }
    }];
}


+ (void)follow:(NSString *)anchorId
   currentStatus:(NSInteger)status
   completeBlock:(HTTPCompleteBlock)block {
    
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":anchorId,@"status":@(status)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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

///修改主播的直播状态
+ (void)modifyLivingState:(NSString *)broadId
                liveState:(NSString *)liveState
           completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:broadId forKey:@"broadId"];
    [params setValue:liveState forKey:@"liveState"];
    NSString *url= FILE_BASE_STRING(@"/app/opt/channel/dummy-anchor/change-status");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message?:@"修改失败"];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

@end
