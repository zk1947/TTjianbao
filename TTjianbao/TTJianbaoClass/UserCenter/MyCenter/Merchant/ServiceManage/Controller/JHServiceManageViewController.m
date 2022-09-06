//
//  JHServiceManageViewController.m
//  TTjianbao
//
//  Created by zk on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHServiceManageViewController.h"
#import "JHServiceManageTableCell.h"
#import "JHServiceManageBusiness.h"
#import "NTESLoginManager.h"
#import "JHChatUserManager.h"
#import "UserInfoRequestManager.h"

@interface JHServiceManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headView1;

@property (nonatomic, strong) UIView *headView2;

@property (nonatomic, strong) UIView *headView3;
@property (nonatomic, strong) UILabel *headLab3;

@property (nonatomic, assign) int editIndex;//是否可编辑

@end

@implementation JHServiceManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.jhTitleLabel.text = @"客服管理";
    
    if (_pageIndex != 1) {
        _dataSourceArray = [NSMutableArray array];
    }
    
    [self steupView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_pageIndex != 1) {
        [self loadData];
    }else{
        [self dealPageType];
        [self.tableView reloadData];
    }
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self loadData];
//}

- (void)loadData{
    @weakify(self)
    [JHServiceManageBusiness getServiceList:self.anchorId Completion:^(NSError * _Nullable error, JHServiceManageModel * _Nullable model) {
        @strongify(self)
        if (!model.termsList || model.termsList.count == 0) {
            [self.tableView jh_reloadDataWithEmputyView];
            return;
        }
        self.headModel = model;
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:model.termsList];
        [self dealPageType];
        [self.tableView reloadData];
    }];
}

- (void)dealPageType{
    int styleIndex = 1;
    //haveQuickReply 是否有申请快捷回复 true有(编辑) false没有(添加)
    if (_headModel.haveQuickReply && _pageType == 0) {//编辑
        [self.jhRightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.jhRightButton setTitleColor:HEXCOLOR(0x2162DE) forState:UIControlStateNormal];
        //auditStatus 如果有申请快捷回复，最后的审核状态 0待审核 1审核通过 2审核拒绝
        styleIndex = [_headModel.auditStatus intValue];
    }else{//添加
        [self.jhRightButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.jhRightButton setTitleColor:HEXCOLOR(0x2162DE) forState:UIControlStateNormal];
        styleIndex = 6;
    }
    //处理头部样式
    [self dealHeadViewStyle:styleIndex];
}

- (void)dealHeadViewStyle:(int)styleIndex{
    //0待审核 1审核通过 2审核拒绝 6添加
    /**
     1 - 添加 可编辑
     2- 审核通过、审核拒绝 选中可编辑，非选中的不可编辑
     3- 审核中 均不可编辑
     */
    UIView *headView;
    switch (styleIndex) {
        case 0:{
            headView = self.headView2;
            _editIndex = 3;
        }
            break;
        case 1:{
            headView = self.headView1;
            _editIndex = 2;
        }
            break;
        case 2:{
            headView = self.headView3;
            _editIndex = 2;
        }
            break;
        case 6:{
            headView = self.headView1;
            _editIndex = 1;
        }
            break;
        default:
            break;
    }
    self.tableView.tableHeaderView = headView;
    
    //待审隐藏右侧按钮
    self.jhRightButton.hidden = styleIndex == 0 ? YES:NO;
}

- (void)steupView{
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self initRightButtonWithName:@"" action:@selector(rightBtnAction:)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavBottomLine.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView                               = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        _tableView.backgroundColor                 = [UIColor clearColor];
        _tableView.separatorStyle                  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight   = 0.1f;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_tableView registerClass:[JHServiceManageTableCell class] forCellReuseIdentifier:NSStringFromClass([JHServiceManageTableCell class])];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _tableView;
}

#pragma mark - Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHServiceManageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHServiceManageTableCell class])];
    if (!cell) {
        cell = [[JHServiceManageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHServiceManageTableCell class])];
    }
    cell.delegate = self;
    cell.model = self.dataSourceArray[indexPath.row];
    cell.editIndex = self.editIndex;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)selectCell:(JHServiceManageModel *)model{
    if (_headModel.haveQuickReply && _pageType == 0) {//编辑
        return;
    }
//    [self dealRightButtonStyle];
}

