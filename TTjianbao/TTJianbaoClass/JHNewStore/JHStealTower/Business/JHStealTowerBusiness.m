//
//  JHStealTowerBusiness.m
//  TTjianbao
//
//  Created by zk on 2021/8/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStealTowerBusiness.h"

@implementation JHStealTowerBusiness

+ (void)loadStealTowerListData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHStealTowerModel *model))completion{
    NSString *url = FILE_BASE_STRING(@"/api/mall/stealing/tower/page/query");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHStealTowerModel *model = [JHStealTowerModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {
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
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}

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
