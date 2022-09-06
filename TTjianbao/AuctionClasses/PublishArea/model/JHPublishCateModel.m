//
//  JHPublishCateModel.m
//  TTjianbao
//
//  Created by apple on 2019/7/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPublishCateModel.h"

@implementation JHPublishChannelModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"items":[JHPublishCateModel class]};
}
+ (void)requestPublishCatelist:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/content/cateList") Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        completion(respondObject,error);
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
    
    
}
+ (void)requestSearchCatelist:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/cate_list") Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        completion(respondObject,error);
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}
@end

@implementation JHPublishCateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"cateId" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"items":[JHPublishSubCateModel class]};
}

@end

@implementation JHPublishSubCateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"subCateId" : @"id"};
}

- (void)setImage:(NSString *)image {
    //url中文转码
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
