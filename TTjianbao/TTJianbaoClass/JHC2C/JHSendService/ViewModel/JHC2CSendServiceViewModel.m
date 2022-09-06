//
//  JHC2CSendServiceViewModel.m
//  TTjianbao
//
//  Created by hao on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSendServiceViewModel.h"
#import "JHC2CSendServiceBusiness.h"
#import "JHC2CSendServiceModel.h"

@interface JHC2CSendServiceViewModel ()

@end

@implementation JHC2CSendServiceViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    @weakify(self)
    //上门取件
    [self.pickupCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            RequestModel *model = (RequestModel *)x;
            JHC2CSendServiceModel *pickupModel = [JHC2CSendServiceModel mj_objectWithKeyValues:model.data];
            [self.pickupSubject sendNext:pickupModel];
        }
    }];
    
    //提交预约信息
    [self.appointmentSubmitCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.appointmentSubmitSubject sendNext:@YES];
        }
    }];
    
    //填写快递单号-获取快递logo
    [self.writeOrderCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            RequestModel *model = (RequestModel *)x;
            [self.writeOrderSubject sendNext:model.data];
        }
    }];
    //填写快递单号-取消寄件
    [self.cancelMailingCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.cancelMailingSubject sendNext:@YES];
        }
    }];
    //填写快递单号-确认邮寄
    [self.confirmMailingCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.confirmMailingSubject sendNext:@YES];
        }
    }];
    
    //自助寄出
    [self.selfMailingCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            RequestModel *model = (RequestModel *)x;
            JHC2CSendServiceModel *selfMailingeModel = [JHC2CSendServiceModel mj_objectWithKeyValues:model.data];
            [self.selfMailingSubject sendNext:selfMailingeModel];
        }
    }];
    
    //确认自助寄出
    [self.confirmSelfMailingCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self.confirmSelfMailingSubject sendNext:@YES];
        }
    }];

}


//上门取件
- (RACCommand *)pickupCommand{
    if (!_pickupCommand) {
        _pickupCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [JHC2CSendServiceBusiness requestPickupWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error) {
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
    return _pickupCommand;
}
//提交预约
- (RACCommand *)appointmentSubmitCommand{
    if (!_appointmentSubmitCommand) {
        _appointmentSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
                [JHC2CSendServiceBusiness requestPickupAppointmentSubmitWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _appointmentSubmitCommand;
}
//填写快递单号获取快递logo
- (RACCommand *)writeOrderCommand{
    if (!_writeOrderCommand) {
        _writeOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
                [JHC2CSendServiceBusiness requestWriteOrderGetExpressInfoWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _writeOrderCommand;
}
//填写快递单号-取消寄件
- (RACCommand *)cancelMailingCommand{
    if (!_cancelMailingCommand) {
        _cancelMailingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
                [JHC2CSendServiceBusiness requestWriteOrderCancelMailingWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _cancelMailingCommand;
}
//填写快递单号-确认邮寄
- (RACCommand *)confirmMailingCommand{
    if (!_confirmMailingCommand) {
        _confirmMailingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
                [JHC2CSendServiceBusiness requestWriteOrderConfirmMailingWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _confirmMailingCommand;
}

//自助邮寄
- (RACCommand *)selfMailingCommand{
    if (!_selfMailingCommand) {
        _selfMailingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [JHC2CSendServiceBusiness requestSelfMailingWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error) {
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
    return _selfMailingCommand;
}
//确认自助邮寄
- (RACCommand *)confirmSelfMailingCommand{
    if (!_confirmSelfMailingCommand) {
        _confirmSelfMailingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [JHC2CSendServiceBusiness requestConfirmSelfMailingWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error) {
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
    return _confirmSelfMailingCommand;
}

- (RACSubject *)pickupSubject{
    if (!_pickupSubject) {
        _pickupSubject = [[RACSubject alloc] init];
    }
    return _pickupSubject;
}
- (RACSubject *)appointmentSubmitSubject{
    if (!_appointmentSubmitSubject) {
        _appointmentSubmitSubject = [[RACSubject alloc] init];
    }
    return _appointmentSubmitSubject;
}
- (RACSubject *)writeOrderSubject{
    if (!_writeOrderSubject) {
        _writeOrderSubject = [[RACSubject alloc] init];
    }
    return _writeOrderSubject;
}
- (RACSubject *)cancelMailingSubject{
    if (!_cancelMailingSubject) {
        _cancelMailingSubject = [[RACSubject alloc] init];
    }
    return _cancelMailingSubject;
}
- (RACSubject *)confirmMailingSubject{
    if (!_confirmMailingSubject) {
        _confirmMailingSubject = [[RACSubject alloc] init];
    }
    return _confirmMailingSubject;
}
- (RACSubject *)selfMailingSubject{
    if (!_selfMailingSubject) {
        _selfMailingSubject = [[RACSubject alloc] init];
    }
    return _selfMailingSubject;
}
- (RACSubject *)confirmSelfMailingSubject{
    if (!_confirmSelfMailingSubject) {
        _confirmSelfMailingSubject = [[RACSubject alloc] init];
    }
    return _confirmSelfMailingSubject;
}

@end
