//
//  JHFansRequestManager.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansRequestManager.h"

@implementation JHFansRequestManager
//加入粉丝团
+ (void)joinFansClubAction:(NSString *)fansId
                 completeBlock:(HTTPCompleteBlock)block {
    NSDictionary * parame = @{@"fansClubId":fansId};
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/fans/fans-exp/joinClub")  Parameters:parame requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
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

/// 获取粉丝权益
///
+ (void)getFansEquityInfoWithAnchorId : (NSString *)anchorId
                            successBlock:(succeedBlock) success
                            failureBlock:(failureBlock)failure {
    NSDictionary *par = @{@"anchorId" : anchorId};
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-reward/list");
    [HttpRequestTool getWithURL:url Parameters:par successBlock:^(RequestModel * _Nullable respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
@end
