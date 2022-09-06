//
//  JHBillTotalViewController.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillTotalViewController.h"
#import "JHBillTotalViewModel.h"
#import "JHTakeOutViewController.h"
#import "JHBillTotalTableViewHeader.h"
#import "JHBillTotalSectionHeader.h"
#import "JHStoneDetailSectionFooterView.h"
#import "JHBillTotalTableViewCell.h"
#import "JHBillDetailViewController.h"
#import "JHBillInstructionAlertView.h"
#import "CommAlertView.h"
#import "JHWebViewController.h"
#import "JHRealNameAuthenticationViewController.h"
#import "JHOCKAddBankCardViewController.h"

@interface JHBillTotalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JHBillTotalTableViewHeader *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JHBillTotalViewModel *viewModel;

@end

@implementation JHBillTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"资金管理";
    
    [self jhSetLightStatusBarStyle];
    
    self.jhNavView.backgroundColor = UIColor.clearColor;
    
    [self.tableView reloadData];
    
    [self jhBringSubviewToFront];
    
    [self.viewModel.requestCommand execute:nil];
    
    if (self.totalMoney.floatValue <= 0) {
        [self.viewModel.totalMoneyRequestCommand execute:nil];
    }
}

#pragma mark ---------------------------- table ----------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.viewModel.dataArray[section][@"data"];
    return array.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = self.viewModel.dataArray[section];
    
    JHBillTotalSectionHeader *header = [JHBillTotalSectionHeader dequeueReusableHeaderFooterViewWithTableView:tableView];
    header.titleLabel.text = [dic valueForKey:@"title"];
    
    header.iconView.image = [UIImage imageNamed:[dic valueForKey:@"imageName"]];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    JHStoneDetailSectionFooterView *footer = [JHStoneDetailSectionFooterView dequeueReusableHeaderFooterViewWithTableView:tableView];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = self.viewModel.dataArray[indexPath.section][@"data"];
    NSDictionary *dic = array[indexPath.row];
    
    JHBillTotalTableViewCell *cell = [JHBillTotalTableViewCell dequeueReusableCellWithTableView:tableView];
    
    cell.titleLabel.text = [dic valueForKey:@"title"];
    
    cell.moneyLabel.text = [dic valueForKey:@"money"];
    
    cell.iconButton.hidden = ([[dic valueForKey:@"tip"] intValue]==0);
    
    @weakify(self);
    cell.tipActionBlock = ^{
        @strongify(self);
        [self showAlerViewMethodWithTitle:[dic valueForKey:@"title"]];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

#pragma mark ---------------------------- method ----------------------------
-(void)showAlerViewMethodWithTitle:(NSString *)title
{
    JHBillInstructionAlertView *tipView = [JHBillInstructionAlertView new];
    [self.view addSubview: tipView];
    tipView.alertViewTitle = title;
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark ---------------------------- get set ----------------------------

-(JHBillTotalViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [JHBillTotalViewModel new];
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView reloadData];
        }];
        
        [_viewModel.totalMoneyRequestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([x isKindOfClass:[NSString class]]) {
                self.headerView.moneyLabel.text = x;
            }
            self.accountDate = self.viewModel.accountDate;
            self.headerView.accountDate = self.accountDate;
        }];
    }
    return _viewModel;
}
-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.view];
        _tableView.tableHeaderView     = self.headerView;
        _tableView.backgroundColor     = RGB(248, 248, 248);
        _tableView.separatorColor      = RGB(238, 238, 238);
        _tableView.separatorInset      = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.rowHeight           = [JHBillTotalTableViewCell cellHeight];
        _tableView.bounces             = NO;
        _tableView.sectionFooterHeight = 5.f;
        _tableView.sectionHeaderHeight = [JHBillTotalSectionHeader viewHeight];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
    }
    return _tableView;
}

-(JHBillTotalTableViewHeader *)headerView
{
    if (!_headerView) {
        _headerView = [[JHBillTotalTableViewHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenW, [JHBillTotalTableViewHeader headerViewSize].height)];
        _headerView.moneyLabel.text = self.totalMoney;
        _headerView.accountDate = self.accountDate;
        @weakify(self);
        _headerView.getMoneyActionBlock = ^{
            @strongify(self);
            User *user = [UserInfoRequestManager sharedInstance].user;
            if (user.isFaceAuth.intValue == 0 &&
                user.authType != JHUserAuthTypeCommonBunsiness) {
                [self showRealNameAlertView];
                return;
            }
            
            if (user.isBindBank.intValue == 0) {
                [self showBandingBankCardAlertView];
                return;
            }
            
            [self.navigationController pushViewController:[JHTakeOutViewController new] animated:YES];
        };
        
        _headerView.detailActionBlock = ^{
            @strongify(self);
            JHBillDetailViewController *vc = [JHBillDetailViewController new];
            vc.accountDate = self.accountDate;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (void)showRealNameAlertView {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"实名认证" andDesc:@"为了提现账号安全，请先进行实名认证" cancleBtnTitle:@"去认证"];
    [alert dealTitleToCenter];
    @weakify(self)
    [alert setCancleHandle:^{
        @strongify(self)
        [self.navigationController pushViewController:[JHRealNameAuthenticationViewController new] animated:YES];
    }];
    [alert setDesFont: [UIFont systemFontOfSize:13.f]];
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
}

- (void)showBandingBankCardAlertView {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"绑定银行卡" andDesc:@"请先绑定银行卡，再进行提现" cancleBtnTitle:@"去绑定"];
    @weakify(self)
    [alert setCancleHandle:^{
        @strongify(self)
        if ([UserInfoRequestManager sharedInstance].user.authType != JHUserAuthTypeCommonBunsiness) {
            [self.navigationController pushViewController:[JHOCKAddBankCardViewController new] animated:YES];
            return;
        }
        
        if ([UserInfoRequestManager sharedInstance].user.authType == JHUserAuthTypeCommonBunsiness) {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = H5_BASE_STRING(@"/jianhuo/app/recycle/tiedCard.html");
            [self.navigationController pushViewController:webView animated:YES];
            return;
        }
        
    }];
    [alert setDesFont: [UIFont systemFontOfSize:13.f]];
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
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
