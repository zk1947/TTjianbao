//
//  JHStoreDetailCycleViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 轮播图 ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCycleItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCycleViewModel : NSObject
@property (nonatomic, strong) NSMutableArray<JHStoreDetailCycleItemViewModel *> *itemList;
@property (nonatomic, strong) RACReplaySubject *refreshView;
@property (nonatomic, strong) NSArray<NSString *> *thumbsUrls;
@property (nonatomic, strong) NSArray<NSString *> *mediumUrls;
@property (nonatomic, strong) NSArray<NSString *> *largeUrls;

@end

NS_ASSUME_NONNULL_END
