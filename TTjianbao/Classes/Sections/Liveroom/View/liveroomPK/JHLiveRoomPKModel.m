//
//  JHLiveRoomPKModel.m
//  TTjianbao
//
//  Created by apple on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomPKModel.h"
#import "JHRequestManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation JHLiveRoomPKUserModel

@end

@implementation JHLiveRoomPKInfoModel

@end

@implementation JHLiveRoomPKModel

+ (void)requestEditDetailWithId:(NSString *)channelId successBlock:(void(^)(RequestModel * _Nonnull reqModel))succBlock failBlock:(void(^)(RequestModel * _Nonnull reqModel))failBlock{
    //FILE_BASE_STRING(@"/activity/api/rank/v2/list")
    //@"http://172.17.214.69:9090/mock/12/activity/api/rank/v2/list"  @"a3e4abdd800f4b018fe3b6f4a30b5c54"
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/activity/api/rank/v2/list") Parameters:@{@"channelId":channelId} successBlock:^(RequestModel * _Nullable respondObject) {
        succBlock(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failBlock(respondObject);
    }];
    
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"channel":@"JHLiveRoomPKInfoModel",
        @"summaryRanking":@"JHLiveRoomPKInfoModel",
        @"increaseRanking":@"JHLiveRoomPKInfoModel",
        @"fansRanking":@"JHLiveRoomPKInfoModel"
    };
}

@end

@implementation JHLiveRoomPKCategoryModel
+ (void)requestPKCategory:(NSString *)channelId successBlock:(void(^)(NSString * _Nonnull category,NSString * _Nonnull rankName))succBlock{
    //FILE_BASE_STRING(@"/activity/api/rank/v2/category")
    //@"http://172.17.214.69:9090/mock/12/activity/api/rank/v2/category"   @"a3e4abdd800f4b018fe3b6f4a30b5c54"
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/activity/api/rank/v2/category") Parameters:@{@"channelId":channelId} successBlock:^(RequestModel * _Nullable respondObject) {
        JHLiveRoomPKCategoryModel * model = [JHLiveRoomPKCategoryModel mj_objectWithKeyValues:respondObject.data];
        succBlock(model.category,model.rankName);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
@end
