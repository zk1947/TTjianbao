//
//  JHNewShopClassResultViewModel.m
//  TTjianbao
//
//  Created by hao on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopClassResultViewModel.h"
#import "JHNewShopDetailBusiness.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>

@interface JHNewShopClassResultViewModel()
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation JHNewShopClassResultViewModel

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
    [self.shopClassResultCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
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
        [self.classResultDataArray removeAllObjects];
        self.classResultDataArray = [JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:model.data];
        //刷新列表
        [self.updateShopSubject sendNext:@YES];
    }else{
        NSMutableArray * listDataArr = [JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:model.data];
        [self.classResultDataArray addObjectsFromArray:listDataArr];
        //刷新列表
        [self.moreShopSubject sendNext:@YES];
    }
    
    //数据加载完了没
    if ([JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:model.data].count > 0) {
        self.pageNo ++;
    }else{
        if (self.pageNo > 1) {
            [self.noMoreDataSubject sendNext:nil];
        }
    }

}

#pragma mark - Lazy

    
- (NSMutableArray *)classResultDataArray{
    if (!_classResultDataArray) {
        _classResultDataArray = [NSMutableArray array];
    }
    return _classResultDataArray;
}
- (RACCommand *)shopClassResultCommand{
    if (!_shopClassResultCommand) {
        @weakify(self)
        _shopClassResultCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.isRefresh = [input[@"isRefresh"] boolValue];
                if (self.isRefresh) {
                    self.pageNo = 1;
                }
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                requestDic[@"shopId"] = input[@"shopId"];
                requestDic[@"sort"] = input[@"sort"];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNo);
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
    return _shopClassResultCommand;
}

@end
