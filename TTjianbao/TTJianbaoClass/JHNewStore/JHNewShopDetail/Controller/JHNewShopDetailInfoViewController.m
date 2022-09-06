//
//  JHNewShopDetailInfoViewController.m
//  TTjianbao
//
//  Created by user on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailInfoViewController.h"
#import "JHNewShopDetailInfoHeaderViewCell.h"
#import "JHNewShopDetailInfoScoreViewCell.h"
#import "JHNewShopDetailInfoTimeViewCell.h"
#import "JHNewShopDetailInfoModel.h"

#import "JHAuthAlertView.h"
#import "JHUserAuthVerificationView.h"
#import "JHWebViewcontroller.h"

@interface JHNewShopDetailInfoViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView    *shopTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation JHNewShopDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺信息";
    self.view.backgroundColor = HEXCOLOR(0xF5F5F8);
    [self setupViews];
    [self loadData];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}

- (void)setupViews {
    [self.view addSubview:self.shopTableView];
    [self.shopTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 10.f, 0.f, 10.f));
    }];
}

- (UITableView *)shopTableView {
    if (!_shopTableView) {
        _shopTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _shopTableView.dataSource                     = self;
        _shopTableView.delegate                       = self;
        _shopTableView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _shopTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _shopTableView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _shopTableView.estimatedSectionHeaderHeight   = 0.1f;
            _shopTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_shopTableView registerClass:[JHNewShopDetailInfoHeaderViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewShopDetailInfoHeaderViewCell class])];
        [_shopTableView registerClass:[JHNewShopDetailInfoScoreViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewShopDetailInfoScoreViewCell class])];
        [_shopTableView registerClass:[JHNewShopDetailInfoTimeViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewShopDetailInfoTimeViewCell class])];

        if ([_shopTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_shopTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_shopTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_shopTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _shopTableView;
}

/// 物流请求接口
- (void)loadData {
    
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F5F8);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JHNewShopDetailInfoHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewShopDetailInfoHeaderViewCell class])];
        if (!cell) {
            cell = [[JHNewShopDetailInfoHeaderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewShopDetailInfoHeaderViewCell class])];
        }
        cell.shopHeaderInfoModel = self.shopHeaderInfoModel;
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self);
            [self shopQualification];
        };
        cell.followSuccessBlock = ^(id obj) {
            @strongify(self);
            if (self.followSuccessBlock) {
                self.followSuccessBlock(obj);
            }
        };
        return cell;
    } else if (indexPath.section == 1) {
        JHNewShopDetailInfoScoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewShopDetailInfoScoreViewCell class])];
        if (!cell) {
            cell = [[JHNewShopDetailInfoScoreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewShopDetailInfoScoreViewCell class])];
        }
        cell.shopHeaderInfoModel = self.shopHeaderInfoModel;
        return cell;
    } else {
        JHNewShopDetailInfoTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewShopDetailInfoTimeViewCell class])];
        if (!cell) {
            cell = [[JHNewShopDetailInfoTimeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewShopDetailInfoTimeViewCell class])];
        }
        cell.shopHeaderInfoModel = self.shopHeaderInfoModel;
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self);
            [self shopQualification];
        };
        return cell;
    }
}

- (void)shopQualification {
    if (self.shopHeaderInfoModel.sellerType == JHUserAuthTypePersonal) {
        ///个人认证 弹出弹窗
        [JHAuthAlertView showText:@"该商家已通过个人认证\n身份信息已在天天鉴宝备案"];
    } else {
        [JHUserAuthVerificationView showWithCompleteBlock:^{
            ///企业认证
            NSString *url = H5_BASE_STRING(@"/jianhuo/app/enterpriseCertification/enterpriseCertification.html?id=");
            url = [NSString stringWithFormat:@"%@%@",url,self.shopHeaderInfoModel.customerId];
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.urlString = url;
            vc.titleString = @"企业认证";
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }];
    }
}

@end
