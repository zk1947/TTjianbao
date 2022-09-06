//
//  JHPublishEditModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishEditModel.h"
#import <SVProgressHUD.h>

@implementation JHPublishEditSourceModel

@end

@implementation JHPublishEditModel

+ (void)getPublishModelWithStoneId:(NSString *)stoneId completeBlock:(nonnull void (^)(JHPublishEditModel * _Nonnull))completeBlock {
    NSString *urlStr = FILE_BASE_STRING(@"/anon/stone/resale/find-detail");
    [HttpRequestTool postWithURL:urlStr Parameters:@{@"stoneResaleId" : stoneId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if(respondObject.code == 1000){
            if(IS_DICTIONARY(respondObject.data) && completeBlock){
                JHPublishEditModel *model = [JHPublishEditModel mj_objectWithKeyValues:respondObject.data];
                if(model){
                    completeBlock(model);
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"imgList" : [JHPublishEditSourceModel class],
              @"videoList" : [JHPublishEditSourceModel class]
            };
}

@end
