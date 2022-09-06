//
//  JHFansListView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansListView.h"
#import "JHFansListHeaderView.h"
#import "JHFansListViewModel.h"
#import "JHFansListCell.h"
#import "JHFansTaskSectionHeaderView.h"

@interface JHFansListView ()<UITableViewDelegate, UITableViewDataSource>
{

}
/// 列表
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHFansListHeaderView *headerView;
@property (nonatomic, strong) JHFansListViewModel *viewModel;
@end
@implementation JHFansListView
- (void)dealloc {
    NSLog(@"粉丝列表%@ 释放", [self class]);
}
-(void)setSubViews{
    
   // self.gestView=self.tableView;
    self.viewModel.pageSize = 10;
    [self setupUI];
    [self bindData];
    
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.viewModel.listArr.count >= [self.viewModel.fansClubModel.totalfansCount intValue]) {
            self.tableView.mj_footer.hidden = YES;
        }
        else{
            self.tableView.mj_footer.hidden = NO;
        }
        [self endRefresh];
        [self.tableView reloadData];
      
    }];
    
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.headerView.fansClubModel = self.viewModel.fansClubModel;
    }];
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark - SetUI
- (void)setupUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(450 + UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"JHFansListCell";
    JHFansListCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[JHFansListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          cell.accessoryType=UITableViewCellAccessoryNone;
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setFansModel:self.viewModel.listArr[indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
    return view;
}
-(void)setAnchorId:(NSString *)anchorId{
    
    _anchorId = anchorId;
    self.viewModel.anchorId = _anchorId;
}
- (void)loadNewData{
    
    self.viewModel.pageNo = 1;
    [self.viewModel getFansHeaderInfo];
    [self.viewModel getFansListInfo];
}
- (void)loadMoreData{
    
     self.viewModel.pageNo ++;
    [self.viewModel getFansListInfo];
}
- (JHFansListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHFansListViewModel alloc] init];
    }
    return _viewModel;
}
- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
       // _tableView.bounces = NO;
        
        @weakify(self);
       
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadNewData];
        }];
        _tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMoreData];
        }];
        
        _tableView.mj_footer.hidden=YES;
    
    }
    return _tableView;
}
- (JHFansListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JHFansListHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 110)];
    }
    return _headerView;
}
#pragma mark - Action functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (void)show {

    [self layoutIfNeeded];
    self.tableView.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.bottom = self.height;
    }];
}
-(void)HideAlert{
   
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
   
}
@end
