//
//  JHBaseViewModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface JHBaseViewModel : NSObject

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL isNoMoreData;


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) RACCommand *requestCommand;

- (void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber;


@end

NS_ASSUME_NONNULL_END
