//
//  JHAmountManageViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/27.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAmountManageViewController.h"
#import "JHAmountRecordViewController.h"
#import "JHAccountModel.h"
#import "JHTakeOutViewController.h"


#define headViewRate (float) 160./375
#define headViewHeight ((headViewRate)*(ScreenW)+UI.bottomSafeAreaHeight)
#define cellHeight 55.

@interface JHAmountManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *headerview;
    NSArray *listArr;
    NSArray *imageArr;
    UILabel *countLabel;
    UILabel *amountLabel;
    
}
@property(nonatomic,strong) UITableView* homeTable;

@end

@implementation JHAmountManageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    listArr = @[
                @[@"提现"],
                @[@"资金记录"],
                ];
    imageArr = @[@[@"icon_shop_takeout"],
                 @[@"icon_shop_amount_record"],
                 ];

    [self.view addSubview:self.homeTable];
    [self setHeaderView];
    
//    [self  initToolsBar];
//    [self.navbar setTitle:@"资金管理"];
    self.title = @"资金管理"; //背景颜色不一致
    self.jhTitleLabel.textColor = [UIColor whiteColor];
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self.jhLeftButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
//    self.navbar.titleLbl.textColor = [UIColor whiteColor];
//    self.navbar.ImageView.hidden = YES;
//    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:[UIImage imageNamed:@"icon_back_white"] withHImage:[UIImage imageNamed:@"icon_back_white"] withFrame:CGRectMake(0,0,44,44)];
//    self.navbar.backgroundColor = [UIColor clearColor];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setHeaderView
{
    headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headViewHeight)];
    headerview.backgroundColor = HEXCOLOR(0xfba028);
    
//
//    UIImageView *back = [[UIImageView alloc] initWithFrame:headerview.bounds];
//    back.contentMode = UIViewContentModeScaleAspectFill;
//    back.image = [UIImage imageNamed:@"bg_shop_top"];
//    [headerview addSubview:back];
    
    self.homeTable.tableHeaderView = headerview;
    self.homeTable.tableHeaderView.mj_size = CGSizeMake(ScreenW,  headViewHeight);
    
    [self setupHeaderVewContents];
}
-(void)setupHeaderVewContents{
//    User *user = [UserInfoRequestManager sharedInstance].user;
   
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusBarHeight+80, 1, 50)];
    line.backgroundColor = [UIColor whiteColor];
    line.center = CGPointMake(self.view.center.x, line.center.y);
    [headerview addSubview:line];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, line.mj_y, line.mj_x, 35)];
    countLabel.font = [UIFont fontWithName:kFontBoldDIN size:30];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.text = @"--";
    [headerview addSubview:countLabel];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(countLabel.frame), countLabel.mj_w, 18)];
    title1.textColor = [UIColor whiteColor];
    title1.textAlignment = NSTextAlignmentCenter;
    title1.font = [UIFont systemFontOfSize:15];
    title1.text = @"结算中";
    [headerview addSubview:title1];
    
    amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame), line.mj_y, line.mj_x, 35)];
    amountLabel.font = [UIFont fontWithName:kFontBoldDIN size:30];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.text = @"--";
    [headerview addSubview:amountLabel];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(amountLabel.mj_x, CGRectGetMaxY(amountLabel.frame), amountLabel.mj_w, 18)];
    title2.textColor = [UIColor whiteColor];
    title2.textAlignment = NSTextAlignmentCenter;
    title2.font = [UIFont systemFontOfSize:15];
    title2.text = @"可提现";
    [headerview addSubview:title2];
    
    
}

-(UITableView*)homeTable{
    
    if (!_homeTable) {
        
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH) style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _homeTable.bounces = NO;
        
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
    
    static NSString *CellIdentifier=@"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.textLabel.text=[[listArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.section][indexPath.row]];
    cell.detailTextLabel.font = [UIFont fontWithName:kFontBoldDIN size:18];
    cell.detailTextLabel.textColor = HEXCOLOR(0xFF4200);
    
    if ([cell.textLabel.text isEqualToString:@"提现"]) {
        cell.detailTextLabel.text = amountLabel.text;
    }else {
        cell.detailTextLabel.text = @"";
    }

    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGFLOAT_MIN;
    }
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
            JHTakeOutViewController *vc = [[JHTakeOutViewController alloc] init];
//            [self.view makeToast:@"功能正在紧张开发中，请先联系客服提现"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            JHAmountRecordViewController *vc = [[JHAmountRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)requestData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/account") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHAccountModel *model = [JHAccountModel mj_objectWithKeyValues:respondObject.data];
        amountLabel.text = [NSString stringWithFormat:@"¥%@",model.cashFreeBalance];
        countLabel.text = [NSString stringWithFormat:@"¥%@",model.cashFrozenBalance];
        [self.homeTable reloadData];
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
@end
