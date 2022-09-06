//
//  JHGraphicalSubListViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphicalSubListViewController.h"
#import "JHGraphicOrderDetailViewController.h"
#import "CommAlertView.h"
#import "JHWebViewController.h"
#import "JHOrderViewModel.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHGraphiclOrderListCell.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsDetailViewController.h"
#import "JHRecommendHeader.h"
#import "JHDefaultCollectionViewCell.h"
#import "JHRecycleOrderCancelViewController.h"
#import "JHAppraisePayView.h"
#import "JHGraphicalSubListModel.h"
#import "JHGraphiclOrderDelegate.h"
#import "JHGraphicaldentificationBusiness.h"

#define pagesize 20
static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";
@interface JHGraphicalSubListViewController ()<
JHGraphiclOrderDelegate,
JHGraphicalSubListVCDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
{
    NSInteger PageNum;
    NSInteger _pageNumber;
    BOOL showDefaultImage;
}

/// 视图的layout
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
/// 视图
@property (nonatomic, strong) UICollectionView *collectionView;
/// 图文鉴定数据
@property (nonatomic, strong) NSMutableArray <JHGraphicalSubModel*> *graphicalSubList;
/// 后台要的参数
@property (nonatomic, copy) NSString *cursor;

@end

@implementation JHGraphicalSubListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reportPageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图文鉴定";
    self.view.backgroundColor = kColorF5F6FA;
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.collectionView.mj_header beginRefreshing];
    
}

-(void)loadNewData{
    
    PageNum=1;
    [self requestInfo];
}
-(void)loadMoreData{
    PageNum++;
    [self requestInfo];
}

-(void)requestInfo {
    
    NSString *url = FILE_BASE_STRING(@"/order/appraisalOrder/auth/list");
    NSString *cursor = isEmpty(self.cursor) ? @"" : self.cursor;
    
    NSDictionary *params = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)PageNum],
                             @"pageSize":[NSString stringWithFormat:@"%d",pagesize],
                             @"orderId":@"",
                             @"imageType":@"s",
                             @"cursor":cursor
    };
    
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *data = (NSDictionary *)respondObject.data;
        [self handleDataWithArr:data];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message];
        
        [self endRefresh];
    }];
    
    
}

- (void)handleDataWithArr:(NSDictionary *)data {
    
    JHGraphicalSubListModel *graphicalSubListModel = [JHGraphicalSubListModel mj_objectWithKeyValues:data];
 
    if (PageNum == 1) {
        self.graphicalSubList = [NSMutableArray arrayWithArray:graphicalSubListModel.resultList];
    } else {
        [self.graphicalSubList addObjectsFromArray:graphicalSubListModel.resultList];
    }
    self.cursor = graphicalSubListModel.cursor;
    
    showDefaultImage = self.graphicalSubList.count == 0 ? YES : NO;
    self.collectionView.mj_footer.hidden = self.graphicalSubList.count == 0 ? YES : NO;

    if (PageNum == 1) {
        [self endRefresh];
    }
    BOOL noMore = !graphicalSubListModel.hasMore;
    
    noMore ? [self.collectionView.mj_footer endRefreshingWithNoMoreData] : [self.collectionView.mj_footer endRefreshing];
    
    [self.collectionView reloadData];
    
    if (self.graphicalSubList.count >= 4) {
        ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
    }
    
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (showDefaultImage) {
        JHDefaultCollectionViewCell *defaultcell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
        defaultcell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [defaultcell.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-60);
            make.centerX.equalTo(defaultcell.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(90, 72));
        }];
        [defaultcell.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(defaultcell.imageView.mas_bottom).offset(14);
            make.centerX.equalTo(defaultcell.imageView.mas_centerX);
        }];
        defaultcell.label.text=@"您还没鉴定订单哦";
        defaultcell.label.font = [UIFont systemFontOfSize:14];
        defaultcell.label.textColor = HEXCOLOR(0xFF333333);
