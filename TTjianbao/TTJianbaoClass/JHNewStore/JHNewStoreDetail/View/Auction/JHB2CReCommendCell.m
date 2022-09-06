//
//  JHB2CReCommendTableViewCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CReCommendCell.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHC2CGoodsCollectionViewCell.h"
#import "JHC2CGoodsListModel.h"
#import "JHC2CUploadSuccessBusiness.h"
#import "JHC2CCollectionView.h"
#import "JHNewStoreHomeBusiness.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "JHStoreDetailBusiness.h"



static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";


@interface JHB2CReCommendCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property (nonatomic, strong) JHC2CCollectionView * collectionView;
@property(nonatomic, assign) NSInteger  page;
@property(nonatomic,strong) NSMutableArray<JHNewStoreHomeGoodsProductListModel*> * listDataArr;
@end

@implementation JHB2CReCommendCell
@synthesize page;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        page = 0;
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        @weakify(self);
        self.collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestMoreRecommentData];
        }];
    }
    return self;
}
- (void)setViewModel:(JHB2CRecommenViewModel *)viewModel{
    _viewModel = viewModel;
    if (![self.listDataArr isEqual:viewModel.recommentArr]) {
        self.listDataArr = [NSMutableArray arrayWithArray:viewModel.recommentArr];
        page = 0;
        [self.collectionView reloadData];
    }
}

- (void)requestRecommentData{
    [JHStoreDetailBusiness requestRecommendProductGoodProduct:self.viewModel.productId page:page completion:^(NSError * _Nullable error, NSArray<JHNewStoreHomeGoodsProductListModel *> * _Nullable arr) {
        if (!error && arr.count) {
        }
    }];
}



- (void)requestMoreRecommentData{
    self.page += 1;
    [JHStoreDetailBusiness requestRecommendProductGoodProduct:self.viewModel.productId page:page completion:^(NSError * _Nullable error, NSArray<JHNewStoreHomeGoodsProductListModel *> * _Nullable arr) {
        [self.collectionView.mj_footer endRefreshing];
        if (!error && arr.count) {
            [self.listDataArr  appendObjects:arr];
            [self.collectionView reloadData];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


#pragma mark - private
- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    if (!canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}
- (BOOL)supportScroll{
    CGFloat height = CGRectGetHeight(self.collectionView.frame);
    CGFloat contentHeight = self.collectionView.contentSize.height;
    return contentHeight > height;
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [self makeDeatilDescModuleScroll:NO];
            if (self.superCanScroolBLock) {
                self.superCanScroolBLock();
            }
        }
    } else {
        [self makeDeatilDescModuleScroll:NO];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreHomeGoodsProductListModel *data = self.listDataArr[indexPath.item];
    NSDictionary *par = @{@"productId" : [NSNumber numberWithLong:data.productId].stringValue,
                          @"original_price" : data.price
    };

    NSDictionary *dic = @{@"type" : @"JHStoreDetailViewController",
                          @"parameter" : par};
    [self.viewModel.pushvc sendNext:dic];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHNewStoreHomeGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    JHNewStoreHomeGoodsProductListModel *dataModel = self.listDataArr[indexPath.row];
    cell.curData = dataModel;
    @weakify(self)
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self)
        if (!isH5) {
            NSDictionary *par = @{@"showId" : showId, @"productId" : [NSNumber numberWithLong:dataModel.productId].stringValue, @"zc_name" :  dataModel.showName};
            NSDictionary *dic = @{@"type" : @"SpecialShow",
                                  @"parameter" : par};
            [self.viewModel.pushvc sendNext:dic];
        }
    };
    return cell;
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listDataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section{
   return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsProductListModel *data = self.listDataArr[indexPath.item];
    return CGSizeMake((ScreenW - 12.f*2 - 9.f)/2.f, data.itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    return 54;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    return 0 ;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderId forIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    view.backgroundColor = HEXCOLOR(0xF5F5F8);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"为你推荐";
    label.font = JHFont(17);
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
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 9.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 9.f;
}

#pragma mark - Getters
- (JHC2CCollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[JCCollectionViewWaterfallLayout alloc] init];
          _collectionView = [[JHC2CCollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.bounces = NO;
        _collectionView.backgroundColor=HEXCOLOR(0xF5F5F8);
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderId];
        
         [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        
        
    }
    return _collectionView;
}


@end

