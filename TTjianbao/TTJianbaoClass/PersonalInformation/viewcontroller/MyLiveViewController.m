//
//  LifeViewController.m
//  YouPinFenQi
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "MyLiveViewController.h"
#import "NTESLiveManager.h"
#import "NTESAnchorLiveViewController.h"
#import "NTESAnchorPreviewController.h"
#import "JHLiveRecordViewController.h"
#import "JHSetLiveCoverViewController.h"
#import "JHCoinRecordViewController.h"
#import "JHClaimOrderListViewController.h"
#import "JHDiscoverAppraiseReplyViewController.h"
#import "JHMuteListViewController.h"
#import "JHNormalLivePreviewController.h"
#import "JHAppraiseOrderViewController.h"
#import "BaseNavViewController.h"

#import "TTjianbaoBussiness.h"
#import "UITitleValueMoreCell.h"

#define headViewRate (float) 241/375
@interface MyLiveViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView* headerview;
    NSArray * listArr;

}
@property(nonatomic,strong) UITableView* homeTable;

@end

@implementation MyLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"我的直播"];
    self.title = @"我的直播";//背景颜色不一致
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    if ([UserInfoRequestManager sharedInstance].user.blRole_appraiseAnchor) {
        listArr=@[
                  @[@"打赏收入"/*,@"直播历史"*/,@"直播封面设置"],
                  @[@"鉴定记录",@"认领交易鉴定",@"鉴定贴回复",@"禁言管理",@"订单鉴定"],
                  ];
    }
    else if ([UserInfoRequestManager sharedInstance].user.blRole_saleAnchor) {
        listArr=@[
//                  @[@"打赏收入"/*,@"直播历史"*/,@"直播封面设置"],
        ];
    }
    [self.view addSubview:self.homeTable];
    [self setHeaderView];
}

- (void)setHeaderView {
    headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 225./375*ScreenW)];
    headerview.backgroundColor=[UIColor colorWithRed:1.00f green:0.89f blue:0.01f alpha:1.00f];
    UIImageView *back = [[UIImageView alloc] initWithFrame:headerview.bounds];
    back.contentMode = UIViewContentModeScaleAspectFill;
    back.image = [UIImage imageNamed:@"bg_mine_top_yellow"];
    [headerview addSubview:back];
    
    self.homeTable.tableHeaderView = headerview;
    self.homeTable.tableHeaderView.mj_size = CGSizeMake(ScreenW,  (225./375)*ScreenW);
    
    [self setupHeaderVewContents];
}

-(void)setupHeaderVewContents {
    
    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.numberOfLines =0;
    headerTitle.backgroundColor=[UIColor clearColor];
    headerTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
    headerTitle.lineBreakMode = NSLineBreakByWordWrapping;
    headerTitle.text = @"欢迎来到直播台";
    headerTitle.font=[UIFont systemFontOfSize:22];
    headerTitle.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [headerview addSubview:headerTitle];
    
    [ headerTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerview).offset(45);
        make.left.equalTo(headerview).offset(0);
        make.right.equalTo(headerview).offset(0);
        
    }];
    
    UILabel *tipTitle = [[UILabel alloc] init];
    tipTitle.numberOfLines =1;
    tipTitle.backgroundColor=[UIColor clearColor];
    tipTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
    tipTitle.lineBreakMode = NSLineBreakByWordWrapping;
    tipTitle.textColor=[UIColor yellowColor];
    tipTitle.text = @"请开始您的直播吧";
    tipTitle.font=[UIFont systemFontOfSize:18];
    tipTitle.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    [headerview addSubview:tipTitle];
    
    [ tipTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerTitle.mas_bottom).offset(5);
        make.left.right.equalTo(headerview);
        
    }];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.backgroundColor = HEXCOLOR(0x222222);
    startBtn.layer.cornerRadius = 2;
    startBtn.layer.masksToBounds = YES;
    [startBtn setTitle:[UserInfoRequestManager sharedInstance].user.blRole_appraiseAnchor?@"开始直播":@"直播卖场" forState:UIControlStateNormal];
    [startBtn setTitleColor:HEXCOLOR(0xffe300) forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [headerview addSubview:startBtn];
    
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipTitle.mas_bottom).offset(33);
        make.centerX.equalTo(tipTitle);
        make.width.equalTo(@230);
        make.height.equalTo(@50);
    }];
    
}

-(UITableView*)homeTable{
    if (!_homeTable) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH) style:UITableViewStyleGrouped];
        _homeTable.delegate = self;
        _homeTable.dataSource = self;
        _homeTable.alwaysBounceVertical = YES;
        _homeTable.scrollEnabled = YES;
        _homeTable.separatorInset = UIEdgeInsetsMake(0,15,0, 0);
        _homeTable.tableFooterView = [[UIView alloc] init];
        _homeTable.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable registerClass:[UITitleValueMoreCell class] forCellReuseIdentifier:@"UITitleValueMoreCell"];
    }
    return _homeTable;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [listArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [(NSArray*)[listArr objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITitleValueMoreCell"];
    NSString *title = [[listArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setTitle:title value:@"" placeholder:@""];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JHCoinRecordViewController *vc = [[JHCoinRecordViewController alloc] init];
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 1) {
            JHSetLiveCoverViewController *vc = [[JHSetLiveCoverViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            JHLiveRecordViewController *vc = [[JHLiveRecordViewController alloc] init];
            vc.roleType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            JHClaimOrderListViewController *vc = [[JHClaimOrderListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
         
            JHDiscoverAppraiseReplyViewController *vc0 = [JHDiscoverAppraiseReplyViewController new];
            [self.navigationController pushViewController:vc0 animated:YES];
        }else if (indexPath.row == 3) {
            JHMuteListViewController *vc = [[JHMuteListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 4) {
            JHAppraiseOrderViewController *vc = [[JHAppraiseOrderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
-(void)buttonPress:(UIButton*)button{
    
    [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
    [NTESLiveManager sharedInstance].liveQuality = NTESLiveQualityHigh;
    [self startVideoPreview];
}
- (void)startVideoPreview
{
    if ( [UserInfoRequestManager sharedInstance].user.blRole_appraiseAnchor) {
        NTESAnchorPreviewController *vc = [[NTESAnchorPreviewController alloc]init];
        vc.anchorLiveType = JHAnchorLiveAppraiseType;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    //直播卖货
    else  if ( [UserInfoRequestManager sharedInstance].user.blRole_saleAnchor || [UserInfoRequestManager sharedInstance].user.blRole_restoreAnchor) {
        JHNormalLivePreviewController *vc = [[JHNormalLivePreviewController alloc]init];
          BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
        vc.type = 1;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
@end



