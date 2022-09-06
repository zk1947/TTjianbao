//
//  JHB2CSameShopCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CSameShopCell.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHC2CGoodsCollectionViewCell.h"
#import "JHC2CGoodsListModel.h"
#import "JHC2CUploadSuccessBusiness.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreHomeBusiness.h"
#import "JHNewStoreSpecialDetailViewController.h"


static NSString * const reuseHeaderId = @"headerId";
static NSString * const reuseFooterId = @"footerId";
static NSString * const reuseCellId = @"cellId";


@interface JHB2CSameShopCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSInteger _pageNumber;
}
@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;
@property(nonatomic,strong) NSArray<JHNewStoreHomeGoodsProductListModel*>* layouts;
@property (nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic, strong) RACReplaySubject * repSubject;
@end

@implementation JHB2CSameShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItem];
    }
    return self;
}

- (void)setItem{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    @weakify(self);
    [RACObserve(self.collectionView, contentSize) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSValue *value = x;
        CGSize size = [value CGSizeValue];
        if (size.height != 0  && self.viewModel.height != size.height - 10) {
            self.viewModel.height = size.height - 10;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.viewModel.reloadCellSubject sendNext:RACTuplePack(@(self.viewModel.sectionIndex), @(self.viewModel.rowIndex))];
            });
        }
    }];
}

- (void)setViewModel:(JHB2CSameShopCellViewModel *)viewModel{
    _viewModel = viewModel;
    if (!self.layouts.count) {
        self.layouts = viewModel.listDataArr;
        viewModel.height = ((self.layouts.count-1)/2 + 1) * 330;
        [self.collectionView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    JHNewStoreHomeGoodsProductListModel *data = self.layouts[indexPath.item];
    NSDictionary *par = @{@"productId" : [NSNumber numberWithLong:data.productId].stringValue,
                          @"original_price" : data.price
    };
    NSDictionary *dic = @{@"type" : @"JHStoreDetailViewController",
                          @"parameter" : par};
    [self.viewModel.pushvc sendNext:dic];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHNewStoreHomeGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    JHNewStoreHomeGoodsProductListModel *dataModel = self.layouts[indexPath.row];
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
    return self.layouts.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section{
   return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsProductListModel *data = self.layouts[indexPath.item];
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
    label.text = @"同店好货";
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
        _collectionView.backgroundColor=HEXCOLOR(0xF5F5F8);
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];

        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderId];
        
         [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    
         [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

- (RACReplaySubject *)repSubject{
    if (!_repSubject) {
        _repSubject = [RACReplaySubject subject];
    }
    return _repSubject;
}
@end
