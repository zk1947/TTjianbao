//
//  JHC2CSearchResultViewModel.m
//  TTjianbao
//
//  Created by hao on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSearchResultViewModel.h"
#import "JHC2CSearchResultBusiness.h"

@interface JHC2CSearchResultViewModel ()
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) BOOL isRefresh;
@end

@implementation JHC2CSearchResultViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.pageSize = 20;
    self.pageNo = 1;
    
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
    self.goodsModel = [JHC2CGoodsListModel mj_objectWithKeyValues:model.data];

    if (self.isRefresh) {
        //运营位
        [self.operatingDataArray removeAllObjects];
        [self.operatingDataArray addObjectsFromArray:self.goodsModel.operationDefiniDetailsResponses];
        //商品
        [self.searchListDataArray removeAllObjects];
        [self.searchListDataArray addObjectsFromArray:self.goodsModel.productListBeanList];
        
        [self.updateGoodsListSubject sendNext:@YES];
    }else{
        [self.searchListDataArray addObjectsFromArray:self.goodsModel.productListBeanList];
        [self.moreGoodsListSubject sendNext:@YES];
    }

    //数据加载完了没
    if (self.goodsModel.productListBeanList.count > 0) {
        self.pageNo ++;
    }else{
        if (self.pageNo > 1) {
            [self.noMoreDataSubject sendNext:nil];
        }
    }

}


#pragma mark - Lazy
- (NSMutableArray *)searchListDataArray{
    if (!_searchListDataArray) {
        _searchListDataArray = [NSMutableArray array];
    }
    return _searchListDataArray;
}
- (NSMutableArray *)operatingDataArray{
    if (!_operatingDataArray) {
        _operatingDataArray = [NSMutableArray array];
    }
    return _operatingDataArray;
}

- (RACCommand *)searchResultCommand{
    if (!_searchResultCommand) {
        @weakify(self)
        _searchResultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.isRefresh = [input[@"isRefresh"] boolValue];
                if ([input[@"isRefresh"] boolValue]) {
                    self.pageNo = 1;
                }
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                [requestDic setDictionary:input];
                [requestDic removeObjectForKey:@"isRefresh"];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNo);               
                [JHC2CSearchResultBusiness requestSearchResultWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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

- (RACSubject *)updateGoodsListSubject{
    if(!_updateGoodsListSubject){
        _updateGoodsListSubject = [[RACSubject alloc] init];
    }
    return _updateGoodsListSubject;
}
- (RACSubject *)moreGoodsListSubject{
    if (!_moreGoodsListSubject) {
        _moreGoodsListSubject = [[RACSubject alloc] init];
    }
    return _moreGoodsListSubject;
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

@end
