//
//  JHMyCompeteViewModel.m
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteViewModel.h"
#import "JHMyCompeteResultBusiness.h"
#import "JHMyCompeteModel.h"

@interface JHMyCompeteViewModel ()

@end

@implementation JHMyCompeteViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
   
    @weakify(self)
    [self.myCompeteCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self p_myCompeteThedata:x];
    }];
}

- (void)p_myCompeteThedata:(id)data {
    JHMyCompeteSubjectState subjectState;
    if (data) {
        RequestModel *model = (RequestModel *)data;
        self.myCompeteDataArray = [JHMyAuctionListItemModel mj_objectArrayWithKeyValuesArray:model.data];
        subjectState = JHMyCompeteSubject_Update;
    } else {
        subjectState = JHMyCompeteSubject_ErrorRefresh;
    }
    [self.myCompeteSubject sendNext:@(subjectState)];
   
}

#pragma mark - set/get

- (RACCommand *)myCompeteCommand {
    if (!_myCompeteCommand) {
        _myCompeteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [JHMyCompeteResultBusiness requestMyCompeteWithParams:input completion:^(RequestModel * _Nonnull respondObject) {
                    [subscriber sendNext:respondObject];
                    [subscriber sendCompleted];
                } fail:^(NSError * _Nonnull error) {
                    JHTOAST(error.localizedDescription);
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
            
        }
    return _myCompeteCommand;
}

- (RACSubject<NSNumber *> *)myCompeteSubject
{
    if (!_myCompeteSubject) {
        _myCompeteSubject = [[RACSubject alloc] init];
    }
    return _myCompeteSubject;
}

+ (void)reLoadMyAcutionStatus:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHMyAuctionListItemModel *model))completion{
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/b2c/auction/record/refresh");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        //JHNewStoreHomeGoodsProductListModel
        JHMyAuctionListItemModel *model = [JHMyAuctionListItemModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        if (completion) {
            completion(nil,model);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}

@end