//        [defaultcell displaySubLabel];
        defaultcell.subLabel.text=@"";
        
        return defaultcell;
    }
    JHGraphiclOrderListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHGraphiclOrderListCell class]) forIndexPath:indexPath];
    cell.delegate=self;
    [cell setOrderMode:self.graphicalSubList[indexPath.row]];
    return cell;
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (showDefaultImage) {
        return 1;
    }
    return self.graphicalSubList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (showDefaultImage) {
        return CGSizeMake(ScreenW-20, 240);
    }
    return CGSizeMake(ScreenW-20, 178);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0 ;
    }
    return 46;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    return 0 ;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader]){
        JHRecommendHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderId forIndexPath:indexPath];
        headerView.backgroundColor=[UIColor redColor];
        return headerView;
    }
    else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseFooterId forIndexPath:indexPath];
        return footerView;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10,0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        if (showDefaultImage) {
            return;
        }
        JHGraphicalSubModel *subModel = self.graphicalSubList[indexPath.item];
        JHGraphicOrderDetailViewController * detail=[[JHGraphicOrderDetailViewController alloc]initWithOrderInfoId:[subModel orderId]
                                                                                                         orderCode:[subModel orderCode]
                                                                                                          delegate:self];
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}

#pragma mark - JHGraphiclOrderDelegate

- (void)countdownOver {
    // 刷新数据
    [self loadNewData];
}

- (void)cancelAppraisalWith:(JHGraphicalSubModel *)graphicalModel {
    
    JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
    vc.jhNavView.hidden = YES;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.requestType = 3;
    vc.isShowCancel = 1;
    @weakify(self);
    vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString *code) {
        @strongify(self);
        
        NSDictionary *dict = @{@"orderId":graphicalModel.orderId,@"cancelReason":message};
        [JHGraphicaldentificationBusiness requestCancelIdentificationWithParams:dict
                                                                     completion:^(RequestModel * _Nonnull respondObject) {
            // 刷新数据
            [self loadNewData];
            
            
        } fail:^(NSError * _Nonnull error) {
            
        }];
       
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)toPayWith:(JHGraphicalSubModel *)graphicalModel {
    JHAppraisePayView * payView = [[JHAppraisePayView alloc]init];
    payView.orderId = graphicalModel.orderId;
    [JHKeyWindow addSubview:payView];
    [payView showAlert];
    @weakify(self);
    payView.paySuccessBlock = ^{
        @strongify(self);
        // 刷新数据
        [self loadNewData];
    };
}

- (void)checkTheReportWith:(JHGraphicalSubModel *)graphicalModel {
    
    JHWebViewController *webVC = [JHWebViewController new];
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    NSString *url = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/reportGraphic.html?customerId=%@&orderCode=%@"),customerId, graphicalModel.orderCode];
    webVC.urlString = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)toDeleteWith:(JHGraphicalSubModel *)graphicalModel {
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"您确定删除？" cancleBtnTitle:@"取消" sureBtnTitle:@"删除"];
    [JHKeyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [SVProgressHUD show];
        [JHGraphicaldentificationBusiness requestDeleteGraphicalWithParams:@{@"orderId":graphicalModel.orderId} completion:^(RequestModel * _Nonnull respondObject) {
            
            [SVProgressHUD dismiss];
            JHTOAST(@"删除订单成功");
            [self loadNewData];
            
        } fail:^(NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            
        }];
        
    };
}

# pragma  mark - JHGraphicalSubListVCDelegate
- (void)toRefreshGraphicalSubListPage {
    [self loadNewData];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark - 埋点
- (void)reportPageView {
    NSDictionary *par = @{
        @"page_name" : @"鉴定订单页",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[JCCollectionViewWaterfallLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor= HEXCOLOR(0xf5f6fa);
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[JHGraphiclOrderListCell class] forCellWithReuseIdentifier:NSStringFromClass([JHGraphiclOrderListCell class])];
        [_collectionView registerClass:[JHShopWindowCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHShopWindowCollectionCell class])];
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultcell"];
        [_collectionView registerClass:[JHRecommendHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderId];
         [self.view addSubview:_collectionView];
         [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
         }];
    }
    return _collectionView;
}

@end
