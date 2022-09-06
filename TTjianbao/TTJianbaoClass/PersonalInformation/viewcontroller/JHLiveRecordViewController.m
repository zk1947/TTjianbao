//
//  JHLiveRecordViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/17.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHLiveRecordViewController.h"
#import "JHLiveRecordCell.h"
#import "JHLiveRecordModel.h"
#import "JHAppraisalDetailViewController.h"
#import <IQKeyboardManager.h>
#import "JHRecordHeaderFilterView.h"
#import "JHRecordRemarkViewController.h"

@interface JHLiveRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
///筛选view
@property (nonatomic, strong) JHRecordHeaderFilterView *headerView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
///评估标识
@property (nonatomic, copy) NSString *assessmentFlag;
///推荐标识
@property (nonatomic, copy) NSString *recommendFlag;
///时间范围
@property (nonatomic, copy) NSString *timeRange;
///备注填写状态
@property (nonatomic, copy) NSString *remarksStatus;
@end

@implementation JHLiveRecordViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _assessmentFlag = @"normal";
        _recommendFlag = @"normal";
        _timeRange = @"normal";
        _remarksStatus = @"normal";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhTitleLabel.text = @"我的鉴定"; //背景颜色不一致
    self.jhNavBottomLine.hidden = NO;
    ///加载筛选数据
    [self loadFilterData];
    [self makeUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)makeUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHLiveRecordCell class]) bundle:nil] forCellReuseIdentifier:@"JHLiveRecordCell"];
        _tableView.estimatedRowHeight = 300*ScreenW/375.+50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (self.roleType == 1) {
            ///鉴定师端
            _tableView.tableHeaderView = self.headerView;
        }
        
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300*ScreenW/375.+50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHLiveRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHLiveRecordCell"];
    cell.model = self.dataArray[indexPath.row];
    cell.roleType = self.roleType;
    @weakify(self);
    cell.remarkBlock = ^(JHLiveRecordModel * _Nonnull model) {
        @strongify(self);
        [self enterEditRemarkPage:model];
    };
    return cell;
}

- (void)enterEditRemarkPage:(JHLiveRecordModel * _Nonnull)model {
    JHRecordRemarkViewController *vc = [[JHRecordRemarkViewController alloc] init];
    vc.appraiseRecordId = model.appraiseId;
    vc.remark = model.remark;
    @weakify(self);
    vc.backBlock = ^{
        @strongify(self);
        ///刷新数据
        [self loadOneData];
    };
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHLiveRecordModel *mode = self.dataArray[indexPath.row];
    if (self.roleType == 0) {
        if (mode.reportId.length>0 )
        {
            JHAppraisalDetailViewController *player = [[JHAppraisalDetailViewController alloc] initWithAppraisalId:mode.appraiseId ];
            player.from = 4;
            [self.navigationController pushViewController:player animated:YES];
        }
        else {
            [self.view makeToast:@"报告未生成，请稍后再试"];
        }
    }else {
        JHAppraisalDetailViewController *player = [[JHAppraisalDetailViewController alloc] initWithAppraisalId:mode.appraiseId ];
        player.from = 4;
        [self.navigationController pushViewController:player animated:YES];
    }
}
#pragma mark - 请求数据
- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 10;
    [self.tableView.mj_footer resetNoMoreData];
    [self requestData];
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 10;
    [self requestData];
}

- (void)requestData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(_pageNo) forKey:@"pageNo"];
    [params setValue:@(_pageSize) forKey:@"pageSize"];
    [params setValue:self.assessmentFlag forKey:@"assessmentFlag"];
    [params setValue:self.recommendFlag forKey:@"recommendFlag"];
    [params setValue:self.timeRange forKey:@"timeRange"];
    [params setValue:self.remarksStatus forKey:@"remarksStatus"];
    
    NSString *url = FILE_BASE_STRING(@"/appraiseRecord/viewer/auth");
    if (self.roleType == 1) {
        url = FILE_BASE_STRING(@"/appraiseRecord/anchor/video/auth");
    }else if (self.roleType == 0) {
        url = FILE_BASE_STRING(@"/appraiseRecord/viewer/video/auth");
    }
    
    [HttpRequestTool getWithURL:url Parameters:params successBlock:^(RequestModel *respondObject) {
        [self dealDataWithDic:respondObject.data];
        [self endRefresh];
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)endRefresh {
    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.tableView];
    }
}
- (void)dealDataWithDic:(NSArray *)array {
    NSArray *arr = [JHLiveRecordModel mj_objectArrayWithKeyValuesArray:array];
    if (self.pageNo<=0) {
        [_tableView.mj_header endRefreshing];
    }
    else {
        if (arr.count > 0) {
            [_tableView.mj_footer endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    if (self.pageNo == 0) {
        self.dataArray = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataArray addObjectsFromArray:arr];
    }
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGFloat keyBoradHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    for (JHAppraisalReportView *v in self.view.subviews) {
//        if ([v isKindOfClass:[JHAppraisalReportView class]]) {
//            if (v.stepIndex == 1) {
//                v.mj_y = ScreenH- (420+keyBoradHeight);
//            }
//        }
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    for (JHAppraisalReportView *v in self.view.subviews) {
//        if ([v isKindOfClass:[JHAppraisalReportView class]]) {
//            if (v.stepIndex == 1) {
//                v.mj_y = ScreenH - (420+UI.bottomSafeAreaHeight);
//            }
//        }
//    }
}

- (JHRecordHeaderFilterView *)headerView {
    if (!_headerView) {
        _headerView = [[JHRecordHeaderFilterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 197) filterCount:4];
        @weakify(self);
        _headerView.selectBlock = ^(JHRecordFilterMenuModel * _Nonnull tagModel, JHFilterType filterType) {
            @strongify(self);
            [self toFilterListData:tagModel.keyword filterType:filterType];
        };
    }
    return _headerView;
}

- (void)toFilterListData:(NSString *)filterKey filterType:(JHFilterType)filterType {
    switch (filterType) {
        case JHFilterTypeAssessment:
            _assessmentFlag = filterKey;
            break;
        case JHFilterTypeRecommend:
            _recommendFlag = filterKey;
            break;
        case JHFilterTypeTimeRange:
            _timeRange = filterKey;
            break;
        case JHFilterTypeRemark:
            _remarksStatus = filterKey;
            break;
        default:
            break;
    }
    ///刷新数据
    [self loadOneData];
}

- (void)loadFilterData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JHRecordFilterList" ofType:@"plist"];
    NSArray *listArray = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *modelsArray = [JHRecordFilterModel mj_objectArrayWithKeyValuesArray:listArray];
    self.headerView.filterModels = modelsArray;
}

@end
