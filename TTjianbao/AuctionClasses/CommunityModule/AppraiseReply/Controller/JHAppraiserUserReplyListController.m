//
//  JHAppraiserUserReplyListController.m
//  TTjianbao
//
//  Created by wuyd on 2020/5/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppraiserUserReplyListController.h"
#import "JHAppraiseReplyViewModel.h"
#import "JHAppraiserUserReplyListCell.h"

@interface JHAppraiserUserReplyListController ()

@property (nonatomic, strong) JHAppraiserUserReplyModel *curModel;

@end

@implementation JHAppraiserUserReplyListController

- (void)dealloc {
    NSLog(@"JHAppraiserUserReplyListController::dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _curModel = [[JHAppraiserUserReplyModel alloc] init];
    
    [self configTableView];
    
    //[self sendRequest];
}

#pragma mark -
#pragma mark - UI Methods

- (void)configTableView {
    self.tableView.rowHeight = [JHAppraiserUserReplyListCell cellHeight];
    [self.tableView registerClass:[JHAppraiserUserReplyListCell class] forCellReuseIdentifier:kCellId_JHAppraiserUserReplyListCell];
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}


#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self sendRequest];
}

- (void)endRefresh {
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
}

- (void)sendRequest {
    if (_curModel.isLoading) return;
    if (_curModel.isFirstReq && _curModel.list.count == 0) {
        [self.view beginLoading];
    }
    
    @weakify(self);
    [JHAppraiseReplyViewModel getUserReplyList:_curModel block:^(JHAppraiserUserReplyModel *  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self.view endLoading];
        [self endRefresh];
        
        if (respObj) {
            [self.curModel configModel:respObj];
            [self.tableView reloadData];
            
            if (self.curModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        
        [self.view configBlankType:YDBlankTypeNone hasData:_curModel.list.count > 0 hasError:hasError offsetY:-20 reloadBlock:^(id sender) {
            //[self refresh];
        }];
    }];
}


#pragma mark -
#pragma mark - <UITableViewDelegate & UITableViewDataSource>

- (void)scrollToTop {
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _curModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHAppraiserUserReplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHAppraiserUserReplyListCell forIndexPath:indexPath];
    JHAppraiserUserReplyData *data = _curModel.list[indexPath.row];
    cell.curData = data;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - JXCategoryListCollectionContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    NSLog(@"刷新宝友回复列表");
    [self refresh];
}

@end
