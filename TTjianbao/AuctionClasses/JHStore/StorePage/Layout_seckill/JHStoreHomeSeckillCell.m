//
//  JHStoreHomeSeckillCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeSeckillCell.h"
#import "JHSeckillCollectionCell.h"
#import "JHStoreHomeSeckillHeader.h"
#import "UIView+CornerRadius.h"
#import "JHStoreHomeCardModel.h"
#import "JHSeckillPageViewController.h"
#import "JHGoodsInfoMode.h"

#define kCellCount  4

@interface JHStoreHomeSeckillCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHStoreHomeShowcaseModel *showCaseModel;
@property (nonatomic, strong) NSMutableArray *goodList;

@end


@implementation JHStoreHomeSeckillCell

+ (CGFloat)cellHeight {
    return 150;
}

- (void)__addObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:UpdateSeckillGoodsNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        self.goodList = self.cardInfoModel.nextGoodsList.copy;
        [self.collectionView reloadData];
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _goodList = [NSMutableArray array];
        [self initViews];
        ///添加通知 更新秒杀商品数据
        [self __addObserver];
    }
    return self;
}

- (void)setCardInfoModel:(JHStoreHomeCardInfoModel *)cardInfoModel {
    if (!cardInfoModel) {
        return;
    }
    _cardInfoModel = cardInfoModel;
    if (_cardInfoModel.showcaseList.count > 0) {
        _showCaseModel = [_cardInfoModel.showcaseList firstObject];
    }
    _goodList = [NSMutableArray arrayWithArray:_cardInfoModel.goodsList.copy];
    [self.collectionView reloadData];
}

- (void)initViews {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 9;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = YES;
        [self.contentView addSubview:_collectionView];
        _collectionView.userInteractionEnabled = NO;

        [_collectionView registerClass:[JHSeckillCollectionCell class] forCellWithReuseIdentifier:kCellId_JHStoreHomeCollectionSeckillId];
        
        [_collectionView registerClass:[JHStoreHomeSeckillHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId_JHSeckillHeaderId];
       
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
        [_collectionView layoutIfNeeded];
        [_collectionView yd_setCornerRadius:8.f corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.goodList.count < kCellCount) {
        return self.goodList.count;
    }
    return kCellCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHSeckillCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHStoreHomeCollectionSeckillId forIndexPath:indexPath];
    cell.goodsInfo = self.goodList[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        JHStoreHomeSeckillHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId_JHSeckillHeaderId forIndexPath:indexPath];
        header.showcaseModel = _showCaseModel;
        return header;
    }
    
    return [[UICollectionReusableView alloc] init];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenW-20, [JHStoreHomeSeckillHeader headerHeight]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenW - 20)/4, [JHSeckillCollectionCell cellHeight]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
