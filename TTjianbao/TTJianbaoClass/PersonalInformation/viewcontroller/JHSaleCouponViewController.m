//
//  JHSaleCouponViewController.m
//  TTjianbao
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSaleCouponViewController.h"
#import "JHShopCouponTableViewCell.h"
#import "ShopCouponDetailViewController.h"


@interface JHSaleCouponViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation JHSaleCouponViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self removeNavView]; //无基类navbar
    self.pageNo = 1;
    self.pageSize = 10;
    self.view.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self.view addSubview:self.tableView];
    
    [self.view beginLoading];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UITableView*)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.height = ScreenH - UI.statusAndNavBarHeight - 44;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.alwaysBounceVertical=YES;
        _tableView.scrollEnabled=YES;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor=[UIColor clearColor];
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _tableView.mj_header = header;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        //[_tableView.mj_header beginRefreshing];
        _tableView.estimatedRowHeight = 115;
        
    }
    return _tableView;
}


- (UIButton *)createBtn {
    if (!_createBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = kGlobalThemeColor;
        [btn setTitle:@"创建代金券" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(createAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _createBtn = btn;
    }
    
    return _createBtn;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)createAction:(UIButton *)btn {
    if (self.createBlock) {
        self.createBlock(btn);
    }

}

#pragma mark - tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = HEXCOLOR(0xf7f7f7);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"JHShopCouponTableViewCell";
    
    JHShopCouponTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHShopCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    MJWeakSelf
    cell.buttonClick = ^(NSIndexPath *sender) {
        weakSelf.deleteIndexPath = sender;
        [weakSelf deleteRequest];
    };
    cell.indexPath = indexPath;
    cell.state = self.state;
    [cell setMode:self.dataArray[indexPath.section]];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JHSaleCouponModel *model = self.dataArray[indexPath.section];
    ShopCouponDetailViewController *vc = [[ShopCouponDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)refresh {
    self.pageNo = 0;
    [self requestData];
}

- (void)loadMoreData {
    self.pageNo ++;
    [self requestData];
}

- (void)requestData {
    NSDictionary *params = @{@"state":@(self.state),
                             @"pageNo":@(self.pageNo),
                             @"pageSize":@(self.pageSize)
    };
    
    @weakify(self);
    //GET /voucher/seller/all/auth
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/voucher/seller/all/auth") Parameters:params successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [self.view endLoading];
        [self dealData:respondObject];
        
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [self.view makeToast:respondObject.message];
        [self.view endLoading];
        [self endRefresh];
    }];
}

- (void)dealData:(RequestModel *)respondObject {
    [self hiddenDefaultImage];
    NSArray *array = [JHSaleCouponModel mj_objectArrayWithKeyValuesArray:respondObject.data];
    if (self.pageNo == 0) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
    } else {
        [self.dataArray addObjectsFromArray:array];
    }
    [self.tableView reloadData];
    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    } else {
        if(self.state == 1) {
            [self showNodata];
        } else {
            [self showDefaultImageWithView:self.tableView];
        }
    }
    [self endRefresh];
    if (!array || array.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)deleteRequest {
    JHSaleCouponModel *model = self.dataArray[self.deleteIndexPath.section];
    //GET /voucher/buyer/stopGrant/auth
    NSString *urlStr = FILE_BASE_STRING(@"/voucher/buyer/stopGrant/auth");
    
    NSDictionary *params = @{@"sellerId":[UserInfoRequestManager sharedInstance].user.customerId,
                             @"couponId":model.Id
    };
    
    [HttpRequestTool getWithURL:urlStr Parameters:params successBlock:^(RequestModel *respondObject) {
        [self.view makeToast:@"停止成功"  duration:1.0 position:CSToastPositionCenter];
        [self.dataArray removeObjectAtIndex:self.deleteIndexPath.section];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.deleteIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        if (self.dataArray.count) {
            [self hiddenDefaultImage];
        } else {
            if (self.state == 1)
                [self showNodata];
        }
        if (self.countChangedBlock) {
            self.countChangedBlock(self, @(-1));
        }

    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
    }];
}

- (void)showNodata {
    [self showImageName:@"img_no_shop_coupon" title:@"您还没有创建代金券" superview:self.tableView];
    
    UIImageView *image = [self valueForKey:@"imageView"];
    if (image) {
        [image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(image.superview.mas_centerY).offset(-100);
        }];
    }
    
    [self.tableView addSubview:self.createBtn];
    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@120);
        make.centerX.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView).offset(30);
    }];
    self.createBtn.hidden = NO;
}

- (void)hiddenDefaultImage {
    [super hiddenDefaultImage];
    self.createBtn.hidden = YES;
}


#pragma mark -
#pragma mark - JXCategoryListCollectionContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
