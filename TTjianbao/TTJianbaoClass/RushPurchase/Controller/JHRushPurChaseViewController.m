//
//  JHRushPurChaseViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurChaseViewController.h"
#import "JHRecycleUploadTypeTableViewCell.h"
#import "JHSQBannerView.h"
#import "JHRecycleUploadProductBusiness.h"
#import "BannerMode.h"
#import <SDWebImage.h>
#import "SVProgressHUD.h"
#import "CommAlertView.h"
#import "JHRushPurChaseCell.h"
#import "JHRushPurChaseSectionHeader.h"
#import "JHRushPurBusiness.h"
#import "JHRushPurChaseCellViewModel.h"
#import "JHStoreDetailViewController.h"
#import "JHBaseOperationView.h"



@interface JHRushPurChaseViewController ()<UITableViewDelegate, UITableViewDataSource>

/// 轮播图
@property(nonatomic, strong) JHSQBannerView * bannerView;
@property(nonatomic, strong) JHRushPurChaseSectionHeader * sectionHeader;
@property(nonatomic, strong) UITableView * tableView;

/// 类型种类数组
@property (nonatomic, strong) NSArray<JHRecycleUploadSeleteTypeListModel*> *listModelArr;
/// banner数组
@property (nonatomic, strong) NSArray<JHRecycleUploadSeleteTypeBannerModel*> *bannerModelArr;


@property(nonatomic, strong) NSMutableArray<JHRushPurChaseCellViewModel*> * cellViewModelArr;

@property(nonatomic, strong) JHRushPurChaseModel * purChaseModel;

//秒杀时间段
@property (nonatomic, strong) NSArray<JHRushPurChaseSeckillTimeModel*> * seckillTimeList;

//list数据
@property (nonatomic, strong) NSMutableArray<JHRushPurChaseSeckillProductInfoModel*> *  resultList;

//秒杀倒计时描述
@property (nonatomic, strong) NSString* seckillCountdownDesc;
//秒杀倒计时
@property (nonatomic) NSInteger seckillCountdown;

@property(nonatomic, assign) BOOL  hasFirstReq;

//ReqDic
@property(nonatomic, strong) NSMutableDictionary * parDic;

@property(nonatomic, assign) NSInteger  seletIndex;

@end

@implementation JHRushPurChaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天天秒杀";
    self.seletIndex = 0;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(noticeRefresh) name:@"JHRushPurChaseViewController_RefershData" object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(noticeTimerRefresh) name:UIApplicationDidBecomeActiveNotification object:nil];

    [self setNav];
    [self refreshCurrentDataFirst:YES];
    [self addStatistic];
}

#pragma mark -- <RefreshData>
- (void)refreshCurrentDataFirst:(BOOL)first{
    [SVProgressHUD show];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"pageNo"] = @1;
    parDic[@"pageSize"] = @20;
    parDic[@"thatDay"] = @YES;
    self.parDic = parDic;
    self.resultList = [NSMutableArray arrayWithCapacity:0];
    @weakify(self);
    [JHRushPurBusiness  requestRushPur:self.parDic
                            completion:^(NSError * _Nullable error, JHRushPurChaseModel * _Nullable model) {
        @strongify(self);
        [SVProgressHUD dismiss];
        self.tableView.contentOffset = CGPointZero;
        self.purChaseModel = model;
        self.seckillCountdownDesc = self.purChaseModel.seckillCountdownDesc ;
        self.seckillCountdown = self.purChaseModel.seckillCountdown;
        [self.resultList addObjectsFromArray: model.productPageResult.resultList];
        self.seckillTimeList = model.seckillTimeList;
        if(first){
            [self setItems];
            [self layoutItems];
        }
        [self refreshSectionHeaderlOnlyTitle:NO];
        [self refreshCellviewModelWithShowId:@(model.showId).stringValue];
        [self refershBanner];
        [self.tableView.mj_footer resetNoMoreData];
    }];

}
- (void)noticeRefresh{
    [self refreshCurrentDataFirst:NO];
}

- (void)noticeTimerRefresh{
    [JHRushPurBusiness  requestRushPur:self.parDic
                            completion:^(NSError * _Nullable error, JHRushPurChaseModel * _Nullable model) {
        self.seckillCountdownDesc = model.seckillCountdownDesc ;
        self.seckillCountdown = model.seckillCountdown;
        [self refreshSectionHeaderlOnlyTitle:YES];
    }];
}


- (void)refreshWithOtherIndex{
    [SVProgressHUD show];
    self.resultList = [NSMutableArray arrayWithCapacity:0];
    @weakify(self);
    [JHRushPurBusiness  requestRushPur:self.parDic
                            completion:^(NSError * _Nullable error, JHRushPurChaseModel * _Nullable model) {
        @strongify(self);
        [SVProgressHUD dismiss];
        self.tableView.contentOffset = CGPointZero;
        self.seckillCountdownDesc = model.seckillCountdownDesc ;
        self.seckillCountdown = model.seckillCountdown;
        [self.resultList addObjectsFromArray: model.productPageResult.resultList];
        [self refreshSectionHeaderlOnlyTitle:YES];
        [self refreshCellviewModelWithShowId:@(model.showId).stringValue];
        [self.tableView.mj_footer resetNoMoreData];
    }];
}

- (void)refrshDataWithIndex:(NSInteger)index{
    if (!self.hasFirstReq) {
        self.hasFirstReq = YES;
        return;
    }
    self.seletIndex = index;
    if (index == 0) {
        [self refreshCurrentDataFirst:NO];
    }else{
        JHRushPurChaseSeckillTimeModel * model = self.seckillTimeList[index];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"pageNo"] = @1;
        dic[@"thatDay"] = @(model.thatDay);
        dic[@"pageSize"] = @20;
        dic[@"seckillNumId"] = @(model.seckillNumId);
        dic[@"seckillNumStatus"] = @(model.seckillNumStatus);
        self.parDic = dic;
        [self refreshWithOtherIndex];
    }
}

