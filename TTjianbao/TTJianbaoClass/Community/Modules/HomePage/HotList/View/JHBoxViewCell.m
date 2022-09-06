//
//  JHBoxViewCell.m
//  TaodangpuAuction
//
//  Created by yuyue_mp1517 on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "UIScrollView+JHEmpty.h"
#import "JHBoxViewCell.h"
#import "JHHotListTableViewCell.h"
#import "JHHotListModel.h"
#import "JHSQManager.h"
#import "JHHotListSectionHeader.h"
#import "JHSQApiManager.h"
#import "UIView+Blank.h"

@interface JHBoxViewCell()<UITableViewDelegate, UITableViewDataSource>
///热帖数据
@property (nonatomic, strong) NSMutableArray *listArray;
///上一个日期
@property (nonatomic, copy) NSString *lastDateString;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) JHHotListModel *model;

/// 列表某一次展示ID集合
@property (nonatomic, strong) NSMutableDictionary *idsDic;

/// 向上临界一次
@property (nonatomic, assign) BOOL upOnce;

@end
@implementation JHBoxViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:@"HeadSearchStatus" object:nil];
//        self.upOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"HeadSearchStatus"];
    }
    return self;
}

- (void)addSelfSubViews
{
    _lastDateString = [CommHelp getCurrentTime:@"yyyy-MM-dd"];
    self.backgroundColor = UIColor.clearColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.clearColor;
    [self.tableView registerClass:[JHHotListTableViewCell class] forCellReuseIdentifier:kHotListCellIdentifer];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(1, 0, 0, 0));
    }];
    [self addTableViewScrollObserver];
}

- (void)changeStatus:(NSNotification *)not{
//    self.upOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"HeadSearchStatus"];
}

- (void)addTableViewScrollObserver{
    @weakify(self);
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
                
        CGPoint offset = [x CGPointValue];
        CGFloat scrollY = offset.y;
        //向上临界一次
        if (!self.upOnce && scrollY>30) {
            self.upOnce = YES;
            if (self.headScrollBlock) {
                self.headScrollBlock(YES);
            }
        }
        //向下临界一次
        if (self.upOnce && scrollY<=0) {
            self.upOnce = NO;
            if (self.headScrollBlock) {
                self.headScrollBlock(NO);
            }
        }
    }];
}

-(void)updateWithModel:(JHHotListModel *)model
{
    self.model = model;
    [self.tableView reloadData];
    if (!model.is_begin) {
        [self configBlankType:YDBlankTypeNone hasData:model.list.count hasError:NO offsetY:40.f reloadBlock:nil];
    }
}

- (void)setIsRefresh:(BOOL)isRefresh
{
    _isRefresh = isRefresh;
    if(_isRefresh)
    {
        @weakify(self);
        [self.tableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            self.lastDateString = [CommHelp getCurrentTime:@"yyyy-MM-dd"];
            [self loadHotListData];
        } footerWithRefreshingBlock:nil];
        
        [[[JHNotificationCenter rac_addObserverForName:TableBarSelectNotifaction object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification)
         {
            @strongify(self);
            
            if(self.tableView.mj_header)
            {
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                [self.tableView.mj_header beginRefreshing];
            }
            
        }];
    }
    else
    {
        self.tableView.mj_header = nil;
    }
}

- (void)loadHotListData
{
    @weakify(self);
    [JHSQApiManager getHotPostList:_lastDateString completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            JHHotListModel *model = respObj;
            if (!hasError && model)
            {
                self.model = model;
                [self.tableView reloadData];
            }
        }
        [self.tableView jh_endRefreshing];
        if (self.headScrollBlock) {
            self.headScrollBlock(NO);
        }
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.list.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        return self.model.list.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
    {
        JHPostData *postData = self.model.list[indexPath.row];
        JHHotListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotListCellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sortNum = indexPath.row + 1;
        cell.postData = postData;
        return cell;
    }
    else
    {
        JHHotListSectionFooter *cell = [JHHotListSectionFooter dequeueReusableCellWithTableView:tableView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        ///340埋点- 点击了帖子
        JHPostData *postData = self.model.list[indexPath.row];
        [JHGrowingIO trackEventId:JHTrackSQHotTwitterEnter variables:@{@"item_id":postData.item_id}];
        ///340埋点 - BI埋点
        [[JHBuryPointOperator shareInstance] buryWithEtype:JHTrackSQHotTwitterEnter param:@{@"item_id":postData.item_id}];
        
        [JHRouterManager pushPostDetailWithItemType:postData.item_type itemId:postData.item_id pageFrom:JHFromHotArticleList scrollComment:0];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0)
    {
        JHHotListSectionHeader *header = [JHHotListSectionHeader dequeueReusableHeaderFooterViewWithTableView:tableView];
        header.dateTimeString = self.model.now_date;
        return header;
    }
    else
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenH, 1)];
    } 
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenH, 1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 60.f : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JHHotListTableViewCell cellHeight];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    JHPostData *data = self.model.list[indexPath.row];
    if(data.item_type == JHPostItemTypeAppraisalVideo || data.item_type == JHPostItemTypeTopic || data.item_type == JHPostItemTypeDynamic || data.item_type == JHPostItemTypePost || data.item_type == JHPostItemTypeVideo)
    {
        if(data.item_id)
        {
            [self.idsDic setObject:data.item_id forKey:data.item_id];
        }
    }
}

- (void)viewDidDisappearMethod
{
    NSString *IDS = @"";
    for (NSString *ids in self.idsDic.allKeys) {
        if(IDS.length > 0)
        {
            IDS = [NSString stringWithFormat:@"%@,%@",IDS,ids];
        }
        else
        {
            IDS = ids;
        }
    }
    if(IDS.length > 0)
    {
        [[JHBuryPointOperator shareInstance] buryWithEtype:@"hot_Twitter_exposure" param:@{@"browse_id" : IDS}];
    }
    
    [self.idsDic removeAllObjects];
}

#pragma mark - lazy loading
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

/// 曝光帖子ID集合
-(NSMutableDictionary *)idsDic
{
    if(!_idsDic)
    {
        _idsDic = [NSMutableDictionary new];
    }
    return _idsDic;
}

@end
