//
//  JHNewShopHotSellViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopHotSellViewModel.h"
#import "JHNewShopDetailBusiness.h"
#import <SVProgressHUD.h>

@interface JHNewShopHotSellViewModel ()
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation JHNewShopHotSellViewModel

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
    [self.shopHotSellGoodCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
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
    if (self.isRefresh) {
        [self.hotSellDataArray removeAllObjects];
        self.hotSellDataArray = [JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:model.data];
        //刷新列表
        [self.updateShopSubject sendNext:@YES];
    }else{
        NSMutableArray * listDataArr = [JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:model.data];
        [self.hotSellDataArray addObjectsFromArray:listDataArr];
        //刷新列表
        [self.moreShopSubject sendNext:@YES];
    }
    
    //数据加载完了没
    if ([JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:model.data].count > 0) {
        self.pageNum ++;
    }else{
        if (self.pageNum > 1) {
            [self.noMoreDataSubject sendNext:nil];
        }
    }

}

#pragma mark - Lazy

    
- (NSMutableArray *)hotSellDataArray{
    if (!_hotSellDataArray) {
        _hotSellDataArray = [NSMutableArray array];
    }
    return _hotSellDataArray;
}
- (RACCommand *)shopHotSellGoodCommand{
    if (!_shopHotSellGoodCommand) {
        @weakify(self)
        _shopHotSellGoodCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.isRefresh = [input[@"isRefresh"] boolValue];
                if (self.isRefresh) {
                    self.pageNum = 1;
                }
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                [requestDic setDictionary:input];
                [requestDic removeObjectForKey:@"isRefresh"];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNum);
                [JHNewShopDetailBusiness requestShopProductListWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _shopHotSellGoodCommand;
}

@end