- (void)getMoreProduct{
     NSNumber* page = self.parDic[@"pageNo"];
    self.parDic[@"pageNo"] = @(page.integerValue + 1);
    @weakify(self);
    [JHRushPurBusiness  requestRushPur:self.parDic
                            completion:^(NSError * _Nullable error, JHRushPurChaseModel * _Nullable model) {
        @strongify(self);
        [self.resultList addObjectsFromArray: model.productPageResult.resultList];
        if (model.productPageResult.hasMore) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self refreshCellviewModelWithShowId:@(model.showId).stringValue];
    }];

}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark -- <RefreshViews>
- (void)refershBanner{
    BannerCustomerModel* model = [[BannerCustomerModel alloc] init];
    model.image = self.purChaseModel.bgImage.url;
    model.title = @"";
    NSArray<BannerCustomerModel*> *arr = @[model];
    self.bannerView.bannerList = arr;
}

- (void)refreshSectionHeaderlOnlyTitle:(BOOL)only{
    if (!only) {
        self.sectionHeader.seckillTimeList = self.seckillTimeList;
    }
    self.sectionHeader.seckillCountdownDesc = self.seckillCountdownDesc;
    self.sectionHeader.seckillCountdown = self.seckillCountdown;
}


- (void)refreshCellviewModelWithShowId:(NSString*)showId{
    self.cellViewModelArr  = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<self.resultList.count ; i++) {
        JHRushPurChaseCellViewModel *viewModel = [JHRushPurChaseCellViewModel rushPurChaseCellViewModelWithModel:self.resultList[i]];
        viewModel.showId = showId;
        [self.cellViewModelArr addObject:viewModel];
    }
    [self.tableView jh_reloadDataWithEmputyView];
    [self.tableView.jh_EmputyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0).offset(100);
    }];
}

#pragma mark -- <Actions>

/// 分享
- (void)didClickShare: (UIButton *)sender {
    JHShareInfo *shareInfo = [JHShareInfo new];
    shareInfo.title = self.purChaseModel.shareMainTitle;
    shareInfo.desc = self.purChaseModel.shareSubtitle;
    shareInfo.url = self.purChaseModel.shareUrl;
    if (shareInfo == nil) { return; }
    [JHBaseOperationView showShareView:shareInfo objectFlag:nil];
}


#pragma mark -- <Items>
- (void)setItems{
    [self.view addSubview:self.tableView];
}

- (void)layoutItems{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
}
- (void)setNav{
    [self initRightButtonWithImageName:@"newStore_share_black_icon" action:@selector((didClickShare:))];

}
#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHRushPurChaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHRushPurChaseCell.class) forIndexPath:indexPath];
    cell.viewModel = self.cellViewModelArr[indexPath.row];
    return  cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellViewModelArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(!self.purChaseModel){
        return [UIView new];
    }
    return self.sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!self.purChaseModel){
        return 0.1;
    }
    return 114;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHRushPurChaseCellViewModel *viewModel  = self.cellViewModelArr[indexPath.row];
    JHRushPurChaseSeckillProductInfoModel *model  = self.resultList[indexPath.row];
    JHRushPurChaseSeckillTimeModel *seckModel = self.seckillTimeList[self.seletIndex];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"commodity_id"] = viewModel.productId;
    parDic[@"seckill_price"] = model.productSeckillPrice.numberValue;
    parDic[@"zc_id"] = viewModel.showId;
    parDic[@"seckill_time"] = seckModel.timeDesc;
    parDic[@"model_type"] = seckModel.statusDesc;
    parDic[@"page_position"] = @"商城秒杀落地页";
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:parDic type:JHStatisticsTypeSensors];
    
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.productId = viewModel.productId;
    [detailVC.refreshUpper subscribeNext:^(NSString *  _Nullable x) {
        if ([x isEqualToString:@"remind"]) {
            viewModel.status  = JHRushPurChaseCell_Status_ReMinded;
        }
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- <set and get>

- (JHSQBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[JHSQBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160) andEdge:UIEdgeInsetsZero andClickBlock:^(BannerCustomerModel * _Nonnull bannerData, NSInteger selectIndex) {
        }];
        _bannerView.backgroundColor = kColorF5F6FA;
        _bannerView.type = JHBannerAdTypeRecycle;
        _bannerView.notCornerRadius = YES;
    }
    return _bannerView;
}
- (JHRushPurChaseSectionHeader *)sectionHeader{
    if (!_sectionHeader) {
        _sectionHeader = [JHRushPurChaseSectionHeader new];
        @weakify(self);
        [RACObserve(_sectionHeader, seletedIndex)  subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self refrshDataWithIndex:[x integerValue]];
        }];
    }
    return _sectionHeader;
}
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = 100;
        if (self.purChaseModel.bgImage) {
            view.tableHeaderView = self.bannerView;
        }
        view.tableFooterView = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.showsVerticalScrollIndicator = NO;
        view.estimatedRowHeight = 0;
        view.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0);
        [view registerClass:JHRushPurChaseCell.class forCellReuseIdentifier:NSStringFromClass(JHRushPurChaseCell.class)];
        @weakify(self);
        
        view.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self getMoreProduct];
        }];
        
        _tableView = view;
    }
    return _tableView;
}


#pragma mark -- <打点统计>
- (void)addStatistic{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_name"] = @"商城秒杀落地页";
    parDic[@"commodity_id"] = self.productId;
    parDic[@"position_source"] = self.from;
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:parDic type:JHStatisticsTypeSensors];
}

@end

