//
//  JHGoodManagerSingleton.m
//  TTjianbao
//
//  Created by user on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerSingleton.h"

@implementation JHGoodManagerSingleton
+ (JHGoodManagerSingleton *)shared {
    static dispatch_once_t    once;
    static JHGoodManagerSingleton *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
        shared.putOnType = @"0";
        shared.navProductStatus = JHGoodManagerListRequestProductStatus_ALL;
    });
    return shared;
}

@end
