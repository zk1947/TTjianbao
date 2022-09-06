//
//  JHMyCenterAppraiserView.m
//  TTjianbao
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterAppraiserView.h"
#import "JHMyCenterAppraiserViewModel.h"
#import "JHMyCenterAppraiserViewCell.h"
#import "JHMyCenterUserHeaderView.h"
#import "JHMyCenterButtonModel.h"

@interface JHMyCenterAppraiserView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JHMyCenterUserHeaderView *headerView;

@property (nonatomic, weak) UITableView* tableView;

@property (nonatomic, strong) JHMyCenterAppraiserViewModel *viewModel;

@end

@implementation JHMyCenterAppraiserView

-(void)dealloc{
    NSLog(@"🔥dealloc－－－－%@",self.class);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(245, 246, 250);
        [self headerView];
        [self.tableView reloadData];
    }
    return self;
}

-(void)reload{
    [self.headerView reload];
}
#pragma mark --------------- tableview ---------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.viewModel.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JHMyCenterAppraiserViewCell *cell = [JHMyCenterAppraiserViewCell dequeueReusableCellWithTableView:tableView];
    if(indexPath.row < self.viewModel.dataArray.count){
        JHMyCenterButtonModel *model = self.viewModel.dataArray[indexPath.row];
        cell.model = model;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row < self.viewModel.dataArray.count){
        JHMyCenterButtonModel *model = self.viewModel.dataArray[indexPath.row];
        [JHMyCenterButtonModel pushWithType:model.type];
    }
    
//    NSDictionary *dic = self.viewModel.dataArray[indexPath.section][indexPath.row];
//    NSString *string = [dic valueForKey:@"title"];
//    if ([string isEqualToString:@"订单管理"]) {
//        JHOrderListViewController * orderList=[[JHOrderListViewController alloc]init];
//        orderList.isSeller=YES;
//        [self.navigationController pushViewController:orderList animated:YES];
//
//    }else if ([string isEqualToString:@"资金管理"]) {
//        JHAmountManageViewController *vc = [[JHAmountManageViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if ([string isEqualToString:@"助理管理"]) {
//        JHAssistantViewController *vc = [[JHAssistantViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }else if ([string isEqualToString:@"代金券管理"]) {
//        JHShopCouponViewController *vc = [[JHShopCouponViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }else if ([string isEqualToString:@"订单评价管理"]) {
//        JHOrderCommentManngeViewController * vc=[JHOrderCommentManngeViewController new];
//        User *user = [UserInfoRequestManager sharedInstance].user;
//        vc.isSeller=user.isAssistant?NO:YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if ([string isEqualToString:@"宝友心愿单管理"]) {
//        JHWebViewController *vc = [[JHWebViewController alloc] init];
//        vc.urlString = ShowWishPaperURL(1,1,0);
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }else if ([string isEqualToString:@"禁言管理"]) {
//        JHMuteListViewController *vc = [[JHMuteListViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if ([string isEqualToString:@"订单导出记录"]) {
//        OrderExportListViewController *vc = [[OrderExportListViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if ([string isEqualToString:@"问题单"]){
//        JHOrderQuestionViewController *vc = [JHOrderQuestionViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if ([string isEqualToString:@"商家培训直播间"]){
//
//        [JHRootController toNativeVC:@"NTESAudienceLiveViewController" withParam:@{@"roomId":[UserInfoRequestManager sharedInstance].infoConfigDict.channelLocalId} from:JHLiveFromshopOverview];
////        [JHRootController getLiveDetail:[UserInfoRequestManager sharedInstance].infoConfigDict.channelLocalId isAppraisal:NO];
//    }else if ([string isEqualToString:@"直播回放"]){
//        JHBackPlayListVC *vc = [JHBackPlayListVC new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark ---------------------------- get set ----------------------------
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.rowHeight = 50.f;
        _tableView.separatorColor = RGB(238, 238, 238);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        [_tableView jh_cornerRadius:8];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.headerView.mas_bottom).offset(-[JHMyCenterUserHeaderView viewBottom]);
            make.height.mas_equalTo(350);
        }];
    }
    return _tableView;
}

- (JHMyCenterAppraiserViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [JHMyCenterAppraiserViewModel new];
    }
    return _viewModel;
}

- (JHMyCenterUserHeaderView *)headerView{
    if(!_headerView){
        _headerView = [JHMyCenterUserHeaderView new];
        [self addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo([JHMyCenterUserHeaderView viewHeight]);
        }];
    }
    return _headerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
