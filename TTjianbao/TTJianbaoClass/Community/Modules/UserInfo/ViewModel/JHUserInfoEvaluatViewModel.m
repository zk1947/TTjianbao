//
//  JHUserInfoEvaluatViewModel.m
//  TTjianbao
//
//  Created by hao on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserInfoEvaluatViewModel.h"
#import "JHUserInfoEvaluateModel.h"

@interface JHUserInfoEvaluatViewModel()
@property (nonatomic, strong) JHUserInfoEvaluateModel *evaluateModel;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNo;
@end

@implementation JHUserInfoEvaluatViewModel
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
    [self.userInfoEvaluatCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
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
    self.evaluateModel = [JHUserInfoEvaluateModel mj_objectWithKeyValues:model.data];
    if (self.pageNo == 1) {
        [self.evaluatListDataArray removeAllObjects];
        [self.evaluatListDataArray addObjectsFromArray:self.evaluateModel.resultList];
        
        [self.updateEvaluatListSubject sendNext:@YES];
    }else{
        [self.evaluatListDataArray addObjectsFromArray:self.evaluateModel.resultList];
        [self.moreEvaluatListSubject sendNext:@YES];
    }

    //数据加载完了没
    if (self.evaluateModel.hasMore) {
        self.pageNo ++;
    }else{
        [self.noMoreDataSubject sendNext:nil];
    }

}

- (void)requestUserInfoCommentListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/commentList") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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
- (NSMutableArray *)evaluatListDataArray{
    if (!_evaluatListDataArray) {
        _evaluatListDataArray = [NSMutableArray array];
    }
    return _evaluatListDataArray;
}

- (RACCommand *)userInfoEvaluatCommand{
    if (!_userInfoEvaluatCommand) {
        @weakify(self)
        _userInfoEvaluatCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if ([input[@"isRefresh"] boolValue]) {
                    self.pageNo = 1;
                }
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNo);
                requestDic[@"imageType"] = input[@"imageType"];
                requestDic[@"customerId"] = input[@"customerId"];
                [self requestUserInfoCommentListWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _userInfoEvaluatCommand;
}

- (RACSubject *)updateEvaluatListSubject{
    if(!_updateEvaluatListSubject){
        _updateEvaluatListSubject = [[RACSubject alloc] init];
    }
    return _updateEvaluatListSubject;
}
- (RACSubject *)moreEvaluatListSubject{
    if (!_moreEvaluatListSubject) {
        _moreEvaluatListSubject = [[RACSubject alloc] init];
    }
    return _moreEvaluatListSubject;
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
