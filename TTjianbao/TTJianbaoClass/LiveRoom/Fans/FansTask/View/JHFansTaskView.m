//
//  JHFansTaskView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansTaskView.h"
#import "JHFansTaskSectionHeaderView.h"
#import "JHFansTaskViewModel.h"
#import "JHFansTaskCell.h"
#import "JHFansTaskHeaderView.h"

@interface JHFansTaskView ()<UITableViewDelegate, UITableViewDataSource>
{
}
/// 列表
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHFansTaskHeaderView *headerView;
@property (nonatomic, strong) JHFansTaskViewModel *viewModel;
@end
@implementation JHFansTaskView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"粉丝任务--页面%@ 释放", [self class]);
}
-(void)setSubViews{
    
    [self setupUI];
    [self bindData];
    
}
#pragma mark - Bind
- (void)bindData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"NSNotification_Refersh_fansHeader" object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFansClubInfo) name:FansClubTaskNotifaction object:nil];
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
        self.headerView.fansClubModel = self.viewModel.fansClubModel;
        self.headerView.channelLocalID = self.channelLocalID;
    }];
}

- (void)refreshHeader{
    [self.tableView reloadData];
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
    return self.viewModel.fansClubModel.taskVos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"JHFansTaskTableCell";
    JHFansTaskCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[JHFansTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          cell.accessoryType=UITableViewCellAccessoryNone;
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.row == self.viewModel.fansClubModel.taskVos.count-1) {
        [cell.line setHidden:YES];
    }
    else{
        [cell.line setHidden:NO];
    }
    [cell setFansTaskModel:self.viewModel.fansClubModel.taskVos[indexPath.row]];
    @weakify(self);
    cell.buttonAction = ^(id obj) {
        @strongify(self);
        if (self.TaskAction) {
            self.TaskAction(obj);
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40 + self.viewModel.fansClubModel.freezeUnfloderHeight;
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
    JHFansTaskSectionHeaderView *header = [JHFansTaskSectionHeaderView dequeueReusableHeaderFooterViewWithTableView:tableView];
    header.currentTime = self.viewModel.fansClubModel.currentDate;
    header.fansClubModel = self.viewModel.fansClubModel;
    return header;
}

- (void)getFansClubInfo{
    
    [self.viewModel getFansClubInfo];
}
-(void)setFansClubId:(NSString *)fansClubId{
    
    _fansClubId = fansClubId;
    self.viewModel.fansClubId = _fansClubId;
    
}
- (JHFansTaskViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHFansTaskViewModel alloc] init];
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
        _tableView.bounces = NO;
    }
    return _tableView;
}
- (JHFansTaskHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JHFansTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 136)];
        @weakify(self);
        _headerView.ruleAction = ^(id obj) {
            @strongify(self);
            if (self.ruleAction) {
                self.ruleAction(nil);
            }
        };
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
