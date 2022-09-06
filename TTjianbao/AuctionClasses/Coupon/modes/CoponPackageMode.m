//
//  CoponPackageMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/3/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CoponPackageMode.h"

@implementation CoponPackageMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             };
}
@end

@implementation CoponMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             };
}
+ (void)requestEnableUsedSeller:(NSString *)coponId completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/coupon/canUseSellers/auth") Parameters:@{@"couponDetailId":coponId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
    
}
@end


@implementation CoponCountMode
@end
