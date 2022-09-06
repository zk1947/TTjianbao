//
//  JHFansListViewModel.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansListViewModel.h"

@interface JHFansListViewModel ()

@end

@implementation JHFansListViewModel
- (void)getFansListInfo{
    
    [JHFansClubBusiness getFansList:self.anchorId pageNo:self.pageNo pageSize:self.pageSize completion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            NSArray *arr = [JHFansModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"records"]];
            if (self.pageNo == 1) {
                self.listArr = [NSMutableArray arrayWithCapacity:10];
            }
            [self.listArr addObjectsFromArray:arr];
                    // 刷新列表
            [self.refreshTableView sendNext:nil];
            
        }
        else{
            
            [JHKeyWindow makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter];
        }
    }];
}
//- (void)handleDataWithArr:(NSArray *)array {
//    NSArray *arr = [OrderMode mj_objectArrayWithKeyValuesArray:array];
//    if (PageNum == 0) {
//        self.orderModes = [NSMutableArray arrayWithCapacity:10];
//    }
//    //    else {
//    //        [self.orderModes addObjectsFromArray:arr];
//    //    }
//    for (OrderMode *mode in arr) {
//        mode.isSeller=self.isSeller;
//        [self.orderModes addObject:mode];
//
//    }
//    self.collectionView.mj_footer.hidden=NO;
//
//    if (self.orderModes.count==0) {
//        showDefaultImage=YES;
//    }
//    else{
//        showDefaultImage=NO;
//    }
//    if (arr.count<pagesize) {
//        if (self.isSeller) {
//            self.collectionView.mj_footer.hidden=YES;
//        }
//        else{
//            isSection0End=YES;
//            _pageNumber=1;
//            [self requestProductInfo];
//        }
//    }
//    [self.collectionView reloadData];
//}
- (void)getFansHeaderInfo{
    
    [JHFansClubBusiness getFansClubTitle:self.anchorId completion:^(RequestModel *respondObject, NSError *error) {
        
        if (!error) {
            self.fansClubModel =   [JHFansClubModel mj_objectWithKeyValues:respondObject.data];
            // 刷新列表
            [self.refreshHeaderView sendNext:nil];
        }
    }];
}
- (RACReplaySubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACReplaySubject subject];
    }
    return _refreshTableView;
}

- (RACReplaySubject *)refreshHeaderView {
    if (!_refreshHeaderView) {
        _refreshHeaderView = [RACReplaySubject subject];
    }
    return _refreshHeaderView;
}
@end
