//
//  JHCustomerAddCommentBusiness.m
//  TTjianbao
//
//  Created by user on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerAddCommentBusiness.h"

@implementation JHCustomerAddCommentBusiness

/*
 * 添加沟通信息 - 发布
 */
+ (void)publishComment:(JHCustomerAddCommentModel *)model
         completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeComment/addComment");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(model, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

@end
