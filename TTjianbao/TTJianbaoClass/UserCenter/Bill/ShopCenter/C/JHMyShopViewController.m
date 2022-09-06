//
//  JHMyShopViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/27.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHMyShopViewController.h"
#import "JHAmountManageViewController.h"
#import "JHAssistantViewController.h"
#import "JHOrderListViewController.h"
#import "JHOrderCommentManngeViewController.h"
#import "JHShopCouponViewController.h"
#import "JHWebViewController.h"
#import "JHMuteListViewController.h"
#import "OrderExportListViewController.h"
#import "JHOrderQuestionViewController.h"
#import "JHBackPlayListVC.h"
#import "NTESAudienceLiveViewController.h"

#import "JHPrinterManager.h"
#import "JHMyShopViewTableViewCell.h"
#import "JHMyShopViewModel.h"
#import "JHMyShopHeaderView.h"
#import "JHBillTotalViewController.h"
@interface JHMyShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* homeTable;

@property (nonatomic, strong) JHMyShopViewModel *viewModel;

@property (nonatomic, strong) JHMyShopHeaderView *headerView;

@end

@implementation JHMyShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
    
    [self.homeTable reloadData];
    
    [self headerView];
    
    [self.jhNavView removeFromSuperview];

    [self.view addSubview: self.jhLeftButton];
    
    [self jhSetLightStatusBarStyle];
    [self.jhLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(UI.statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    
    
    [self.viewModel.requestCommand execute:nil];
}

#pragma mark ---------------------------- method ----------------------------



#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.viewModel.dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [(NSArray*)[self.viewModel.dataArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic = self.viewModel.dataArray[indexPath.section][indexPath.row];
    
    JHMyShopViewTableViewCell *cell = [JHMyShopViewTableViewCell dequeueReusableCellWithTableView:tableView];
    
    cell.descLabel.text = [dic valueForKey:@"title"];
    
    cell.iconView.image = [UIImage imageNamed:[dic valueForKey:@"imageName"]];

    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 5.f;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dic = self.viewModel.dataArray[indexPath.section][indexPath.row];
    NSString *string = [dic valueForKey:@"title"];
    if ([string isEqualToString:@"订单管理"]) {
        JHOrderListViewController * orderList=[[JHOrderListViewController alloc]init];
        orderList.isSeller=YES;
        [self.navigationController pushViewController:orderList animated:YES];
        
    }else if ([string isEqualToString:@"资金管理"]) {
        JHAmountManageViewController *vc = [[JHAmountManageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([string isEqualToString:@"助理管理"]) {
        JHAssistantViewController *vc = [[JHAssistantViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([string isEqualToString:@"代金券管理"]) {
        JHShopCouponViewController *vc = [[JHShopCouponViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([string isEqualToString:@"订单评价管理"]) {
        JHOrderCommentManngeViewController * vc=[JHOrderCommentManngeViewController new];
        User *user = [UserInfoRequestManager sharedInstance].user;
        vc.isSeller=user.isAssistant?NO:YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([string isEqualToString:@"宝友心愿单管理"]) {
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.urlString = ShowWishPaperURL(1,1,0);
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([string isEqualToString:@"禁言管理"]) {
        JHMuteListViewController *vc = [[JHMuteListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([string isEqualToString:@"订单导出记录"]) {
        OrderExportListViewController *vc = [[OrderExportListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([string isEqualToString:@"问题单"]){
        JHOrderQuestionViewController *vc = [JHOrderQuestionViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([string isEqualToString:@"商家培训直播间"]){
        
        [JHRootController toNativeVC:@"NTESAudienceLiveViewController" withParam:@{@"roomId":[UserInfoRequestManager sharedInstance].infoConfigDict.channelLocalId} from:JHLiveFromshopOverview];
//        [JHRootController getLiveDetail:[UserInfoRequestManager sharedInstance].infoConfigDict.channelLocalId isAppraisal:NO];
    }else if ([string isEqualToString:@"直播回放"]){
        JHBackPlayListVC *vc = [JHBackPlayListVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---------------------------- get set ----------------------------
-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self.view];
        _homeTable.backgroundColor = RGB(242, 242, 242);
        _homeTable.rowHeight = 48.f;
        [_homeTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(377);
        }];
    }
    return _homeTable;
}

-(JHMyShopHeaderView *)headerView
{
    if(!_headerView){
        _headerView = [JHMyShopHeaderView new];
        [self.view addSubview:_headerView];
        @weakify(self);
        _headerView.buttonClick = ^{
            @strongify(self);
            JHBillTotalViewController *vc = [JHBillTotalViewController new];
            vc.totalMoney = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.totalMoney];
            vc.accountDate = self.viewModel.dataSource.accountDate;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(377.f);
        }];
    }
    return _headerView;
}

-(JHMyShopViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [JHMyShopViewModel new];
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self setHeaderViewData];
        }];
    }
    return _viewModel;
}

-(void)setHeaderViewData
{
    User *user = [UserInfoRequestManager sharedInstance].user;
    
    [self.headerView.avatorView jhSetImageWithURL:[NSURL URLWithString:user.icon]];
    
    self.headerView.nickNameLabel.text = user.name;
    
    double price = [[NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.totalMoney] doubleValue];
    [self.viewModel setLabel:self.headerView.totalMoneyLabel toNum:price timeInterval:1.6];
    
    self.headerView.incomeFreezeLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.account.incomeFreezeAccount];
    
    self.headerView.withdrawLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.account.withdrawAccount];
    
    self.headerView.oldIncomeFreezeLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.oldAccount.incomeFreezeAccount];
    
    self.headerView.oldWithdrawLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.dataSource.oldAccount.withdrawAccount];
    
    self.headerView.dateNewTipLabel.text = [NSString stringWithFormat:@"%@及以后的数据",self.viewModel.dataSource.accountDate];
    
    self.headerView.oldDateTipLabel.text = [NSString stringWithFormat:@"%@以前的数据",self.viewModel.dataSource.accountDate];
}

@end

