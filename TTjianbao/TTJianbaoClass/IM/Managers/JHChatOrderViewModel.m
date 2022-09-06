//
//  JHChatOrderViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatOrderViewModel.h"
#import "JHChatBusiness.h"



@interface JHChatOrderViewModel()
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *receiveAccount;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger currentPage;
@end
@implementation JHChatOrderViewModel
#pragma mark - Init
- (instancetype)initWithAccount : (NSString *)account receiveAccount : (NSString *)receiveAccount {
    self = [super init];
    if (self) {
        self.account = account;
        self.receiveAccount = receiveAccount;
        [self setupViewModel];
        self.currentPage = 1;
        [self requestOrderInfo : self.currentPage];
    }
    return self;
}
- (void)loadNewData {
    [self.dataSource removeAllObjects];
    [self requestOrderInfo : 1];
}
- (void)loadNextPageData {
    if ([self hasNextPage] == false) {
        [self.endRefreshing sendNext:nil];
        return;
    }
    NSInteger pageno = [self getNextPageNo];
    [self requestOrderInfo:pageno];
}
- (BOOL)hasNextPage {
    return self.total - (PageSize * self.currentPage) > 0;
}
- (NSInteger)getNextPageNo {
    return self.currentPage += 1;
}
- (void)setupViewModel {
    
}
- (void)requestOrderInfo : (NSInteger)pageNo {
    
    [JHChatBusiness getOrderInfoWithAccount:self.account
                             receiveAccount:self.receiveAccount
                                     pageNo:pageNo
                               successBlock:^(JHChatOrderInfoListModel * _Nonnull respondObject)
    {
        self.total = respondObject.total;
        [self.dataSource appendObjects:respondObject.orderInfos];
        [self.reloadData sendNext:nil];
        [self.endRefreshing sendNext:nil];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.toast sendNext:respondObject.message];
        [self.endRefreshing sendNext:nil];
    }];
}
#pragma mark - LAZY
- (NSMutableArray<JHChatOrderInfoModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (RACReplaySubject *)reloadData {
    if (!_reloadData) {
        _reloadData = [RACReplaySubject subject];
    }
    return _reloadData;
}
- (RACSubject<NSString *> *)toast {
    if (!_toast) {
        _toast = [RACSubject subject];
    }
    return _toast;
}
- (RACSubject *)endRefreshing {
    if (!_endRefreshing) {
        _endRefreshing = [RACSubject subject];
    }
    return _endRefreshing;
}
@end
