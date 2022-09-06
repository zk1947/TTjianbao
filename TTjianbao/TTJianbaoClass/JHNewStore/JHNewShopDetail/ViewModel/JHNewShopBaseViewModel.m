//
//  JHNewShopBaseViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopBaseViewModel.h"

@implementation JHNewShopBaseViewModel


- (RACSubject *)updateShopSubject{
    if(!_updateShopSubject){
        _updateShopSubject = [[RACSubject alloc] init];
    }
    return _updateShopSubject;
}
- (RACSubject *)moreShopSubject{
    if(!_moreShopSubject){
        _moreShopSubject = [[RACSubject alloc] init];
    }
    return _moreShopSubject;
}

- (RACSubject *)errorRefreshSubject{
    if (!_errorRefreshSubject) {
        _errorRefreshSubject = [[RACSubject alloc] init];
    }
    return _errorRefreshSubject;
}
- (RACSubject *)noMoreDataSubject{
    if (!_noMoreDataSubject){
        _noMoreDataSubject = [[RACSubject alloc] init];
    }
    return _noMoreDataSubject;
}

@end
