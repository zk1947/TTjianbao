//
//  JHC2CProductRecommentView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductRecommentView.h"

#import "JHC2CProductDetailController.h"

#import "JHContactAlertView.h"
#import "JHUploadSuccessHeaderView.h"
#import "JHQYChatManage.h"
#import "JHBaseOperationView.h"
#import "JHOrderViewModel.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHShopWindowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsDetailViewController.h"
#import "JHRecommendHeader.h"
#import "JHStoreApiManager.h"
#import "JHC2CUploadSuccessBusiness.h"
#import "JHC2CGoodsListModel.h"
#import "JHC2CGoodsCollectionViewCell.h"

static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";


@interface JHC2CProductRecommentView  ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSInteger _pageNumber;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property(nonatomic,strong) NSMutableArray<JHC2CProductBeanListModel*>* layouts;
@end

@implementation JHC2CProductRecommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        __weak typeof(self) weakSelf = self;
        self.collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        
         self.collectionView.mj_footer.hidden=YES;

    }
    return self;
}

- (void)setProductType:(NSString *)productType{
    _productType = productType;
    [self loadNewData];
}

-(void)loadNewData{
    
    _pageNumber = 1;
    [self requestProductInfo];
}
-(void)loadMoreData{
    _pageNumber++;
    [self requestProductInfo];
   
}
    
- (void)requestProductInfo{
    @weakify(self);
    NSDictionary *dic = @{@"pageNo" : @(_pageNumber),
                              @"pageSize" : @10,
                              @"imageType" : @"m",
                          @"productType" : [NSNumber numberWithInteger:self.productType.integerValue],
                          @"productId" : self.locationProductID
    };
    
    [JHC2CUploadSuccessBusiness getC2CGuessLike:dic completion:^(RequestModel *respondObject, NSError *error) {
        @strongify(self);
        [self endRefresh];
        if (!error) {
            [self handleProudctWithArr:respondObject.data[@"productList"]];
        }
    }];
}
- (void)handleProudctWithArr:(NSArray *)array {
    
    NSArray *arr = [JHC2CProductBeanListModel mj_objectArrayWithKeyValuesArray:array];
    if (_pageNumber == 1) {
        self.layouts = [NSMutableArray arrayWithCapacity:10];
    }
    [arr enumerateObjectsUsingBlock:^(JHC2CProductBeanListModel * _Nonnull goodsInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.layouts addObject:goodsInfo];
    }];
    if ([arr count]==0) {
        self.collectionView.mj_footer.hidden=YES;
    }
    else{
        self.collectionView.mj_footer.hidden=NO;
    }
    [_collectionView reloadData];
    
    
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)scrTop{
    [self.collectionView scrollToTop];
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
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        //解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
        _collectionView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[JHC2CGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderId];
        
         [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    
         [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHC2CGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class]) forIndexPath:indexPath];
    JHC2CProductBeanListModel *dataModel = self.layouts[indexPath.row];
    [cell bindViewModel:dataModel params:nil];
    return cell;
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.layouts.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section{
   return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHC2CProductBeanListModel *layout = self.layouts[indexPath.item];
    CGFloat height = layout.itemHeight;
    return CGSizeMake((ScreenW-36)/2, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    return 46;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    
    return 0 ;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderId forIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    view.backgroundColor = HEXCOLOR(0xF5F5F8);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"猜你喜欢";
    label.font = JHFont(14);
    label.textColor = HEXCOLOR(0xB38A50);
    [view addSubview:label];
    
    UIImageView *leftLine = [[UIImageView alloc] init];
    leftLine.image = [UIImage imageNamed:@"c2c_pd_bg_caixihuan_left"];
    [view addSubview:leftLine];

    UIImageView *rightLine = [[UIImageView alloc] init];
    rightLine.image = [UIImage imageNamed:@"c2c_pd_bg_caixihuan_right"];
    [view addSubview:rightLine];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
        
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-10);
        make.centerY.equalTo(@0);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.centerY.equalTo(@0);
    }];
    [headerView addSubview:view];
    return headerView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
      return UIEdgeInsetsMake(0,12,0, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 9.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 9.f;
}

- (void)refrshWithMainScroolViewScrool:(UITableView *)scrollView{
    if (self.mainTableView) {
        CGPoint starPoint = self.mainTableView.tableFooterView.frame.origin;
        CGPoint point  = self.mainTableView.contentOffset;
        if (starPoint.y > point.y) {
            self.collectionView.scrollEnabled = NO;
        }else{
            self.collectionView.scrollEnabled = YES;
        }
    }

}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 20.f;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    JHC2CProductBeanListModel *dataModel = self.layouts[indexPath.row];

    //埋点
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"commodity_id"] = dataModel.productId;
    parDic[@"detail_commodity_id"] = self.locationProductID ;
    parDic[@"model_type"] = @"猜你喜欢列表";
    parDic[@"original_price"] = dataModel.price;
    parDic[@"page_position"] = self.staticTypeName;
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:parDic type:JHStatisticsTypeSensors];
    
    JHC2CProductDetailController *vc = [JHC2CProductDetailController new];
    vc.productId = dataModel.productId;
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];

//      JHC2CProductBeanListModel *layout = self.layouts[indexPath.item];
//        JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
//        vc.goods_id = goods.goods_id;
//        vc.entry_id = @"0"; //入口id传橱窗id
//        vc.entry_type = JHFromStoreFollowOrderDetailRecommend; ///订单详情推荐
//        vc.isFromShopWindow = NO;
//        [self.navigationController pushViewController:vc animated:YES];
}

@end


