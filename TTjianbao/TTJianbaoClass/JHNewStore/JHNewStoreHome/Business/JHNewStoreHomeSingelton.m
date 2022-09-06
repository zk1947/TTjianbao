//
//  JHNewStoreHomeSingelton.m
//  TTjianbao
//
//  Created by user on 2021/3/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeSingelton.h"

@implementation JHNewStoreHomeSingelton
+ (JHNewStoreHomeSingelton *)shared {
    NSAssert([JHNewStoreHomeSingelton class] == self, @"Incorrect use of singleton : %@, %@", [JHNewStoreHomeSingelton class], [self class]);
    static dispatch_once_t    once;
    static JHNewStoreHomeSingelton *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

@end
