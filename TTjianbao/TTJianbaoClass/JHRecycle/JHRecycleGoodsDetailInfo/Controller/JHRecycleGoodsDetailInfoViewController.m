//
//  JHRecycleGoodsDetailInfoViewController.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailInfoViewController.h"
#import "UIScrollView+JHEmpty.h"
#import "SVProgressHUD.h"
#import "JHRecycleGoodDetailInfoBusiness.h"
#import "JHRecycleGoodsDetailBottomView.h"
#import "JHRecycleGoodsDetailInfoNavView.h"

#import "JHRecycleGoodsDetailPictsTableViewCell.h"
#import "JHRecycleGoodsDetailInfoTableViewCell.h"
#import "JHRecycleGoodsDetailDescTableViewCell.h"
#import "JHRecycleGoodsDetailPictNameTableViewCell.h"
#import "JHRecycleGoodsDetailPictAndVideoTableViewCell.h"
#import "JHRecycleGoodsInfoViewModel.h"
#import "JHRecycleUploadTypeSeleteViewController.h"

#import <AVKit/AVKit.h>
#import "JHRecycleSquareHomeViewController.h"
#import "JHPhotoBrowserManager.h"


@interface JHRecycleGoodsDetailInfoViewController ()<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *goodsInfoTabelView;
@property (nonatomic, strong) NSMutableArray                  *dataSourceArray;
@property (nonatomic, strong) JHRecycleGoodsDetailInfoNavView *navView;
@property (nonatomic, strong) JHRecycleGoodsDetailBottomView  *bottomView;
@end

@implementation JHRecycleGoodsDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.jhNavView.hidden = YES;
    [self setupBottomView];
    [self setupViews];
    [self setupNavView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"回收商品详情页",
        @"commodity_id":NONNULL_STR(self.productId)
    } type:JHStatisticsTypeSensors];
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

- (void)setupNavView {
    self.navView = [[JHRecycleGoodsDetailInfoNavView alloc] init];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo([self navViewHeight]);
    }];
    @weakify(self);
    self.navView.backBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)setupBottomView {
    self.bottomView = [[JHRecycleGoodsDetailBottomView alloc] init];
    self.bottomView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self.view addSubview:self.bottomView];
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(bottomHeight +59.f);
    }];
    self.bottomView.hidden = YES;
    @weakify(self);
    [self.bottomView recycleBottomAction:^(JHRecycleGoodsDetailBottomBtnStyle style) {
        @strongify(self);
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
            return;
        }
        if (style == JHRecycleGoodsDetailBottomBtnStyle_wantRecycle) {
            /// 成为回收商
            /// 已开通店铺的去回收广场
            User *user = [UserInfoRequestManager sharedInstance].user;
            if ([JHRootController isLogin] && user.blRole_recycleBusiness ) {
                JHRecycleSquareHomeViewController *vc = [[JHRecycleSquareHomeViewController alloc] init];
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            } else {
                [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/applyOpenShop.html") title:@"" controller:JHRootController];
            }            ///
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickToBeRecycler" params:@{
                    @"page_position":@"回收商品详情页"
            } type:JHStatisticsTypeSensors];
        } else {
            /// 卖钱币
            JHRecycleUploadTypeSeleteViewController *vc = [[JHRecycleUploadTypeSeleteViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            ///
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickModel" params:@{
                    @"page_position":@"回收商品详情页",
                    @"model_name":@"卖钱币"
            } type:JHStatisticsTypeSensors];
        }
    }];
}

- (void)setupViews {
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    [self.view addSubview:self.goodsInfoTabelView];
    [self.goodsInfoTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-(bottomHeight+59.f));
    }];
}

