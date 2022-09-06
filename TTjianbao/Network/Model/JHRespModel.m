//
//  JHRespModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"

@implementation JHNetworkResponse

- (instancetype)init
{
    if(self = [super init])
    {
        self.code = kNetworkResponseCodeSuccess;
    }
    return self;
}

@end

@implementation JHRespModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.code = kNetworkResponseCodeSuccess;
    }
    return self;
}

+ (id)convertData:(id)data
{
    if([data isKindOfClass:[NSArray class]])
        return [self mj_objectArrayWithKeyValuesArray:data];
    return [self mj_objectWithKeyValues:data];//默认是字典
}

+ (NSString*)nullMessage
{
    return nil;
}

@end
