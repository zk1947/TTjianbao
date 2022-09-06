//
//  JHIdentificationDetailsViewModel.m
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentificationDetailsViewModel.h"
#import "JHIdentificationDetailsBusiness.h"
#import "JHIdentificationDetailsModel.h"

@interface JHIdentificationDetailsViewModel ()

@end

@implementation JHIdentificationDetailsViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    
    @weakify(self)
    [self.identDetailsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self p_identificationDetails:x];
    }];
}

- (void)p_identificationDetails:(id)data {
    
    if (data) {
        RequestModel *model = (RequestModel *)data;
        JHIdentificationDetailsModel *infoModel = [JHIdentificationDetailsModel mj_objectWithKeyValues:model.data];
        self.identetailsModel = infoModel;
        [self.identDetailsSubject sendNext:infoModel];
       
    } else {
        [self.identDetailsSubject sendNext:nil];
    }
    
}

#pragma mark - set/get

- (RACCommand *)identDetailsCommand {
    if (!_identDetailsCommand) {
        _identDetailsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [JHIdentificationDetailsBusiness requestIdentDetailWithParams:input completion:^(RequestModel * _Nonnull respondObject) {
                    [subscriber sendNext:respondObject];
                    [subscriber sendCompleted];
                    
                } fail:^(NSError * _Nonnull error) {
                    
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
            
        }
    return _identDetailsCommand;
}

- (RACSubject<JHIdentificationDetailsModel *> *)identDetailsSubject {
    if (!_identDetailsSubject) {
        _identDetailsSubject = [[RACSubject alloc] init];
    }
    return _identDetailsSubject;
}

@end
