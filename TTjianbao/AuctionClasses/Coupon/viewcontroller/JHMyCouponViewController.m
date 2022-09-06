//
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHMyCouponViewController.h"
#import "JHOrderListTableViewCell.h"
#define pagesize 10
#define cellRate (float)  201/345
#import "JHOrderSegmentView.h"
#import "JHMyCouponTableViewCell.h"
#import "JHLiveRoomMode.h"

#import "JHCoponNoteAlertView.h"
#import "JHUIFactory.h"
@interface JHMyCouponViewController ()<UITableViewDelegate,UITableViewDataSource,JHOrderSegmentViewViewDelegate>
{
    NSInteger PageNum;
    NSArray* rootArr;
    JHOrderSegmentView *  headerView;
    UIView * footerView;
    JHLiveRoomMode * selectLiveRoom;
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray<CoponMode*>* coponModes;
@property(nonatomic,strong)  NSString * searchStatus;
@property(nonatomic,strong)  UILabel *footerLabel;
@property(nonatomic,strong)    CoponCountMode * coponCountMode;
 
@end

@implementation JHMyCouponViewController
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
//   
//    [self.navbar setTitle:@"我的红包"];
    self.title = @"我的红包";
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
    
    _currentIndex=currentIndex;
    switch (currentIndex) {
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
    [self sendPointEvent];
}
///埋点
- (void)sendPointEvent{
    NSString *tabStr;
    if ([self.searchStatus isEqualToString:@"ed"]) {
        tabStr = @"已使用";
    }else if ([self.searchStatus isEqualToString:@"un"]){
        tabStr = @"已过期";
    }else{
        tabStr = @"未使用";
    }
    NSDictionary *dic = @{
        @"page_name":@"我的红包页",
        @"tab_name":tabStr
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:dic type:JHStatisticsTypeSensors];
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
    [self sendPointEvent];
}

-(void)requestCouponCount{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/coupon/count/auth") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        self.coponCountMode=[CoponCountMode mj_objectWithKeyValues:respondObject.data];
        NSArray * arr=@[ [NSString stringWithFormat:@"未使用(%@)",self.coponCountMode.enUse],
                         [NSString stringWithFormat:@"已使用(%@)",self.coponCountMode.used],
                         [NSString stringWithFormat:@"已过期(%@)",self.coponCountMode.unUse]];
        [headerView setTitles:arr];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)requestInfo{
    
   NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/coupon/list/auth?couponUseStatus=%@&pageNo=%ld&pageSize=%ld"),self.searchStatus,PageNum,pagesize];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [UITipView showTipStr:respondObject.message];
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
        _homeTable.backgroundColor=[CommHelp toUIColorByStr:@"#f5f5f5"];
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
    
    JHMyCouponTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHMyCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
         MJWeakSelf
         cell.buttonClick = ^(id sender) {
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             if (weakSelf.coponModes[indexPath.section].couponUseCategory == 2) {
                 [JHRootController setTabBarSelectedIndex:2];
             }else if (weakSelf.coponModes[indexPath.section].couponUseCategory == 3) {
                 [JHRootController setTabBarSelectedIndex:0];
             }
             else{
                 [JHRootController setTabBarSelectedIndex:1];
             }
             //埋点
             CoponMode *mode = self.coponModes [indexPath.section];
             NSDictionary *dic = @{
                 @"page_position":@"我的红包页",
                 @"couponName":mode.name,
                 @"couponId":mode.Id
             };
             [JHAllStatistics jh_allStatisticsWithEventId:@"couponClick" params:dic type:JHStatisticsTypeSensors];
        };
        cell.introduceClick = ^(int cellIndex) {
         
            CoponMode * mode=weakSelf.coponModes[indexPath.section];
            [weakSelf showIntroduce:mode.Id];
        };
    }
     [cell setMode:self.coponModes [indexPath.section]];
      cell.cellIndex=(int)indexPath.section;
    
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
-(void)showIntroduce:(NSString*)coponId{
    
    [CoponMode requestEnableUsedSeller:coponId completion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            JHCoponNoteAlertView *alert = [[JHCoponNoteAlertView alloc]initWithTitle:@"可用直播间" andDesc:respondObject.data cancleBtnTitle:@"我知道了"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            
        }
        
    }];
    
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




