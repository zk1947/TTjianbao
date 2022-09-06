//
//  JHAllowanceListVCCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "UIScrollView+JHEmpty.h"
#import "JHAllowanceListVCCell.h"
#import "JHAllowanceListCell.h"
#import "JHAllowanceDetailController.h"

@interface JHAllowanceListVCCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JHAllowanceListVCCell

- (void)addSelfSubViews
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHAllowanceListCell *cell = [JHAllowanceListCell dequeueReusableCellWithTableView:tableView];
    if(self.viewModel.dataArray.count > indexPath.section)
    {
        cell.model = self.viewModel.dataArray[indexPath.section];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.viewModel.dataArray.count > indexPath.section)
    {
        JHAllowanceListModel *model = self.viewModel.dataArray[indexPath.section];
        if(!model.isExpired)
        {
            JHAllowanceDetailController *vc = [JHAllowanceDetailController new];
            vc.model = model;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 5)];
    view.backgroundColor = APP_BACKGROUND_COLOR;
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, CGFLOAT_MIN)];
    view.backgroundColor = APP_BACKGROUND_COLOR;
    return view;
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self.contentView];
        _tableView.backgroundColor = APP_BACKGROUND_COLOR;
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = 5.f;
        _tableView.rowHeight = 55.f;
        
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.pageIndex = 0;
            [self.viewModel.requestCommand execute:@1];
        } footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel.requestCommand execute:@1];
        }];
    }
    return _tableView;
}

-(void)setViewModel:(JHAllowanceListViewModel *)viewModel
{
    if(!viewModel){
        return;
    }
    
    _viewModel = viewModel;
    [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [self.tableView jh_reloadDataWithEmputyView];
        [self.tableView jh_endRefreshing];
        [self.tableView jh_footerStatusWithNoMoreData:self.viewModel.isNoMoreData];
    }];
    
    if (_viewModel.dataArray.count <= 0) {
        [_viewModel.requestCommand execute:@1];
    }
    else
    {
        [self.tableView jh_reloadDataWithEmputyView];
    }
}

@end
