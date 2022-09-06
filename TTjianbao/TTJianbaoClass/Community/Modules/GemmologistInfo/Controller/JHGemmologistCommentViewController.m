//
//  JHGemmologistCommentViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGemmologistCommentViewController.h"
#import "JHGemmologistCommentCell.h"
#import "JHEvaluationModel.h"
#import "JHRefreshNormalFooter.h"
#import "JHRefreshGifHeader.h"
#import "JHEmptyTableViewCell.h"

@interface JHGemmologistCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation JHGemmologistCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.pageSize = 20;
    self.title = @"用户评价";
    [self.view addSubview:self.tableView];
    
    [self loadData];
    
}

- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = @(self.pageNo).stringValue;
    params[@"pageSize"] = @(self.pageSize).stringValue;
    params[@"appraiserCustomerId"] = self.anchorId;
    NSString *url = FILE_BASE_STRING(@"/authoptional/appraise/comment/records");
    [HttpRequestTool getWithURL:url Parameters:params successBlock:^(RequestModel *respondObject) {
        NSArray *array = [JHEvaluationModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.tableView.mj_header endRefreshing];
        if (self.pageNo == 0) {
            self.listArray = [NSMutableArray arrayWithArray:array];
        }else{
            [self.listArray addObjectsFromArray:array];
        }
        if (array > 0) {
            self.pageNo += 1;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listArray.count == 0) {
        return 1;
    }
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count == 0) {
        return self.tableView.height;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count == 0) {
        JHEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHEmptyTableViewCell"];
        return cell;
    }
    JHGemmologistCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHGemmologistCommentCell"];
    cell.model = self.listArray[indexPath.row];
    return cell;
}


#pragma  mark -UI绘制
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH - UI.statusAndNavBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColorF5F6FA;
        [self.tableView registerClass:[JHGemmologistCommentCell class] forCellReuseIdentifier:@"JHGemmologistCommentCell"];
        [self.tableView registerClass:[JHEmptyTableViewCell class] forCellReuseIdentifier:@"JHEmptyTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        JH_WEAK(self)
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            JH_STRONG(self)
            self.pageNo = 0;
            [self loadData];
        }];
        _tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


@end
