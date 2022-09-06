//
//  JHStoneOfferModel.m
//  TTjianbao
//
//  Created by jiang on 2019/12/5.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneOfferModel.h"

@implementation JHStoneOfferModel
+ (void)requestStoneOfferDetail:(NSString *)stoneRestoreId  isResaleFlag:(BOOL)resaleFlag completion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-restore-offer/offer-load") Parameters:@{@"stoneRestoreId":stoneRestoreId,@"resaleFlag":resaleFlag?@"1":@"0"} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)requestOffer:(JHGoodOrderSaveReqModel *)stoneMode completion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone/order/save") Parameters:[stoneMode paramsDict] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}
@end

@implementation JHStoneIntentionInfoModel
@end
