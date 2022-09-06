//
//  JHNewStoreSearchResultViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSearchResultViewModel.h"
#import "JHNewStoreSearchResultBusiness.h"
#import "JHNewSearchResultsModel.h"
#import "JHNewSearchResultRecommendTagsModel.h"

@interface JHNewStoreSearchResultViewModel ()
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic,   copy) NSString *keyword;
@property (nonatomic, strong) NSMutableArray *productIdArray;
@end

@implementation JHNewStoreSearchResultViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.pageSize = 20;
    self.pageNum = 0;
    @weakify(self)
    [self.searchResultCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self constructData:x];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
        
    }];
    
    [self.recommendTagsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            RequestModel *model = (RequestModel *)x;
            JHNewSearchResultRecommendTagsModel *recommendModel = [JHNewSearchResultRecommendTagsModel mj_objectWithKeyValues:model.data];
            self.recommendDataArray = recommendModel.keyTagList;
        }
    }];

}

- (void)constructData:(id)data{
    RequestModel *model = (RequestModel *)data;
    JHNewSearchResultsModel *searchResultModel = [JHNewSearchResultsModel mj_objectWithKeyValues:model.data];
    self.searchResultModel = searchResultModel;
    if (self.isRefresh) {
        [self.searchListDataArray removeAllObjects];
        [self.operationDataArray removeAllObjects];
        //运营位
        [self.operationDataArray addObjectsFromArray:searchResultModel.operationPositionList];
        [self.searchListDataArray addObjectsFromArray:searchResultModel.liveList];
        [self.searchListDataArray addObjectsFromArray:searchResultModel.productList];
        
        [self.updateSearchSubject sendNext:@YES];
    }else{
        [self.searchListDataArray addObjectsFromArray:searchResultModel.liveList];
        [self.searchListDataArray addObjectsFromArray:searchResultModel.productList];
        
        [self.moreSearchSubject sendNext:@YES];
    }

    //数据加载完了没
    if (searchResultModel.liveList.count > 0 || searchResultModel.productList.count > 0) {
        self.pageNum ++;
    }else{
        if (self.pageNum > 0) {
            [self.noMoreDataSubject sendNext:nil];
        }
    }

}

///曝光
- (void)jhNewSearchResultViewExposure:(NSArray *)dataList{
    for (JHNewStoreHomeGoodsProductListModel *dataModel in dataList) {
        [self.productIdArray addObject:[NSString stringWithFormat:@"%ld",dataModel.productId]];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"searchResultView" params:@{
        @"key_word":self.keyword,
        @"item_ids":[self.productIdArray componentsJoinedByString:@","]
    } type:JHStatisticsTypeSensors];
    
    [self.productIdArray removeAllObjects];

}

#pragma mark - Lazy

- (NSMutableArray *)searchListDataArray{
    if (!_searchListDataArray) {
        _searchListDataArray = [NSMutableArray array];
    }
    return _searchListDataArray;
}

- (NSMutableArray *)operationDataArray{
    if (!_operationDataArray) {
        _operationDataArray = [NSMutableArray array];
    }
    return _operationDataArray;
}

- (RACCommand *)searchResultCommand{
    if (!_searchResultCommand) {
        @weakify(self)
        _searchResultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            self.keyword = input[@"queryWord"];
            self.isRefresh = [input[@"isRefresh"] boolValue];
            if (self.isRefresh) {
                self.pageNum = 0;
            }
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                [requestDic setDictionary:input];
                [requestDic removeObjectForKey:@"isRefresh"];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNum);
                [JHNewStoreSearchResultBusiness requestProductSearchWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                        JHTOAST(error.localizedDescription);
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _searchResultCommand;
}
- (RACCommand *)recommendTagsCommand{
    if (!_recommendTagsCommand) {
        _recommendTagsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                [JHNewStoreSearchResultBusiness requestRecommendTagsListWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                    }
                    [subscriber sendCompleted];
                    
                }];
                
                return nil;
            }];
        }];
    }
    return _recommendTagsCommand;
}

- (RACSubject *)updateSearchSubject{
    if(!_updateSearchSubject){
        _updateSearchSubject = [[RACSubject alloc] init];
    }
    return _updateSearchSubject;
}
- (RACSubject *)moreSearchSubject{
    if (!_moreSearchSubject) {
        _moreSearchSubject = [[RACSubject alloc] init];
    }
    return _moreSearchSubject;
}
- (RACSubject *)errorRefreshSubject{
    if (!_errorRefreshSubject) {
        _errorRefreshSubject = [[RACSubject alloc] init];
    }
    return _errorRefreshSubject;
}
- (RACSubject *)noMoreDataSubject{
    if (!_noMoreDataSubject){
        _noMoreDataSubject = [[RACSubject alloc] init];
    }
    return _noMoreDataSubject;
}
- (NSMutableArray *)productIdArray{
    if (!_productIdArray) {
        _productIdArray = [NSMutableArray array];
    }
    return _productIdArray;
}
@end
