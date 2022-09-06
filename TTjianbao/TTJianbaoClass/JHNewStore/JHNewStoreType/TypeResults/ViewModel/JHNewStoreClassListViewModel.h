//
//  JHNewStoreClassListViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreHomeModel.h"
#import "JHNewStoreClassListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreClassListViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *searchListDataArray;
@property (nonatomic, strong) RACCommand *searchResultCommand;
@property (nonatomic, strong) JHNewStoreClassListModel *goodsModel;

@property (nonatomic, strong) RACSubject *firstSearchSubject;
@property (nonatomic, strong) RACSubject *updateSearchSubject;
@property (nonatomic, strong) RACSubject *moreSearchSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;
@property (nonatomic, strong) RACSubject *noMoreDataSubject;
@end

NS_ASSUME_NONNULL_END
