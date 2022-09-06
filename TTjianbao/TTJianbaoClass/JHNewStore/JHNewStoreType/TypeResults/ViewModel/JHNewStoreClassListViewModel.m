//
//  JHNewStoreClassListViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreClassListViewModel.h"
#import "JHNewStoreClassListBusiness.h"

@interface JHNewStoreClassListViewModel ()
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, strong) NSMutableArray *productIdArray;
@end

@implementation JHNewStoreClassListViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.pageSize = 20;
    self.pageNum = 1;
    @weakify(self)
    [self.searchResultCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self constructData:x];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
        
    }];

}

- (void)constructData:(id)data{
    RequestModel *model = (RequestModel *)data;
    self.goodsModel = [JHNewStoreClassListModel mj_objectWithKeyValues:model.data];

    if (self.isRefresh) {
        [self.searchListDataArray removeAllObjects];
        [self.searchListDataArray addObjectsFromArray:self.goodsModel.productList];
        [self.updateSearchSubject sendNext:@YES];
    }else{
        [self.searchListDataArray addObjectsFromArray:self.goodsModel.productList];
        [self jhNewSearchResultViewExposure:self.goodsModel.productList];
        [self.moreSearchSubject sendNext:@YES];
    }

    //数据加载完了没
    if (self.goodsModel.productList.count > 0) {
        self.pageNum ++;
    }else{
        if (self.pageNum > 1) {
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

- (RACCommand *)searchResultCommand{
    if (!_searchResultCommand) {
        @weakify(self)
        _searchResultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            self.keyword = input[@"queryWord"];
            self.isRefresh = [input[@"isRefresh"] boolValue];
            if (self.isRefresh) {
                self.pageNum = 1;
            }
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                [requestDic setDictionary:input];
                [requestDic removeObjectForKey:@"isRefresh"];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNum);
                [JHNewStoreClassListBusiness requestProductClassResultWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
