//
//  JHCoinRecordViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHCoinRecordViewController.h"
#import "JHPresentRecordCell.h"
#import "JHRechargeRecordCell.h"
#import "DBManager.h"


@interface JHCoinRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger roleType;

@end

@implementation JHCoinRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    User *user = [[DBManager getInstance] select_userTable_info];
    self.roleType = user.type;
    
//    [self  initToolsBar];
//    
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeUI];
    //[self loadData];
    
    switch (self.type) {
        case 0:
//            [self.navbar setTitle:@"鉴豆记录"];
            self.title = @"鉴豆记录"; // //背景颜色不一致
            break;

        case 1:
//            [self.navbar setTitle:@"送出的礼物"];
            self.title = @"送出的礼物";
            break;

        case 2:
//            [self.navbar setTitle:@"收到的打赏"];
            self.title = @"收到的打赏";
            break;

        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHPresentRecordCell class]) bundle:nil] forCellReuseIdentifier:@"JHPresentRecordCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHRechargeRecordCell class]) bundle:nil] forCellReuseIdentifier:@"JHRechargeRecordCell"];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 45;
        
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        header.automaticallyChangeAlpha = YES;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        [_tableView.mj_header beginRefreshing];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 0) {
        JHRechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRechargeRecordCell"];
        cell.model = self.dataArray[indexPath.row];
        return cell;

    } else {
        JHPresentRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHPresentRecordCell"];
        cell.type = self.type;
        cell.model = self.dataArray[indexPath.row];
        return cell;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - 请求数据
- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 20;
    [self requestData];
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 20;
    [self requestData];
}


- (void)requestData {
    NSDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize)};
    NSString *url = @"";
    switch (self.type) {
        case 0:
            url = FILE_BASE_STRING(@"/bean/log/auth");
            break;
        case 1:
            url = FILE_BASE_STRING(@"/gift/gave/auth");

            break;

        case 2:
            url = FILE_BASE_STRING(@"/gift/received/auth");

            break;

        default:
            break;
    }
    
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [self dealDataWithDic:respondObject.data];
        [self endRefresh];

        if (((NSArray *)respondObject.data).count) {
            
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    
}

- (void)endRefresh {
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.tableView];
    }
}
- (void)dealDataWithDic:(NSArray *)array {
    
    
    NSArray *arr = @[];
    switch (self.type) {
        case 0:
            arr = [JHBeanRecordModel mj_objectArrayWithKeyValuesArray:array];

            break;
            
        case 1:
            arr = [JHPresentRecordModel mj_objectArrayWithKeyValuesArray:array];
            break;

        case 2:
            arr = [JHPresentRecordModel mj_objectArrayWithKeyValuesArray:array];
            break;

        default:
            break;
    }
    if (arr.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.pageNo == 0) {
        self.dataArray = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataArray addObjectsFromArray:arr];
    }
    
    [self.tableView reloadData];
}

@end
