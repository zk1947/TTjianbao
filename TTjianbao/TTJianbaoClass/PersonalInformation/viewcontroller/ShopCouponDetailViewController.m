//
//  ShopCouponDetailViewController.m
//  TTjianbao
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "ShopCouponDetailViewController.h"
#import "JHGetCouponListCellCell.h"
#import "JHShopCouponTableViewCell.h"
#import "JHOrderDetailViewController.h"

#import "UserInfoRequestManager.h"
#import <JXCategoryView.h>

@interface ShopCouponDetailViewController () <UITableViewDelegate,UITableViewDataSource, JXCategoryViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JHShopCouponTableViewCell *tableHeader;
@property (nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSMutableArray *dataArrayUsed;
@property(nonatomic, strong) NSMutableArray *dataArrayUnuse;

@property (nonatomic, assign) NSInteger pageNoUsed;
@property (nonatomic, assign) NSInteger pageSizeUsed;

@property (nonatomic, assign) NSInteger pageNoUnuse;
@property (nonatomic, assign) NSInteger pageSizeUnuse;
@end

@implementation ShopCouponDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeNav];
    self.pageNoUsed = 0;
    self.pageSizeUsed = 10;
    self.pageNoUnuse = 0;
    self.pageSizeUnuse = 10;
    
    self.view.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 135 + 33)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:self.tableHeader];
    self.tableView.tableHeaderView = view;
    [self.tableHeader setHeaderStyle];
    [self requestDetail];
    
    
}
- (void)makeNav {
//    [self  initToolsBar];
//    [self.navbar setTitle:@"代金券详情"];
    self.title = @"代金券详情";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (UITableView*)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.alwaysBounceVertical=YES;
        _tableView.scrollEnabled=YES;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor=[UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHGetCouponListCellCell class]) bundle:nil] forCellReuseIdentifier:@"JHGetCouponListCellCell"];
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        [_tableView.mj_header beginRefreshing];
        
    }
    return _tableView;
}

- (JHShopCouponTableViewCell *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[JHShopCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        _tableHeader.state = 1;
        if (self.model) {
            _tableHeader.mode = self.model;
        }
        _tableHeader.frame = CGRectMake(0, 10, ScreenW, 115 + 33);
        
    }
    return _tableHeader;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.delegate = self;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.cellSpacing = 50;
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _categoryView.titleSelectedColor = HEXCOLOR(0x333333);
        _categoryView.titleFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _categoryView.titleColor = HEXCOLOR(0x999999);
        
        _categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
        _categoryView.titles = @[@"已使用", @"未使用"];
        _categoryView.frame = CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, 40);
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = kGlobalThemeColor;
        lineView.verticalMargin = 1.0f;
        lineView.indicatorWidth = 40;
        lineView.indicatorHeight = 1.5;
        _categoryView.indicators = @[lineView];
        
    }
    return _categoryView;
}


#pragma mark -
#pragma mark - tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 0) {
        return [self.dataArrayUsed count];
        
    } else {
        return [self.dataArrayUnuse count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"JHGetCouponListCellCell";
    
    JHGetCouponListCellCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.type == 0) {
        cell.model = self.dataArrayUsed[indexPath.row];

    }else {
        cell.model = self.dataArrayUnuse[indexPath.row];

    }
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == 0) {
        
        GetCouponUserModel *model = self.dataArrayUsed[indexPath.row];
            JHOrderDetailViewController * detail=[[JHOrderDetailViewController alloc]init];
            detail.orderId=model.orderId;
            detail.isSeller=YES;
            [self.navigationController pushViewController:detail animated:YES];
            
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.categoryView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark -
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.type = index;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)loadOneData {
    if (self.type == 0) {
        self.pageNoUsed = 0;
        [self requestData];
    }else {
        self.pageNoUnuse = 0;
        [self requestData];
    }
    
}
- (void)loadMoreData {
    if (self.type == 0) {
        self.pageNoUsed ++;
        [self requestData];
    }else {
        self.pageNoUnuse ++;
        [self requestData];
    }
    
}

- (void)requestDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"voucherId"] = self.model.Id;
    NSString *string = FILE_BASE_STRING(@"/voucher/seller/getdetail/");
    string = [string stringByAppendingString:self.model.Id];
    string = [string stringByAppendingString:@"/auth"];
    
    [HttpRequestTool getWithURL:string Parameters:dic successBlock:^(RequestModel *respondObject) {
        
        JHSaleCouponModel *model = [JHSaleCouponModel mj_objectWithKeyValues:respondObject.data];
        model.Id = self.model.Id;
        self.tableHeader.mode = model;
        [self.tableHeader setHeaderStyle];

        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
        [self endRefresh];
    }];
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.type == 0) {
        dic[@"pageNo"] = @(self.pageNoUsed);
        dic[@"pageSize"] = @(self.pageSizeUsed);
    }else {
        dic[@"pageNo"] = @(self.pageNoUnuse);
        dic[@"pageSize"] = @(self.pageSizeUnuse);
        
    }
    dic[@"state"] = self.type==0?@"ed":@"en";
    dic[@"voucherId"] = self.model.Id;
    NSString *string = FILE_BASE_STRING(@"/voucher/seller/getdetailbystate/");
    string = [string stringByAppendingString:self.model.Id];
    string = [string stringByAppendingString:@"/auth"];
    
    [HttpRequestTool getWithURL:string Parameters:dic successBlock:^(RequestModel *respondObject) {
        [self dealData:respondObject];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
        [self endRefresh];
    }];
}

- (void)dealData:(RequestModel *)respondObject {
    NSArray *array = [GetCouponUserModel mj_objectArrayWithKeyValuesArray:respondObject.data];
    if (self.type == 0 ) {
        if (self.pageNoUsed == 0) {
            self.dataArrayUsed = [NSMutableArray arrayWithArray:array];
        }else {
            [self.dataArrayUsed addObjectsFromArray:array];
        }
        if (self.dataArrayUsed.count) {
            [self hiddenDefaultImage];
        }else {
            [self showDefaultImageWithView:self.tableView];
        }
    }else {
        if (self.pageNoUnuse == 0) {
            self.dataArrayUnuse = [NSMutableArray arrayWithArray:array];
        }else {
            [self.dataArrayUnuse addObjectsFromArray:array];
        }
        if (self.dataArrayUnuse.count) {
            [self hiddenDefaultImage];
        }else {
            [self showDefaultImageWithView:self.tableView];
        }
    }
    
    [self.tableView reloadData];

    [self endRefresh];
    if (!array || array.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


@end
