//
//  JHRecycleHomeGoodsViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleHomeGoodsViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *goodsListDataArray;

@property (nonatomic, strong) RACCommand *updateGoodsListCommand;
@property (nonatomic, strong) RACCommand *moreGoodsListCommand;

@property (nonatomic, strong) RACSubject *updateGoodsListSubject;
@property (nonatomic, strong) RACSubject *moreGoodsListSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;
@property (nonatomic, strong) RACSubject *noMoreDataSubject;

@end

NS_ASSUME_NONNULL_END
