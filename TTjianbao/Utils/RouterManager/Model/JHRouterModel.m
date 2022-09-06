//
//  JHRouterModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRouterModel.h"

@implementation JHRouterModel

- (NSString *)recordComponentName {
    NSString *name = self.vc ?: self.componentName;
    if ([self.componentName isEqualToString:@"JHWebViewController"] || [self.vc isEqualToString:@"JHWebViewController"]) {
        name = self.params[@"urlString"];
    }
    return name;
}

+ (id)convertData:(id)data
{
    if([data isKindOfClass:[NSArray class]])
        return [self mj_objectArrayWithKeyValuesArray:data];
    return [self mj_objectWithKeyValues:data];//默认是字典
}

@end
