//
//  JHUserAuthModel.m
//  TTjianbao
//
//  Created by lihui on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthModel.h"

@implementation JHUserAuthModel

+ (void)requestUserAuthInfo:(HTTPCompleteBlock)block {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/customer/getAuthInfo") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        JHUserAuthModel *model = [JHUserAuthModel mj_objectWithKeyValues:respondObject.data];
        if (block) {
            block(model, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}

+ (void)commitAuthInfoToServe:(JHUserAuthModel *)authModel
                completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [authModel mj_keyValues];
    [params removeObjectForKey:@"authState"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/submitAuthData") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:[respondObject.message isNotBlank] ? respondObject.message : @"提交失败，请重试"];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

+ (void)reCommitAuthInfoToServe:(JHUserAuthModel *)authModel
                  completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [authModel mj_keyValues];
    [params removeObjectForKey:@"authState"];
      
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/reSubmitAuthData") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:[respondObject.message isNotBlank] ? respondObject.message : @"提交失败，请重试"];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _authState = JHUserAuthStateUnCommit;
    }
    return self;
}

@end
