//
//  JHPlatformResultsViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPlatformResultsViewController.h"
#import "JHPlatformResultsDescCell.h"
#import "JHPlatformResultsResonTableViewCell.h"
//#import "JHRejectShowContactCell.h"
#import "UIView+AddSubviews.h"
#import "JHPlatformResultInfo.h"

@interface JHPlatformResultsViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) JHPlatformResultInfo *data;
@property (nonatomic, strong) NSArray<NSString*> *resultTexts;

@end

@implementation JHPlatformResultsViewController

#pragma mark - life cyle 1、控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reportPageView];
}


- (void)dealloc {
    NSLog(@"拒绝说明ViewController-%@ 释放", [self class]);
}

#pragma mark - 2、不同业务处理之间的方法

#pragma mark - Network 3、网络请求

#pragma mark - Action Event 4、响应事件

#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F6FA);
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JHPlatformResultsDescCell *cell = [JHPlatformResultsDescCell cellWithTableView:tableView];
        cell.reasonText = self.resultTexts[self.data.arbResult];
        return cell;
    }
    JHPlatformResultsResonTableViewCell *cell = [JHPlatformResultsResonTableViewCell cellWithTableView:tableView];
    cell.model = self.data;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tabelView) {
            cell.backgroundView = [self.view renderCornerRadiusWithCell:cell indexPath:indexPath tableView:tableView cornerRadius:8];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        NSLog(@"section=%ld",indexPath.section);
    }
}

#pragma mark - interface 7、UI处理
-(void)setupViews{
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.title = @"平台介入结果";
    
    [self.view addSubview:self.tabelView];
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 10.f, 0.f, 10.f));
    }];
    
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}

- (void)loadData {
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/abrResultInfo") Parameters:@{@"orderId":self.orderId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = respondObject.data;
        self.data = [JHPlatformResultInfo mj_objectWithKeyValues:dic];
        [self.tabelView reloadData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark - lazy loading 8、懒加载
- (UITableView *)tabelView {
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabelView.dataSource = self;
        _tabelView.delegate = self;
        _tabelView.backgroundColor = HEXCOLOR(0xF5F6FA);
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.estimatedRowHeight = 60;
        _tabelView.rowHeight = UITableViewAutomaticDimension;
        if (@available(iOS 11.0, *)) {
            _tabelView.estimatedSectionHeaderHeight = 0.1f;
            _tabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

        if ([_tabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _tabelView;
}
- (NSArray<NSString *> *)resultTexts {
    if (!_resultTexts) {
        _resultTexts = @[@"",@"同意退款",@"拒绝退款",@"同意退货",@"拒绝退货"];
    }
    return _resultTexts;
}

#pragma mark - 埋点
/// 页面埋点
- (void)reportPageView {
    NSDictionary *par = @{
        @"page_name" : @"集市查看平台介入页",
        @"order_id" : self.orderId,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end
