//
//  JHServiceManageBusiness.m
//  TTjianbao
//
//  Created by zk on 2021/7/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHServiceManageBusiness.h"

@implementation JHServiceManageBusiness

///获取自动回复列表
+ (void)getServiceList:(NSString *)anchorId Completion:(void(^)(NSError *_Nullable error, JHServiceManageModel *_Nullable model))completion{
    NSString *url = FILE_BASE_STRING(@"/app/chat/quickReplyAudit/queryStatus");
    NSDictionary *param = @{@"anchorId" : @([anchorId integerValue])};
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHServiceManageModel *model = [JHServiceManageModel mj_objectWithKeyValues:respondObject.data];
        if (!model || model.termsList.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        if (completion) {
            completion(nil,model);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
}

///店铺快捷回复添加
+ (void)addServiceData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion{
    NSString *url = FILE_BASE_STRING(@"/app/chat/quickReplyAudit/add");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        BOOL isSuccess = respondObject.data;
        if (completion) {
            completion(nil,isSuccess);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,NO);
        }
    }];
}

///店铺快捷回复编辑
+ (void)editServiceData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion{
    NSString *url = FILE_BASE_STRING(@"/app/chat/quickReplyAudit/update");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        BOOL isSuccess = respondObject.data;
        if (completion) {
            completion(nil,isSuccess);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,NO);
        }
    }];
}

#pragma mark -属性打印
+(void)logProperty:(NSDictionary *)dic{
    NSMutableString *proprety = [[NSMutableString alloc] init];
    //遍历数组 生成声明属性的代码，例如 @property (nonatomic, copy) NSString str
    //打印出来后 command+c command+v
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str;
        //        NSLog(@"%@",[obj class]);
        //判断的数据类型，生成相应的属性
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")] || [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) int %@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")] || [obj isKindOfClass:[NSArray class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        }
        
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")] || [obj isKindOfClass:[NSDictionary class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        }
        [proprety appendFormat:@"\n%@\n",str];
    }];
    NSLog(@"%@",proprety);
}


@end
