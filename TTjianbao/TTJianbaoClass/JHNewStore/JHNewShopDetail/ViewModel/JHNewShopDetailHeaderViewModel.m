//
//  JHNewShopDetailHeaderViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailHeaderViewModel.h"
#import "JHNewShopDetailBusiness.h"

@interface JHNewShopDetailHeaderViewModel ()
@end

@implementation JHNewShopDetailHeaderViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    @weakify(self)
    [self.shopDetailInfoCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            RequestModel *model = (RequestModel *)x;
            self.shopDetailInfoModel = [JHNewShopDetailInfoModel mj_objectWithKeyValues:model.data];
            [self.updateShopInfoSubject sendNext:nil];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
    }];
    
    [self.followShopCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.followShopSubject sendNext:nil];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
    }];
    
    [self.getCouponsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.getCouponsSubject sendNext:nil];
            [self.getCouponsSubject sendCompleted];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
    }];
    
    
}


- (RACCommand *)shopDetailInfoCommand
{
    if(!_shopDetailInfoCommand){
        _shopDetailInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                [JHNewShopDetailBusiness requestShopDetailInfoWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error) {
                        [subscriber sendNext:respondObject];
                    }else{
                        JHTOAST(error.localizedDescription);
                        [subscriber sendNext:nil];
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _shopDetailInfoCommand;
}

- (RACCommand *)followShopCommand{
    if (!_followShopCommand) {
        _followShopCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {

            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [JHNewShopDetailBusiness requestShopFollowWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:@YES];
                    }else{
                        JHTOAST(error.localizedDescription);
                        [subscriber sendNext:@NO];
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _followShopCommand;
}

- (RACCommand *)getCouponsCommand{
    if (!_getCouponsCommand) {
        _getCouponsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [JHNewShopDetailBusiness requestShopGetCouponsWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:@YES];
                    }else{
                        JHTOAST(error.localizedDescription);
                        [subscriber sendNext:@NO];
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _getCouponsCommand;
}

- (RACSubject *)updateShopInfoSubject{
    if(!_updateShopInfoSubject){
        _updateShopInfoSubject = [[RACSubject alloc] init];
    }
    return _updateShopInfoSubject;
}
- (RACSubject *)followShopSubject{
    if(!_followShopSubject){
        _followShopSubject = [[RACSubject alloc] init];
    }
    return _followShopSubject;
}
- (RACSubject *)getCouponsSubject{
    if(!_getCouponsSubject){
        _getCouponsSubject = [[RACSubject alloc] init];
    }
    return _getCouponsSubject;
}
- (RACSubject *)errorRefreshSubject{
    if (!_errorRefreshSubject) {
        _errorRefreshSubject = [[RACSubject alloc] init];
    }
    return _errorRefreshSubject;
}

@end
