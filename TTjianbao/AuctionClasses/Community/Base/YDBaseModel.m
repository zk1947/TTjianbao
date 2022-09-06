//
//  YDYDBaseModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/1.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseModel.h"

@implementation YDBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFirstReq = YES;
        _isLoading = NO;
        _canLoadMore = NO;
        _willLoadMore = NO;
        _page = 1; //默认从1开始
    }
    return self;
}

@end

