//
//  JHMuteListViewController.m
//  TTjianbao
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMuteListViewController.h"
#import "JHMuteListCell.h"
#import "JHMuteListModel.h"


@interface JHMuteListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property(nonatomic, strong) NSIndexPath *deleteIndexPath;


@end

@implementation JHMuteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"禁言管理"];
    self.title = @"禁言管理"; //背景颜色不一致
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeUI];
}



- (void)makeUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHMuteListCell class]) bundle:nil] forCellReuseIdentifier:@"JHMuteListCell"];
        _tableView.estimatedRowHeight = 300*ScreenW/375.+50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        [_tableView.mj_header beginRefreshing];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHMuteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMuteListCell"];
    cell.model = self.dataArray[indexPath.section];
    cell.indexPath = indexPath;
    JH_WEAK(self)
    cell.openMuteBlock = ^(NSIndexPath *indexPath) {
        JH_STRONG(self)
        self.deleteIndexPath = indexPath;
        [self openMuteRequest];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = HEXCOLOR(0xf7f7f7);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - 请求数据
- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 10;
    [self requestData];
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 10;
    [self requestData];
}


- (void)requestData {
    NSDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize)};
    NSString *url = FILE_BASE_STRING(@"/room/auth/temporaryMute");
    
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        
        [self dealDataWithDic:respondObject.data];
       

        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];

    }];
    
}

- (void)endRefresh {
    


    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.tableView];
    }
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}
- (void)dealDataWithDic:(NSArray *)array {
    NSArray *arr = [JHMuteListModel mj_objectArrayWithKeyValuesArray:array];
    if (arr.count) {
        if (self.pageNo == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        }else {
            [self.dataArray addObjectsFromArray:arr];
        }
        
        [self endRefresh];

    }else {
        if (self.pageNo == 0) {
            self.dataArray = [NSMutableArray array];
        }
        [self endRefresh];

    }
    if (arr.count<self.pageSize) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.tableView reloadData];
}


- (void)deleteCell {
    [self.dataArray removeObjectAtIndex:self.deleteIndexPath.section];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.deleteIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.tableView];
    }
}

- (void)openMuteRequest {
    JHMuteListModel *model = self.dataArray[self.deleteIndexPath.section];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/temporaryMute") Parameters:@{@"viewerAccId":model.wyAccid, @"muteDuration":@(0)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
        [self deleteCell];
        [SVProgressHUD showSuccessWithStatus:@"解除禁言成功"];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}
@end
