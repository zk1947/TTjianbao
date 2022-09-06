//
//  JHBankCardManagerViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBankCardManagerViewController.h"
#import "PanNavigationController.h"
#import "JHAddBankCardViewController.h"
#import "JHOCKAddBankCardViewController.h"
#import "JHBankCardManageTableViewCell.h"
#import "UIImage+JHColor.h"
#import "UIView+JHGradient.h"
#import "UIView+UIHelp.h"
#import "CommHelp.h"
#import "SVProgressHUD.h"
#import "UserInfoRequestManager.h"


@interface JHBankCardManagerViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *contentTableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, assign) Boolean displayLoading;
@end

@implementation JHBankCardManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡管理";
    self.view.backgroundColor = HEXCOLOR(0xFFF8F8F8);
    self.displayLoading = YES;
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestInfo];
    if ([UserInfoRequestManager sharedInstance].user.customerType.intValue == 1) return;
    if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
        PanNavigationController *nav = (PanNavigationController *)self.navigationController;
        nav.isForbidDragBack = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([UserInfoRequestManager sharedInstance].user.customerType.intValue == 1) return;
    if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
        PanNavigationController *nav = (PanNavigationController *)self.navigationController;
        nav.isForbidDragBack = NO;
    }
}

-(void)requestInfo {
    if(self.displayLoading) {
        [SVProgressHUD show];
    }
    @weakify(self)
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/bank/list") Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self)
        [SVProgressHUD dismiss];
        self.displayLoading = NO;
        self.dataSource = [JHBankCardModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.contentTableView reloadData];
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
}

-(void)relieveBankCardBindingWithBankCardModel:(JHBankCardModel *)bankCardModel {
    NSDictionary *par = @{
        @"page_position":@"bindCardManage",
        @"operation_type":@"unbind"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickEdit"
                                          params:par
                                            type:JHStatisticsTypeSensors];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:bankCardModel.ID forKey:@"id"];
    
    [SVProgressHUD show];
    @weakify(self)
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/bank/unbound") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if (respondObject.code == 1000) {
            [self.dataSource removeObject:bankCardModel];
            [self.contentTableView reloadData];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
}

-(void)updateBankBranchWithBankCardModel:(JHBankCardModel *)bankCardModel {
    NSDictionary *par = @{
        @"page_position":@"bindCardManage",
        @"operation_type":@"cancel"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickEdit"
                                          params:par
                                            type:JHStatisticsTypeSensors];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:bankCardModel.ID forKey:@"id"];
    [parameters setValue:bankCardModel.editBankBranch forKey:@"bankBranch"];
    
    [SVProgressHUD show];
    @weakify(self)
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/bank/updateBankBranch") Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if (respondObject.code == 1000) {
            bankCardModel.bankBranch =  bankCardModel.editBankBranch;
            [self.contentTableView reloadData];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
}

- (void)initTableView {
    [self.view addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(10.f + UI.statusAndNavBarHeight);
        make.bottom.mas_equalTo(-(10.f+UI.bottomSafeAreaHeight));
    }];
}

-(UIView *)setupBottomView {
    UIButton *completeBtn = [UIButton jh_buttonWithTitle:@" 添加银行卡" fontSize:14.f textColor:UIColor.blackColor target:self action:@selector(addBankCardAction:) addToSuperView:self.view];
    [completeBtn removeFromSuperview];
    completeBtn.frame = CGRectMake(0, 0, kScreenWidth-20, 44);
    [completeBtn setImage:[UIImage imageNamed:@"icon_bank_card_cell"] forState:UIControlStateNormal];
    completeBtn.adjustsImageWhenHighlighted = NO;
    completeBtn.backgroundColor = UIColor.whiteColor;
    completeBtn.layer.cornerRadius = 5.f;
    return completeBtn;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBankCardManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHBankCardManageTableViewCellID"];
    cell.bankCardModel = self.dataSource[indexPath.row];
    @weakify(self)
    [cell setBankCardUpdateOpenBankBlock:^(JHBankCardModel * _Nonnull bankCardModel) {
        @strongify(self)
        [self updateBankBranchWithBankCardModel:bankCardModel];
    }];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([UserInfoRequestManager sharedInstance].user.authType == JHUserAuthTypeCommonBunsiness) return NO;
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *btnArray  = [NSMutableArray array];
    // 添加一个删除按钮
    @weakify(self)
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"解除绑定" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        @strongify(self)
        [self relieveBankCardBindingWithBankCardModel:self.dataSource[indexPath.row]];
    }];
    
    // 设置背景颜色
    deleteRowAction.backgroundColor = HEXCOLOR(0xFFFA9937);
    [btnArray addObject:deleteRowAction];
    return btnArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  155.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.bankCardManagerBlock) {
        self.bankCardManagerBlock(self.dataSource[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    //在这里实现删除操作
//    NSLog(@"forRowAtIndexPath");
//    //删除数据，和删除动画
////    [self.myarray removeObjectAtIndex:deleteRow];
////    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:deleteRow inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//}

- (void)addBankCardAction:(UIButton *)btn {
    if (self.dataSource.count > 0) {
        [self.view makeToast:@"暂支持绑定一张银行卡，可解绑后在添加~"duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    NSDictionary *par = @{
        @"page_position":@"bindCardManage"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickAddBindCard"
                                          params:par
                                            type:JHStatisticsTypeSensors];
    [self.navigationController pushViewController:[JHOCKAddBankCardViewController new] animated:YES];
}

#pragma mark - set method

-(UITableView*)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.estimatedRowHeight = 155.f;
        _contentTableView.showsHorizontalScrollIndicator = NO;
        _contentTableView.showsVerticalScrollIndicator = NO;
        _contentTableView.alwaysBounceVertical = YES;
        _contentTableView.backgroundColor = [UIColor clearColor];
        [_contentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_contentTableView registerClass:[JHBankCardManageTableViewCell class] forCellReuseIdentifier:@"JHBankCardManageTableViewCellID"];
        UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _contentTableView.tableFooterView = [self setupBottomView];
    }
    return _contentTableView;
}

@end
