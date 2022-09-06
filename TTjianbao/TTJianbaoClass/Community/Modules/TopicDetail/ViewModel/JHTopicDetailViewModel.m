//
//  JHTopicDetailViewModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTopicDetailViewModel.h"

@implementation JHTopicDetailViewModel

- (void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    [JH_REQUEST asynGet:self.reqModel success:^(id respData) {
        if(IS_DICTIONARY(respData))
        {
            _detailModel = [JHTopicDetailModel mj_objectWithKeyValues:respData];
        }
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        [subscriber sendNext:@NO];
        [subscriber sendCompleted];
    }];
}

-(JHTopicDetailBaseReqModel *)reqModel
{
    if(!_reqModel)
    {
        _reqModel = [JHTopicDetailBaseReqModel new];
    }
    return _reqModel;
}
@end
