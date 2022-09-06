//
//  JHRecycleDetailNoticeManager.h
//  TTjianbao
//
//  Created by user on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleDetailNoticeManager : NSObject
@property (nonatomic, assign) BOOL hasNoticed;

+ (JHRecycleDetailNoticeManager *)shared;
- (void)loadRecycleDetailNotice;
- (void)saveRecycleDetailNotice:(BOOL)hasNoticed;

@end

NS_ASSUME_NONNULL_END
