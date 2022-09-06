//
//  JHCustomizeOrderApiManager.m
//  TTjianbao
//
//  Created by jiangchao on 2020/11/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderApiManager.h"
#import "UserInfoRequestManager.h"

@implementation JHCustomizeOrderApiManager
+ (void)requestCustomizeOrderDetail:(NSString *)orderId isSeller:(BOOL)isSeller Completion:(void(^)(NSError *error, JHCustomizeOrderModel* orderModel))completion{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString * type;
    if (isSeller) {
        type=user.isAssistant?@"10":@"1";
    }
    else{
        type=@"0";
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/orderDetail") Parameters:@{@"orderId":orderId,@"userType":type} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHCustomizeOrderModel * mode = [JHCustomizeOrderModel mj_objectWithKeyValues:respondObject.data];
        NSError *error=nil;
        if (completion) {
            completion(error,mode);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
            completion(error,nil);
        }
    }];
}

+ (void)requestCustomizeLogistics:(NSString *)orderId
                         userType:(NSString *)userType
                       Completion:(nonnull void (^)(NSError * _Nullable, NSArray<JHCustomizeLogisticsFinalModel *> * _Nullable))completion {
    NSDictionary *dict = @{
        @"orderId":NONNULL_STR(orderId),
        @"userType":NONNULL_STR(userType)
    };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/queryOrderExpress") Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHCustomizeLogisticsModel *mode = [JHCustomizeLogisticsModel mj_objectWithKeyValues:respondObject.data];
        if (mode) {
            NSArray<JHCustomizeLogisticsFinalModel *> *array = [JHCustomizeLogisticsFinalModel setViewModelImpl:mode];
            if (completion) {
                completion(nil, array);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
}





@end
