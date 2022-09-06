//
//  JHRecyclePickupViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePickupViewModel.h"
#import "JHRecyclePickupBusiness.h"
#import "JHRecyclePickupModel.h"

@interface JHRecyclePickupViewModel ()

@end

@implementation JHRecyclePickupViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    
    @weakify(self)
    //未预约信息
    [self.goToAppointmentCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {//成功
            RequestModel *model = (RequestModel *)x;
            JHRecyclePickupGoToAppointmentModel *goToAppointmentModel = [JHRecyclePickupGoToAppointmentModel mj_objectWithKeyValues:model.data];
        
            [self.goToAppointmentSubject sendNext:goToAppointmentModel];
        }
    }];
    //提交预约信息
    [self.appointmentSubmitCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {//成功
            [self.appointmentSubmitSubject sendNext:@YES];
        }
    }];
    
    //已预约信息
    [self.appointmentSuccessCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            RequestModel *model = (RequestModel *)x;
            JHRecyclePickupAppointmentSuccessModel *appointmentSuccessModel = [JHRecyclePickupAppointmentSuccessModel mj_objectWithKeyValues:model.data];
            [self.appointSuccessSubject sendNext:appointmentSuccessModel];
        }
    }];

}



- (RACCommand *)goToAppointmentCommand{
    if (!_goToAppointmentCommand) {
        _goToAppointmentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                [JHRecyclePickupBusiness requestRecyclePickupGoToAppointmentWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _goToAppointmentCommand;
}
- (RACCommand *)appointmentSubmitCommand{
    if (!_appointmentSubmitCommand) {
        _appointmentSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
                [JHRecyclePickupBusiness requestRecyclePickupAppointmentSubmitWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
- (RACCommand *)appointmentSuccessCommand{
    if (!_appointmentSuccessCommand) {
        _appointmentSuccessCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
                [JHRecyclePickupBusiness requestRecyclePickupAppointmentSuccessWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _appointmentSuccessCommand;
}

- (RACSubject *)goToAppointmentSubject{
    if(!_goToAppointmentSubject){
        _goToAppointmentSubject = [[RACSubject alloc] init];
    }
    return _goToAppointmentSubject;
}
- (RACSubject *)appointmentSubmitSubject{
    if(!_appointmentSubmitSubject){
        _appointmentSubmitSubject = [[RACSubject alloc] init];
    }
    return _appointmentSubmitSubject;
}
- (RACSubject *)appointSuccessSubject{
    if(!_appointSuccessSubject){
        _appointSuccessSubject = [[RACSubject alloc] init];
    }
    return _appointSuccessSubject;
}

@end
