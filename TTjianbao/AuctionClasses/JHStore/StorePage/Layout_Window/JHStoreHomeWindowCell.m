//
//  JHStoreHomeWindowCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeWindowCell.h"
#import "JHWindowCollectionCell.h"
#import "UIView+CornerRadius.h"
#import "JHShopWindowPageController.h"
#import "JHStoreHomeCardModel.h"

@interface JHStoreHomeWindowCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *showcaseList;
@property (nonatomic, assign) UIRectCorner rectCorner;

@end


@implementation JHStoreHomeWindowCell

+ (CGFloat)cellHeight {
    return 130;
}

- (void)setIsClipAllCorners:(BOOL)isClipAllCorners {
    _isClipAllCorners = isClipAllCorners;
    if (_isClipAllCorners) {
        _rectCorner = UIRectCornerAllCorners;
    }
    [self clipCorners];
}

- (void)setCardInfoModel:(JHStoreHomeCardInfoModel *)cardInfoModel {
    if (!cardInfoModel) return;
    _cardInfoModel = cardInfoModel;
    _showcaseList = _cardInfoModel.showcaseList;
    [self.collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isClipAllCorners = NO;
        _rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = kColorF5F6FA;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = YES;
        [self.contentView addSubview:_collectionView];

        [_collectionView registerClass:[JHWindowCollectionCell class] forCellWithReuseIdentifier:kCellId_JHStoreHomeCollectionWindowId];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
               
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
//        [self clipCorners];
    }
}

- (void)clipCorners {
    [_collectionView layoutIfNeeded];
    [_collectionView yd_setCornerRadius:8.f corners:_rectCorner];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_showcaseList.count < 3) {
        return _showcaseList.count;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHWindowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHStoreHomeCollectionWindowId forIndexPath:indexPath];
    cell.showcaseModel = self.showcaseList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreHomeShowcaseModel *model = self.showcaseList[indexPath.item];
    JHShopWindowPageController *vc = [[JHShopWindowPageController alloc] init];
    vc.showcaseId = model.sc_id;
    vc.showcaseName = model.name;
    vc.fromSource = JHTrackMarketSaleTopicFromZone;
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:model.name forKey:@"op_name"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"operationClick" params:params type:JHStatisticsTypeSensors];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        header.backgroundColor = kColorF5F6FA;
        return header;
    }
    
    return [[UICollectionReusableView alloc] init];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenW-20, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenW - 20-2)/3, [JHWindowCollectionCell cellHeight]);
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
