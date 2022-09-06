//
//  JHLotteryRecordViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHLotteryRecordViewController.h"
#import "JHLotteryRecordCell.h"
#import "JHUIFactory.h"
#import "JHLotteryDataManager.h"
#import "JHLotteryListController.h"
#import "GrowingManager+Lottery.h"

@interface JHLotteryRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
}
@property(nonatomic,strong) UITableView* homeTable;
@property (nonatomic, strong) JHLotteryModel *curModel;
//记录进入时间
@property (nonatomic, assign) NSTimeInterval enterTime;
@end

@implementation JHLotteryRecordViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"往期记录";
//    [self  initToolsBar];
//    [self.navbar setTitle:@"往期记录"];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeTable];
    __weak typeof(self) weakSelf = self;
    self.homeTable.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.homeTable.mj_header beginRefreshing];
    
      _curModel = [[JHLotteryModel alloc] init];
    _curModel.page = 0;
     _curModel.lotteryType = JHLotteryTypePast;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //记录进入时间
    _enterTime = [YDHelper get13TimeStamp].longLongValue;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self gioBrowseDuration];
}
-(void)loadNewData{
    self.curModel.page = 0;
    [self sendRequest];
}
-(void)loadMoreData{
    self.curModel.page += 1;
    [self sendRequest];
}
#pragma mark -
#pragma mark - 网络请求
- (void)sendRequest {
    @weakify(self);
    [JHLotteryDataManager getLotteryList:_curModel block:^(JHLotteryModel *  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self.view endLoading];
        if (respObj) {
            [self.curModel configModel:respObj];
        }
        [self endRefresh];
        [self.homeTable reloadData];
    }];
}
- (void)endRefresh {
    [self.homeTable.mj_header endRefreshing];
    [self.homeTable.mj_footer endRefreshing];
}

-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight)                                      style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.estimatedRowHeight = 150;
        _homeTable.backgroundColor=[CommHelp toUIColorByStr:@"#f5f5f5"];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.curModel.list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHLotteryRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHLotteryRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setLotteryData:self.curModel.list[indexPath.section]];
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView  *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section < self.curModel.list.count)
    {
        JHLotteryListController *vc = [JHLotteryListController new];
        JHLotteryData *m = self.curModel.list[indexPath.section];
        JHLotteryActivityData *model = m.activityList.firstObject;
        vc.codeStr = model.activityCode;
        vc.isHistory = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        //埋点-进入0元抽详情页
        [GrowingManager lotteryEnterPageName:NSStringFromClass([JHLotteryListController class]) from:JHFromLotteryHistory];
    }
}

//埋点-浏览时长统计
- (void)gioBrowseDuration {
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:_enterTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    
    NSDictionary *params = @{@"duration" : @(duration)};
    [GrowingManager lotteryBrowseDuration:params];
}

- (void)dealloc
{
}
@end
