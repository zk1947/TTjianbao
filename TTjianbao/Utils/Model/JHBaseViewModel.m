//
//  JHBaseViewModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"

@implementation JHBaseViewModel

-(RACCommand *)requestCommand
{
    
    if (!_requestCommand) {
        @weakify(self);
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self requestCommonDataWithSubscriber:subscriber];
                return nil;
            }];
            
        }];
    }
    return _requestCommand;
}

- (void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


@end


//RAC(self.homeTable,reloadData) = RACObserve(_viewModel,dataArray.count);
//
//RACChannelTo(self.homeTable,reloadData) = RACChannelTo(_viewModel,dataArray);
//
//[RACObserve(_viewModel, dataArray) subscribeNext:^(id  _Nullable x) {
//
//}];
