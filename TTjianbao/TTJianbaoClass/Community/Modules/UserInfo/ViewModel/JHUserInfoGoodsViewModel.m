//
//  JHUserInfoGoodsViewModel.m
//  TTjianbao
//
//  Created by hao on 2021/6/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserInfoGoodsViewModel.h"
#import "JHC2CGoodsListModel.h"

@interface JHUserInfoGoodsViewModel ()
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNo;
@end

@implementation JHUserInfoGoodsViewModel

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
    [self.userInfoGoodsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
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
    NSDictionary *dicData = model.data;
    NSArray *list = [JHC2CProductBeanListModel mj_objectArrayWithKeyValuesArray:dicData[@"productList"]];

    if (self.pageNo == 1) {
        [self.goodsListDataArray removeAllObjects];
        [self.goodsListDataArray addObjectsFromArray:list];
        
        [self.updateGoodsListSubject sendNext:@YES];
    }else{
        [self.goodsListDataArray addObjectsFromArray:list];
        [self.moreGoodsListSubject sendNext:@YES];
    }

    //数据加载完了没
    if ([model.data[@"hasMore"] boolValue]) {
        self.pageNo ++;
    }else{
        [self.noMoreDataSubject sendNext:nil];
    }

}

- (void)requestUserInfoGoodsListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/personalCenter/productList") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                completion(respondObject, nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(nil, error);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark - Lazy
- (NSMutableArray *)goodsListDataArray{
    if (!_goodsListDataArray) {
        _goodsListDataArray = [NSMutableArray array];
    }
    return _goodsListDataArray;
}

- (RACCommand *)userInfoGoodsCommand{
    if (!_userInfoGoodsCommand) {
        @weakify(self)
        _userInfoGoodsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if ([input[@"isRefresh"] boolValue]) {
                    self.pageNo = 1;
                }
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNo);
                requestDic[@"imageType"] = input[@"imageType"];
                requestDic[@"userId"] = input[@"userId"];
                [self requestUserInfoGoodsListWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _userInfoGoodsCommand;
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
