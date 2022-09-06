//
//  JHFansTaskViewModel.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansTaskViewModel.h"

@implementation JHFansTaskViewModel

- (void)getFansClubInfo{
    
    [JHFansClubBusiness getFansClubInfo:self.fansClubId completion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.fansClubModel =   [JHFansClubModel mj_objectWithKeyValues:respondObject.data];
            // 刷新列表
            [self.refreshTableView sendNext:nil];
        }
        else{
            
            [JHKeyWindow makeToast:error.localizedDescription];
        }
    }];
}
- (RACReplaySubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACReplaySubject subject];
    }
    return _refreshTableView;
}
@end
