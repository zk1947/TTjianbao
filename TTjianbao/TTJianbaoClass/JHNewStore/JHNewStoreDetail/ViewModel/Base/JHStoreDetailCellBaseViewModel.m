//
//  JHStoreDetailCellViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCellBaseViewModel.h"

@implementation JHStoreDetailCellBaseViewModel

#pragma mark - Lazy
- (RACSubject *)reloadCellSubject {
    if (!_reloadCellSubject) {
        _reloadCellSubject = [RACSubject subject];
    }
    return _reloadCellSubject;
}
- (RACSubject *)pushvc {
    if (!_pushvc) {
        _pushvc = [RACSubject subject];
    }
    return _pushvc;
}
@end
