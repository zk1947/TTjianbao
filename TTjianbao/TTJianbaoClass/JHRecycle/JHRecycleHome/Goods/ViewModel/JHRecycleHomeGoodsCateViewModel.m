//
//  JHRecycleHomeGoodsCateViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeGoodsCateViewModel.h"
#import "JHRecycleHomeGoodsBusiness.h"
#import "JHRecycleHomeGoodsCateModel.h"

@implementation JHRecycleHomeGoodsCateViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    @weakify(self)
    [self.goodsCateCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            RequestModel *model = (RequestModel *)x;
            self.goodsCateDataArray = [JHRecycleHomeGoodsCateModel mj_objectArrayWithKeyValuesArray:model.data];
        }
        
    }];

}

- (RACCommand *)goodsCateCommand{
    if (!_goodsCateCommand) {
        _goodsCateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [JHRecycleHomeGoodsBusiness requestRecycleHomeGoodsCateWithParams:input Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
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
    return _goodsCateCommand;
}
@end
