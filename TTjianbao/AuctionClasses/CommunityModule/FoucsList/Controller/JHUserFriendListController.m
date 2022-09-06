//
//  JHUserFriendListController.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UserInfoRequestManager.h"
#import "JHUserFriendListController.h"
#import "CUserFriendModel.h"
#import "UserFriendApiManager.h"
#import "JHUserFriendListCell.h"
#import "UserFriendApiManager.h"
#import "JHGemmologistViewController.h"
#import "UIScrollView+JHEmpty.h"
#import "JHCustomerInfoController.h"

@interface JHUserFriendListController ()

@property (nonatomic, strong) CUserFriendModel *curModel;

@end

@implementation JHUserFriendListController

#pragma mark -
#pragma mark - Life Cycle

- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 2 && self.user_id == 0) {
        self.user_id = [[UserInfoRequestManager sharedInstance].user.customerId integerValue];
        self.name = [UserInfoRequestManager sharedInstance].user.name;
    }
//    self.naviBar.leftImage = kNavBackBlackImg;
    [self showNaviBar];
    self.naviBar.titleLabel.text = self.name;
    _curModel = [[CUserFriendModel alloc] init];
    _curModel.user_id = self.user_id;
    _curModel.pageIndex = _type;
    
    [self configTableView];
    [self.refreshHeader beginRefreshing];
}

#pragma mark -
#pragma mark - 发起网络请求

- (void)refresh {
    if(self.updateNumberBlock){
        self.updateNumberBlock();
    }
    if (_curModel.isLoading) { return; }
    _curModel.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    if (_curModel.isLoading || !_curModel.canLoadMore) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    if (_curModel.isLoading) return;
    
    @weakify(self);
    [UserFriendApiManager request_userFriendList:_curModel completeBlock:^(CUserFriendModel *respObj, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        
        if (respObj) {
            [self.curModel configModel:respObj];
            [self.tableView jh_reloadDataWithEmputyView];
            
            if (self.curModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark -
#pragma mark - <UITableView Methods>

- (void)configTableView {
    self.tableView.rowHeight = [JHUserFriendListCell cellHeight];
    [self.tableView registerClass:[JHUserFriendListCell class] forCellReuseIdentifier:kCellId_JHUserFriendListCell];
    self.tableView.backgroundColor = RGB(248, 248, 248);
    if(self.type == 2){
        [[UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self.view]
         mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.tableView);
        }];

        self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
//        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
//        }];
    }
    else
    {
        [self.naviBar removeFromSuperview];
    }
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
}

#pragma mark -
#pragma mark - <UITableViewDelegate & UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _curModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHUserFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHUserFriendListCell forIndexPath:indexPath];
    CUserFriendData *data = _curModel.list[indexPath.row];
    cell.curData = data;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CUserFriendData *data = _curModel.list[indexPath.row];
    
    if (data.is_ban > 0) {
        return;
    }
    
    if (data.role == 1) {
        //鉴定师
        JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
        vc.anchorId = [NSString stringWithFormat:@"%ld", (long)data.user_id];
        @weakify(self);
        vc.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
            @strongify(self);
            [self updateFollowStatusWithUserId:[anchorId integerValue] isFollow:isFollow];
        };
        [self.navigationController pushViewController:vc animated:YES];
    
    }
//    else if (data.role == 9) { // 定制师主页
//        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
//        vc.channelLocalId = [NSString stringWithFormat:@"%ld", (long)data.user_id];
//        vc.fromSource = @"businessliveplay";
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else {
        @weakify(self);
        [JHRootController enterUserInfoPage:@(data.user_id).stringValue from:@"" resultBlock:^(NSString * _Nonnull userId, BOOL isFollow) {
            @strongify(self);
            [self updateFollowStatusWithUserId:[userId integerValue] isFollow:isFollow];
        }];
    }
    
    if (self.didPushBlock) {
        self.didPushBlock();
    }
}

#pragma mark - 更新关注状态
- (void)updateFollowStatusWithUserId:(NSInteger)userId isFollow:(BOOL)isFollow {
    @weakify(self);
    [_curModel.list enumerateObjectsUsingBlock:^(CUserFriendData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.user_id == userId) {
            @strongify(self);
            obj.is_follow = isFollow;
            [self.tableView reloadData];
            *stop = YES;
        }
    }];
}


@end
