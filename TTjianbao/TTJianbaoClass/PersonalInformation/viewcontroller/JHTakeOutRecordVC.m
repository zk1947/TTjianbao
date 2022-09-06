//
//  JHTakeOutRecordVC.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHTakeOutRecordVC.h"
#import "JHTakeOutRecordCell.h"
#import "JHQRViewController.h"
#import "JHAmountRecordModel.h"


@interface JHTakeOutRecordVC () <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat footerHeight;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation JHTakeOutRecordVC
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.pageSize = 20;
//    [self  initToolsBar];
    footerHeight = ScreenH - self.jhNavView.height;

    self.title = @"提现记录"; //背景颜色不一致
//    [self.navbar setTitle:@"提现记录"];
//    self.navbar.ImageView.hidden = YES;
    self.jhNavView.backgroundColor = HEXCOLOR(0xf7f7f7);
//    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backActionButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
    
    
    
    
}
- (void)backActionButton:(UIButton *)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UITableView*)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.alwaysBounceVertical=YES;
        _tableView.scrollEnabled=YES;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHTakeOutRecordCell class]) bundle:nil] forCellReuseIdentifier:@"JHTakeOutRecordCell"];
        
        
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        [_tableView.mj_header beginRefreshing];
        
    }
    return _tableView;
}



- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"JHTakeOutRecordCell";
    JHTakeOutRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = HEXCOLOR(0xf7f7f7);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count-1) {
        return footerHeight;
    }
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count-1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, footerHeight)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        line.backgroundColor = HEXCOLOR(0xf7f7f7);
        [view addSubview:line];
        
        
        return view;
    }
    
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
    NSString *url = FILE_BASE_STRING(@"/cash/withdraw/auth");
    
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [self dealDataWithDic:respondObject.data];
        [self endRefresh];
        
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
}

- (void)endRefresh {
    if (self.pageNo<=0) {
        [_tableView.mj_header endRefreshing];
        
    }else {
        [_tableView.mj_footer endRefreshing];
        
    }
    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.tableView];
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
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    footerHeight = ScreenH - self.jhNavView.height - 50*self.dataArray.count;
    if (footerHeight<0) {
        footerHeight = 0;
    }

    [self.tableView reloadData];
}

@end
