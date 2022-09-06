//
//  JHImageAppraisalFinishedViewController.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageAppraisalFinishedViewController.h"
#import "JHImageAppraisalFinishedCell.h"
#import "JHIdentificationDetailsVC.h"
#import "JHImageAppraisalModel.h"
#import "JHImageRecordTimePickerView.h"

@interface JHImageAppraisalFinishedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHImageAppraisalModel * modelData;
@property (nonatomic, assign) JHAppraisalReportType reportType;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation JHImageAppraisalFinishedViewController

- (instancetype)initWithReportType:(JHAppraisalReportType)reportType{
    self = [super init];
    if (self) {
        self.reportType = reportType;
        self.pageNum = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNavView];
    [self setupView];
    [self requestData];
    [self.tableView.mj_header beginRefreshing];

    [self.tableView reloadData];
    
//    [_tableView jh_reloadDataWithEmputyView];
    
}
-(void)loadNewData{
    [self endRefresh];
//    isSection0End=NO;
//    PageNum=0;
    [self requestData];
}
-(void)loadMoreData{
    [self endRefresh];
    self.pageNum++;
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalTask/listPage") Parameters:[self requestDictionary:self.pageNum]  requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [self endRefresh];
        JHImageAppraisalModel *model = [JHImageAppraisalModel mj_objectWithKeyValues:respondObject.data];
        if (model.resultList.count>0) {
            [self.modelData.resultList addObjectsFromArray:model.resultList];
        }else{
            [self.tableView jh_footerStatusWithNoMoreData:YES];
        }
        if (!model.hasMore) {
            [self.tableView jh_footerStatusWithNoMoreData:YES];
        }
        if (self.reportType==1 && self.modelData.total>0 && self.refreshNum) {
            self.refreshNum(self.modelData.total);
        }
        [self.tableView reloadData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];

}
- (void)requestData{
    self.pageNum = 1;
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalTask/listPage") Parameters:[self requestDictionary:1]  requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        self.modelData = [JHImageAppraisalModel mj_objectWithKeyValues:respondObject.data];
        if (!self.modelData.resultList || self.modelData.resultList.count == 0) {
            NSLog(@"错误页面");
//            [self.tableView jh_reloadDataWithEmputyView];
            [self.tableView.jh_EmputyView.textLabel setText:@"无鉴定记录"];
            [self.tableView jh_footerStatusWithNoMoreData:YES];
            self.tableView.mj_footer.hidden = YES;
        }
        if (!self.modelData.hasMore) {
            [self.tableView jh_footerStatusWithNoMoreData:YES];
        }
        if (self.reportType==1 && self.modelData.total>=0 && self.refreshNum) {
            self.refreshNum(self.modelData.total);
        }
        [self.tableView jh_reloadDataWithEmputyView];
        [self.tableView reloadData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
- (NSMutableDictionary *)requestDictionary:(NSInteger)num{
    NSMutableDictionary * parm = [[NSMutableDictionary alloc] init];
    [parm addEntriesFromDictionary:@{@"imageType":@"s",@"pageNo":[NSString stringWithFormat:@"%ld",num],@"pageSize":@"20"}];
    //taskStatus
    //状态 3 已鉴定 4 已取消 100 存疑鉴定
    switch (self.reportType) {
        case 1:
            [parm setValue:@(3) forKey:@"taskStatus"];
            break;
        case 2:
            [parm setValue:@(100) forKey:@"taskStatus"];
            break;
        case 3:
            [parm setValue:@(4) forKey:@"taskStatus"];
            break;
        default:
            [parm setValue:@(3) forKey:@"taskStatus"];
            break;
    }
    [parm setValue:[[JHImageRecordTimePickerView shareManger] getStartTime] forKey:@"appraisalStartFinishTime"];
    [parm setValue:[[JHImageRecordTimePickerView shareManger] getEndTime] forKey:@"appraisalEndFinishTime"];
    return parm;
}

-(void)reloadRecordData{
    [self requestData];
}

- (void)setupView{

    self.view.backgroundColor = HEXCOLOR(0xF5F5F8);
    //列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(8, 0, 0, 0));
    }];
    
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self performSelector:@selector(loadNewData) afterDelay:0.3];
//        [self loadData];
    }];
    self.tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView                               = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        _tableView.backgroundColor                 = HEXCOLOR(0xF5F5F8);
        _tableView.separatorStyle                  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight   = 0.1f;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
    }
    return _tableView;
}

#pragma mark - Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelData.resultList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    JHImageAppraisalRecordInfoModel *model = self.modelData.resultList[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    id viewModel = self.dataSourceArray[indexPath.row];
    
    JHImageAppraisalFinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHImageAppraisalFinishedCell class])];
    if (!cell) {
        cell = [[JHImageAppraisalFinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHImageAppraisalFinishedCell class])];
    }
    [cell setCellModelData:self.modelData.resultList[indexPath.row] withType:self.reportType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHImageAppraisalRecordInfoModel * model = self.modelData.resultList[indexPath.row];
    JHIdentificationDetailsVC *vc = [[JHIdentificationDetailsVC alloc] initWithRecordInfoId:model.recordInfoId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}
@end
