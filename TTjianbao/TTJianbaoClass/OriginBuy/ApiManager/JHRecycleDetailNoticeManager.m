//
//  JHRecycleDetailNoticeManager.m
//  TTjianbao
//
//  Created by user on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleDetailNoticeManager.h"

@implementation JHRecycleDetailNoticeManager
+ (JHRecycleDetailNoticeManager *)shared {
    static dispatch_once_t    once;
    static JHRecycleDetailNoticeManager *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
        shared.hasNoticed = NO;
    });
    return shared;
}

- (void)loadRecycleDetailNotice {
    [JHRecycleDetailNoticeManager shared].hasNoticed = [[NSUserDefaults standardUserDefaults] boolForKey:@"jh_recyle_detail_hasNotice"];
}


- (void)saveRecycleDetailNotice:(BOOL)hasNoticed {
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    [dataUser setObject:@(hasNoticed) forKey:@"jh_recyle_detail_hasNotice"];
    [dataUser synchronize];
}









@end