- (UITableView *)goodsInfoTabelView {
    if (!_goodsInfoTabelView) {
        _goodsInfoTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsInfoTabelView.dataSource                     = self;
        _goodsInfoTabelView.delegate                       = self;
        _goodsInfoTabelView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _goodsInfoTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _goodsInfoTabelView.estimatedRowHeight             = 10.f;
        _goodsInfoTabelView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _goodsInfoTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _goodsInfoTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        [_goodsInfoTabelView registerClass:[JHRecycleGoodsDetailPictsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictsTableViewCell class])];
        [_goodsInfoTabelView registerClass:[JHRecycleGoodsDetailInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailInfoTableViewCell class])];
        
        [_goodsInfoTabelView registerClass:[JHRecycleGoodsDetailDescTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailDescTableViewCell class])];
        
        [_goodsInfoTabelView registerClass:[JHRecycleGoodsDetailPictNameTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictNameTableViewCell class])];
        
        [_goodsInfoTabelView registerClass:[JHRecycleGoodsDetailPictAndVideoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictAndVideoTableViewCell class])];

        if ([_goodsInfoTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_goodsInfoTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_goodsInfoTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_goodsInfoTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _goodsInfoTabelView;
}

/// 请求接口
- (void)loadData {
    [self.dataSourceArray removeAllObjects];
    @weakify(self);
    [JHRecycleGoodDetailInfoBusiness getRecycleGoodsDetailInfoRequest:self.productId Completion:^(NSError * _Nullable error, JHRecycleGoodsInfoViewModel * _Nullable viewModel) {
        @strongify(self);
        if (error) {
            self.bottomView.hidden = YES;
            [self.goodsInfoTabelView jh_EmputyView];
            return;
        }
        [self.navView setNavViewTitle:viewModel.navName];
        [self.navView setTitleLabelAlpha:0];
        [self.dataSourceArray addObjectsFromArray:viewModel.dataSourceArray];
        [self.goodsInfoTabelView reloadData];
        self.bottomView.hidden = NO;
    }];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        return;
    }
    CGFloat alpah = MAX(0, MIN(1, scrollView.contentOffset.y / ScreenW));
    if (alpah>0.4) {
        [self.navView changeNavBackBlack:NO];
    } else {
        [self.navView changeNavBackBlack:YES];
    }
    [self.navView setTitleLabelAlpha:alpah];
    self.navView.backgroundColor = HEXCOLORA(0xffffff, alpah);
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F6FA);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([NSArray has:self.dataSourceArray[section]]) {
        NSArray *arr = self.dataSourceArray[section];
        return arr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![NSArray has:self.dataSourceArray[indexPath.section]]) {
        return [UITableViewCell new];
    }
    NSArray *arr = self.dataSourceArray[indexPath.section];
    id viewModelImpl = arr[indexPath.row];
    
    if ([JHRecycleGoodsInfoCellStyle_PictsBannerViewModel has:viewModelImpl]) {
        JHRecycleGoodsDetailPictsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictsTableViewCell class])];
        if (!cell) {
            cell = [[JHRecycleGoodsDetailPictsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictsTableViewCell class])];
        }
        JHRecycleGoodsInfoCellStyle_PictsBannerViewModel *viewModel = viewModelImpl;
        [cell setViewModel:viewModel.productImgUrls];
        return cell;
    }
    
    if ([JHRecycleGoodsInfoCellStyle_InfoViewModel has:viewModelImpl]) {
        JHRecycleGoodsDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecycleGoodsDetailInfoTableViewCell class])];
        if (!cell) {
            cell = [[JHRecycleGoodsDetailInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailInfoTableViewCell class])];
        }
        JHRecycleGoodsInfoCellStyle_InfoViewModel *viewModel = viewModelImpl;
        [cell setViewModel:viewModel.infoModel];
        return cell;
    }

    if ([JHRecycleGoodsInfoCellStyle_DescViewModel has:viewModelImpl]) {
        JHRecycleGoodsDetailDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecycleGoodsDetailDescTableViewCell class])];
        if (!cell) {
            cell = [[JHRecycleGoodsDetailDescTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailDescTableViewCell class])];
        }
        JHRecycleGoodsInfoCellStyle_DescViewModel *viewModel = viewModelImpl;
        [cell setViewModel:viewModel.productDesc];
        return cell;
    }
    
    if ([JHRecycleGoodsInfoCellStyle_PictNameViewModel has:viewModelImpl]) {
        JHRecycleGoodsDetailPictNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictNameTableViewCell class])];
        if (!cell) {
            cell = [[JHRecycleGoodsDetailPictNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictNameTableViewCell class])];
        }
        JHRecycleGoodsInfoCellStyle_PictNameViewModel *viewModel = viewModelImpl;
        [cell setViewModel:viewModel.pictTitleName];
        return cell;
    }
    
    if ([JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel has:viewModelImpl]) {
        JHRecycleGoodsDetailPictAndVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictAndVideoTableViewCell class])];
        if (!cell) {
            cell = [[JHRecycleGoodsDetailPictAndVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHRecycleGoodsDetailPictAndVideoTableViewCell class])];
        }
        JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel *viewModel = viewModelImpl;
        [cell setViewModel:viewModel.detailUrlsModel];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![NSArray has:self.dataSourceArray[indexPath.section]]) {
        return;
    }
    NSArray *arr = self.dataSourceArray[indexPath.section];
    id viewModelImpl  = arr[indexPath.row];
    if ([JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel has:viewModelImpl]) {
        JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel *viewModel = viewModelImpl;
        if (viewModel.detailUrlsModel.detailType == 0) {
            /// 浏览图片
            NSInteger tureIndex  = 0; /// 图片内容的下标
            for (NSString *imageStr in viewModel.productDetailMedium) {
                if ([viewModel.detailUrlsModel.detailImageUrl.medium isEqualToString:imageStr]) {
                    break;
                }
                tureIndex ++;
            }
            [JHPhotoBrowserManager showPhotoBrowserThumbImages:viewModel.productDetailMedium mediumImages:viewModel.productDetailMedium origImages:viewModel.productDetailOrigin sources:nil currentIndex:tureIndex canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom hideDownload:YES];
        }
        if (viewModel.detailUrlsModel.detailType == 1) {
            /// 视频
            NSURL *url = [NSURL URLWithString:viewModel.detailUrlsModel.detailVideoUrl];
            AVPlayerViewController *ctrl = [AVPlayerViewController new];
            ctrl.player = [[AVPlayer alloc]initWithURL:url];
            [JHRootController presentViewController:ctrl animated:YES completion:nil];
        }
    }
}

@end




