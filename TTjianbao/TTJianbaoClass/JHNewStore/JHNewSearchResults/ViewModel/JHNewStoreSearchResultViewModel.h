//
//  JHNewStoreSearchResultViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewSearchResultsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreSearchResultViewModel : NSObject
///第几个标签 0全部, 1直播, 2一口价, 3拍卖, 4店铺, 5集市
@property (nonatomic, assign) NSInteger titleTagIndex;

@property (nonatomic, strong) RACCommand *searchResultCommand;//搜索请求
@property (nonatomic, strong) JHNewSearchResultsModel *searchResultModel;
@property (nonatomic, strong) NSMutableArray *searchListDataArray;//搜索列表数据
@property (nonatomic, strong) NSMutableArray *operationDataArray;//运营位数据

@property (nonatomic, strong) RACCommand *recommendTagsCommand;//推荐标签请求
@property (nonatomic,   copy) NSArray *recommendDataArray;//推荐标签数据

@property (nonatomic, strong) RACSubject *firstSearchSubject;
@property (nonatomic, strong) RACSubject *updateSearchSubject;
@property (nonatomic, strong) RACSubject *moreSearchSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;
@property (nonatomic, strong) RACSubject *noMoreDataSubject;
@end

NS_ASSUME_NONNULL_END
