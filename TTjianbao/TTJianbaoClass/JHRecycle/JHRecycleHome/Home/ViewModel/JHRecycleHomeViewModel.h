//
//  JHRecycleHomeViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleHomeViewModel : NSObject
//楼层数据请求
@property (nonatomic, strong) RACCommand *recycleHomeCommand;

@property (nonatomic, strong) RACCommand *recycleProblemCommand;

@property (nonatomic, strong) NSArray *dataSourceArray;

@property (nonatomic, strong) RACSubject *errorRefreshSubject;

@property (nonatomic, strong) RACSubject *recycleHomeCompleteSubject;
@end

NS_ASSUME_NONNULL_END
