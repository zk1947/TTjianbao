//
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHMallCouponViewController.h"
#import "JHOrderListTableViewCell.h"
#import "JHLiveRoomMode.h"
#define pagesize 10
#define cellRate (float)  201/345
#import "JHOrderSegmentView.h"
#import "JHMallCouponTableViewCell.h"
#import "JHNewShopDetailViewController.h"

#import "JHGrowingIO.h"
#import "JHUIFactory.h"
@interface JHMallCouponViewController ()<UITableViewDelegate,UITableViewDataSource,JHOrderSegmentViewViewDelegate>
{
    NSInteger PageNum;
    NSArray* rootArr;
    JHOrderSegmentView *  headerView;
    UIView * footerView;
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray<CoponMode*>* coponModes;
@property(nonatomic,strong)  NSString * searchStatus;
@property(nonatomic,strong)  UILabel *footerLabel;
@property(nonatomic,strong)    CoponCountMode * coponCountMode;
@end

@implementation JHMallCouponViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentIndex=0;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self  initToolsBar];
    self.title = @"代金券";
//    [self.navbar setTitle:@"代金券"];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.coponModes=[NSMutableArray arrayWithCapacity:10];
    
    [self.view addSubview:self.homeTable];
    __weak typeof(self) weakSelf = self;
    
     [self setHeaderView];
     [self setFooterView];
    //   self.searchStatus=@"en";
    
    self.homeTable.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.homeTable.mj_footer.hidden=YES;
    [self.homeTable.mj_header beginRefreshing];
}
-(void)setCurrentIndex:(int)currentIndex{
    
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_name"] = @"我的代金券页";
    _currentIndex=currentIndex;
    switch (currentIndex) {
        case 0:
            self.searchStatus=@"en";
            parDic[@"tab_name"] = @"未使用";

            break;
        case 1:
            self.searchStatus=@"ed";
            parDic[@"tab_name"] =  @"已使用";

            break;
        case 2:
            self.searchStatus=@"un";
            parDic[@"tab_name"] =  @"已过期";
            break;
        default:
            break;
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:parDic type:JHStatisticsTypeSensors];

}
- (void)setHeaderView
{
    headerView=[[JHOrderSegmentView alloc]initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, 50)];
    [headerView setUpSegmentView:@[@"未使用",@"已使用",@"已过期"]];
    headerView.delegate=self;
    [headerView setIndicateViewImage:[UIImage imageNamed:@"coupon_segment_image"]];
    [self.view addSubview:headerView];
    
    [headerView setCurrentIndex:self.currentIndex];
}
- (void)setFooterView
{
    footerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    footerView.layer.masksToBounds=YES;
    footerView.backgroundColor=[UIColor clearColor];
    _footerLabel= [[UILabel alloc ]init];
    _footerLabel.text = @"";
    _footerLabel.font=[UIFont systemFontOfSize:9];
    _footerLabel.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    _footerLabel.numberOfLines = 1;
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.textColor = [UIColor lightGrayColor];
    [footerView addSubview:_footerLabel];
    [_footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(footerView);
        make.centerX.equalTo(footerView);
    }];
    
    JHCustomLine *leftLine = [JHUIFactory createLine];
    [footerView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.equalTo(_footerLabel.mas_left).offset(-5);
        make.centerY.equalTo(_footerLabel);
    }];
    
    JHCustomLine *rightLine = [JHUIFactory createLine];
    [footerView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.right.offset(-15);
        make.centerY.equalTo(_footerLabel);
        make.left.equalTo(_footerLabel.mas_right).offset(5);
    }];

    
    _homeTable.tableFooterView=footerView;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
-(void)loadNewData{
    
    PageNum=0;
    [self requestCouponCount];
    [self requestInfo];
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestInfo];
}

- (void)segMentButtonPress:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            self.searchStatus=@"en";
            break;
        case 1:
            self.searchStatus=@"ed";
            break;
        case 2:
            self.searchStatus=@"un";
            break;
        default:
            break;
    }
    
    [self.homeTable.mj_header beginRefreshing];
}

-(void)requestCouponCount{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/voucher/buyer/count/auth") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.coponCountMode=[CoponCountMode mj_objectWithKeyValues:respondObject.data];
    NSArray * arr=@[ [NSString stringWithFormat:@"未使用(%@)",self.coponCountMode.getCount],
                    [NSString stringWithFormat:@"已使用(%@)",self.coponCountMode.usedCount],
                    [NSString stringWithFormat:@"已过期(%@)",self.coponCountMode.invalidCount]];
        [headerView setTitles:arr];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)requestInfo{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/voucher/buyer/all/auth?couponUseStatus=%@&pageNo=%ld&pageSize=%ld"),self.searchStatus,PageNum,pagesize];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
        [self endRefresh];
    }];
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [CoponMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.coponModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.coponModes addObjectsFromArray:arr];
    }
    
    [self.homeTable reloadData];
    
    if ([arr count]<pagesize) {
        self.homeTable.mj_footer.hidden=YES;
        if ([arr count]!=0) {
            if ([self.searchStatus isEqualToString:@"ed"]) {
                self.footerLabel.text=self.coponCountMode.usedCaseRemark;
                footerView.height=30;
            }
            else if ([self.searchStatus isEqualToString:@"un"]) {
                self.footerLabel.text=self.coponCountMode.invalidCaseRemark;
                footerView.height=30;
            }
            else{
                self.footerLabel.text=@"";
                footerView.height=0;
            }
        }
        else{
            self.footerLabel.text=@"";
            footerView.height=0;
        }
        _homeTable.tableFooterView=footerView;
    }
    else{
        
        self.homeTable.mj_footer.hidden=NO;
        self.footerLabel.text=@"";
        footerView.height=0;
        _homeTable.tableFooterView=footerView;
    }
}
- (void)endRefresh {
    
    [self.homeTable.mj_header endRefreshing];
    [self.homeTable.mj_footer endRefreshing];
    if (self.coponModes.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.homeTable];
    }
}

-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight+50, ScreenW, ScreenH-UI.statusAndNavBarHeight-50)                                      style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.estimatedRowHeight = 150;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.coponModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    
    JHMallCouponTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHMallCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        MJWeakSelf
        cell.buttonClick = ^(id sender) {
            
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
            parDic[@"page_position"] = @"我的代金券页";
            parDic[@"couponName"] = weakSelf.coponModes[indexPath.section].name;
            parDic[@"couponId"] = weakSelf.coponModes[indexPath.section].Id;
            [JHAllStatistics jh_allStatisticsWithEventId:@"couponClick" params:parDic type:JHStatisticsTypeSensors];
            
            if (weakSelf.coponModes[indexPath.section].couponUseCategory == 2) {
                JHNewShopDetailViewController *vc = [JHNewShopDetailViewController new];
                vc.shopId = weakSelf.coponModes[indexPath.section].shopId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else{
                [JHRootController EnterLiveRoom:weakSelf.coponModes[indexPath.section].channelId fromString:JHLiveFrommyVoucher];
            }
            
        };
    }
    [cell setMode:self.coponModes [indexPath.section]];
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 10;
    }
    return 5;
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
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}
@end





