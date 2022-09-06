//
//  JHRecycleHomeGoodsViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeGoodsViewModel.h"
#import "JHRecycleHomeGoodsBusiness.h"
#import "JHRecycleHomeGoodsModel.h"

@interface JHRecycleHomeGoodsViewModel ()
@property (nonatomic, strong) JHRecycleHomeGoodsModel *goodsModel;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation JHRecycleHomeGoodsViewModel
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
    [self.updateGoodsListCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
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
    self.goodsModel = [JHRecycleHomeGoodsModel mj_objectWithKeyValues:model.data];
    
    if (self.isRefresh) {
        [self.goodsListDataArray removeAllObjects];
        [self.goodsListDataArray addObjectsFromArray:self.goodsModel.resultList];
        [self.updateGoodsListSubject sendNext:@YES];
    }else{
        [self.goodsListDataArray addObjectsFromArray:self.goodsModel.resultList];
        [self.moreGoodsListSubject sendNext:@YES];
    }

    //数据加载完了没
    if (self.goodsModel.hasMore) {
        self.pageNo ++;
    }else{
        if ([self.goodsModel.pages doubleValue] > 0) {
            [self.noMoreDataSubject sendNext:nil];
        }
    }

}

- (NSMutableArray *)goodsListDataArray{
    if (!_goodsListDataArray) {
        _goodsListDataArray = [NSMutableArray array];
    }
    return _goodsListDataArray;
}

- (RACCommand *)updateGoodsListCommand{
    if (!_updateGoodsListCommand) {
        @weakify(self)
        _updateGoodsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.isRefresh = [input[@"isRefresh"] boolValue];
                if ([input[@"isRefresh"] boolValue]) {
                    self.pageNo = 1;
                }
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                requestDic[@"classifyId"] = input[@"classifyId"];
                requestDic[@"imageType"] = input[@"imageType"];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNo);
                [JHRecycleHomeGoodsBusiness requestRecycleHomeGoodsListWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _updateGoodsListCommand;
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