- (void)dealRightButtonStyle{
    if ([self checkIsHaveSelectItem]) {
        [self.jhRightButton setTitleColor:HEXCOLOR(0x2162DE) forState:UIControlStateNormal];
        self.jhRightButton.userInteractionEnabled = YES;
    }else{
        [self.jhRightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.jhRightButton.userInteractionEnabled = NO;
    }
}

- (BOOL)checkIsHaveSelectItem{
    BOOL result = NO;
    for (JHServiceManageItemModel *model in self.dataSourceArray) {
        if ([model.status intValue] == 1) {
            result = YES;
            break;
        }
    }
    return result;
}

- (BOOL)checkIsHaveEmptyItem{
    BOOL result = NO;
    for (JHServiceManageItemModel *model in self.dataSourceArray) {
        if ([model.status intValue] == 1 && model.defaultReply.length<1) {
            result = YES;
            break;
        }
    }
    return result;
}

- (void)rightBtnAction:(UIButton *)rightBtn{
    if (_headModel.haveQuickReply && _pageType == 0) {//编辑
//        [self dealEditEvent];
        [self gotoAddPage];
    }else{//提交
        [self dealAddEvent];
    }
}

- (void)dealAddEvent{
    //空值判断
    if (![self checkIsHaveSelectItem]) {
        [self.view makeToast:@"暂未勾选内容，请选择后再提交" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if ([self checkIsHaveEmptyItem]) {
        [self.view makeToast:@"勾选的自动回复内容有空，请补充" duration:1.0 position:CSToastPositionCenter];
        return;
    }
//    User *user = [UserInfoRequestManager sharedInstance].user;
//    NSDictionary *param = @{
//        @"anchorId":@([self.anchorId integerValue]),
//        @"operatorId":self.anchorId,
//        @"operatorName":user.name,
//        @"termsReqs":[self getAddData],
//    };
//
//    [JHServiceManageBusiness addServiceData:param completion:^(NSError * _Nullable error, BOOL isSuccess) {
//        if (isSuccess) {
//            [self.view makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
//            [self performSelector:@selector(gotoEditPage) afterDelay:1.0];
//        }else{
//            [self.view makeToast:error.userInfo[@"NSLocalizedDescription"] duration:1.0 position:CSToastPositionCenter];
//        }
//    }];
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSDictionary *param = @{
        @"anchorId":@([self.anchorId integerValue]),
        @"operatorId":self.anchorId,
        @"operatorName":user.name,
        @"termsReqs":[self getAddData],
    };
    @weakify(self);
    [JHServiceManageBusiness editServiceData:param completion:^(NSError * _Nullable error, BOOL isSuccess) {
        @strongify(self);
        if (isSuccess) {
            [self.view makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
            [self performSelector:@selector(gotoEditPage) afterDelay:1.0];
        }else{
            [self.view makeToast:error.userInfo[@"NSLocalizedDescription"] duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
}

- (void)gotoEditPage{
//    if (self.pageIndex == 1) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
        JHServiceManageViewController *vc = [JHServiceManageViewController new];
        vc.anchorId = self.anchorId;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (void)dealEditEvent{
    //空值判断
    if (![self checkIsHaveSelectItem]) {
        [self.view makeToast:@"暂未勾选内容，请选择后再提交" duration:1.0 position:CSToastPositionCenter];
        return;
    }
//    if ([self checkIsHaveEmptyItem]) {
//        [self.view makeToast:@"勾选的自动回复内容有空，请补充" duration:1.0 position:CSToastPositionCenter];
//        return;
//    }
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSDictionary *param = @{
        @"anchorId":@([self.anchorId integerValue]),
        @"operatorId":self.anchorId,
        @"operatorName":user.name,
        @"termsReqs":[self getAddData],
    };
    @weakify(self);
    [JHServiceManageBusiness editServiceData:param completion:^(NSError * _Nullable error, BOOL isSuccess) {
        @strongify(self);
        if (isSuccess) {
            [self gotoAddPage];
        }else{
            [self.view makeToast:error.userInfo[@"NSLocalizedDescription"] duration:1.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)gotoAddPage{
    
    //空值判断
    if (![self checkIsHaveSelectItem]) {
        [self.view makeToast:@"暂未勾选内容，请选择后再提交" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    JHServiceManageViewController *vc = [JHServiceManageViewController new];
    vc.headModel = self.headModel;
    vc.dataSourceArray = self.dataSourceArray;
    vc.anchorId = self.anchorId;
    vc.pageType = 1;
    vc.pageIndex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backActionButton:(UIButton *)sender{
    if (self.pageType == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray *)getAddData{
    NSMutableArray *resultArr = [NSMutableArray array];
    for (JHServiceManageItemModel *model in self.dataSourceArray) {
        if ([model.status intValue] == 1) {
            [resultArr addObject:[model mj_keyValues]];
        }
    }
    return [resultArr copy];
}

- (UIView *)headView1{
    if (!_headView1) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        _headView1 = headView;
    }
    return _headView1;
}

- (UIView *)headView2{
    if (!_headView2) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        
        UILabel *labV = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
        labV.backgroundColor = HEXCOLOR(0xFFD70F);
        labV.alpha = 0.25;
        [headView addSubview:labV];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
        lab.text = @"审核中…";
        lab.textColor = HEXCOLOR(0x000000);
        lab.font = JHFont(12);
        lab.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:lab];
        _headView2 = headView;
    }
    return _headView2;
}

- (UIView *)headView3{
    if (!_headView3) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        
        UILabel *labV = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
        labV.backgroundColor = HEXCOLOR(0xFF1111);
        labV.alpha = 0.05;
        [headView addSubview:labV];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
        lab.text = [NSString stringWithFormat:@"审核未通过:%@",_headModel.rejectReason];
        lab.textColor = HEXCOLOR(0xFF2020);
        lab.font = JHFont(12);
        lab.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:lab];
        _headLab3 = lab;
        _headView3 = headView;
    }
    return _headView3;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
