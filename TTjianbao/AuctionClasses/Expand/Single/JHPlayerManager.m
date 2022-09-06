//
//  JHPlayerManager.m
//  TaodangpuAuction
//
//  Created by jiang on 2019/9/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPlayerManager.h"
static JHPlayerManager *instance;
@interface JHPlayerManager ()

@end

@implementation JHPlayerManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHPlayerManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
