//
//  JHAmountRecordViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAmountRecordViewController.h"
#import "JHAmountRecordCell.h"


@interface JHAmountRecordViewController () <UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic, strong) UITableView *homeTable;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation JHAmountRecordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
    if (self.type) {
//        [self.navbar setTitle:@"津贴记录"];
        self.title = @"津贴记录";//背景颜色不一致
    }else {
//        [self.navbar setTitle:@"资金记录"];
        self.title = @"资金记录";//背景颜色不一致
    }
//    self.navbar.ImageView.hidden = YES;
//    self.navbar.backgroundColor = HEXCOLOR(0xf7f7f7);
//    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeTable];

//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight-1, ScreenW, 1)];
//    line.backgroundColor = HEXCOLOR(0xeeeeee);
//    [self.navbar addSubview:line];
    self.jhNavBottomLine.backgroundColor = HEXCOLOR(0xeeeeee);
}

- (UITableView*)homeTable{
    
    if (!_homeTable) {
        
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.backgroundColor = [UIColor clearColor];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_homeTable registerNib:[UINib nibWithNibName:NSStringFromClass([JHAmountRecordCell class]) bundle:nil] forCellReuseIdentifier:@"JHAmountRecordCell"];

        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _homeTable.mj_header = header;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _homeTable.mj_footer = footer;
        [_homeTable.mj_header beginRefreshing];

    }
    return _homeTable;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"JHAmountRecordCell";
    JHAmountRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGFLOAT_MIN;
    }
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
    if (self.type) {
        [self requestRedAmountData];

    }else {
        [self requestData];
    }
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 10;
    if (self.type) {
        [self requestRedAmountData];
        
    }else {
        [self requestData];
    }
}

- (void)requestRedAmountData {
    NSDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize)};
    NSString *url = FILE_BASE_STRING(@"/auth/bountyLog");
    
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self dealDataWithDic:respondObject.data];
        [self checkDefault];
        
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self checkDefault];

        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
}

- (void)requestData {
    NSDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize)};
    NSString *url = FILE_BASE_STRING(@"/cash/log/auth");
    
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self dealDataWithDic:respondObject.data];
        [self checkDefault];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self checkDefault];

        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
}

- (void)endRefresh {
    if (self.pageNo<=0) {
        [_homeTable.mj_header endRefreshing];
        
    }else {
        [_homeTable.mj_footer endRefreshing];
        
    }
}

- (void)checkDefault {
    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.homeTable];
    }

}
- (void)dealDataWithDic:(NSArray *)array {
    NSArray *arr = [JHAmountRecordModel mj_objectArrayWithKeyValuesArray:array];
    if (arr.count) {
        if (self.pageNo == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        }else {
            [self.dataArray addObjectsFromArray:arr];
        }
        
    }else {
        [self.homeTable.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.homeTable reloadData];
}


@end
