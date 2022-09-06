//
//  JHCommunityNewListViewController.m
//  TTjianbao
//
//  Created by YJ on 2021/1/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCommunityNewListViewController.h"
#import "JHCommunityNewCell.h"
#import "TTJianBaoColor.h"
#import "JHChatModel.h"
#import "JHChatViewController.h"
#import "MBProgressHUD.h"

@interface JHCommunityNewListViewController ()<UITableViewDelegate,UITableViewDataSource> {
    int page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *modelsArray;

@end

@implementation JHCommunityNewListViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhTitleLabel.text = self.titleStr;
    self.view.backgroundColor = USELECTED_COLOR;
    [self setupMJRefresh];
    [self clearMsgNum];
}

- (void)setupMJRefresh {
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

/// 消除红点
- (void)clearMsgNum {
    if ([self.pageType isEqualToString:@"recycle_community"]) {
        /// 回收
        NSString *urlRecycle = FILE_BASE_STRING(@"/mc/app/mc/auth/msg/recycle_community");
        [HttpRequestTool getWithURL:urlRecycle Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
            NSLog("111");
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            NSLog("error");
        }];
    } else {
        /// 社区
        NSString *url = FILE_BASE_STRING(@"/mc/app/mc/auth/msg/community_official");
        [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
            NSLog("111");
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            NSLog("error");
        }];
    }
}




//获取聊天消息列表
- (void)loadNewData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    page = 1;
    self.modelsArray = [NSMutableArray new];
    
    NSString *url = @"";
    if ([self.pageType isEqualToString:@"community_official"]) {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@"),@"0",[[NSNumber numberWithInt:page] stringValue]];
    } else {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@/1"),@"0",[[NSNumber numberWithInt:page] stringValue]];
    }
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *dataArray = respondObject.data;
        if (dataArray.count > 0) {
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JHChatModel *model = [JHChatModel mj_objectWithKeyValues:obj];
                [self.modelsArray addObject:model];
            }];
            
            [self.tableView reloadData];
        }
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSLog("error");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UITipView showTipStr:respondObject.message?:@"网络请求失败"];
    }];
    
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    page = page + 1;
    NSString *url = @"";
    if ([self.pageType isEqualToString:@"community_official"]) {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@"),@"0",[[NSNumber numberWithInt:page] stringValue]];
    } else {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@/1"),@"0",[[NSNumber numberWithInt:page] stringValue]];
    }
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *dataArray = respondObject.data;
        if (dataArray.count > 0) {
            NSMutableArray *modelArr = [NSMutableArray new];
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JHChatModel *model = [JHChatModel mj_objectWithKeyValues:obj];
                [modelArr addObject:model];
            }];
            
            [self.modelsArray addObjectsFromArray:modelArr];
            
            [self.tableView reloadData];
        }
       
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSLog("error");
    }];

    [self.tableView.mj_footer endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    JHCommunityNewCell *cell = [[JHCommunityNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
        
    JHChatModel *model = self.modelsArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHChatModel *model = self.modelsArray[indexPath.row];
    JHChatViewController *vc = [[JHChatViewController alloc] init];
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    if ([model.from_user_info.code intValue] == [customerId intValue]) {
        vc.userId = model.to_user_info.code;
        vc.name = model.to_user_info.user_name;
    } else {
        vc.userId = model.from_user_info.code;
        vc.name = model.from_user_info.user_name;
    }
    vc.pageType = self.pageType;
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = USELECTED_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        @weakify(self);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
        }];
        
        _tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMoreData];
        }];
    }
    return _tableView;
}


@end
