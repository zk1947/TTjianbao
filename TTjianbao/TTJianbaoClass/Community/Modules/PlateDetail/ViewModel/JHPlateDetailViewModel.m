//
//  JHPlateDetailViewModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateDetailViewModel.h"

@implementation JHPlateDetailViewModel

- (void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    [JH_REQUEST asynGet:self.reqModel success:^(id respData) {
        
        if(IS_DICTIONARY(respData))
        {
            if(_detailModel)
            {
                JHPlateDetailModel *detailModel = [JHPlateDetailModel mj_objectWithKeyValues:respData];
                _detailModel.is_follow = detailModel.is_follow;
                [subscriber sendNext:@NO];
            }
            else
            {
                _detailModel = [JHPlateDetailModel mj_objectWithKeyValues:respData];
                [subscriber sendNext:@YES];
            }
        }
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
    } failure:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        [subscriber sendNext:@NO];
        [subscriber sendCompleted];
    }];
}

-(JHPlateDetailBaseReqModel *)reqModel
{
    if(!_reqModel)
    {
        _reqModel = [JHPlateDetailBaseReqModel new];
    }
    return _reqModel;
}

@end
