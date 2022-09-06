//
//  JHNewStoreCategoryTableCellTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreCategoryTableCellTableViewCell.h"
#import "JHNewStoreHomeCategoryMallCollectionViewCell.h"
#import "JHMallModel.h"
#import "TTjianbao.h"
#import "JHNewStoreHomeReport.h"

@interface JHNewStoreCategoryTableCellTableViewCell () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JHNewStoreCategoryTableCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.contentView addSubview:_collectionView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[JHNewStoreHomeCategoryMallCollectionViewCell class] forCellWithReuseIdentifier:@"JHNewStoreHomeCategoryMallCollectionViewCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        ///尽量不要修改间距 ！！！！！ UI确认完之后的
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5.f, 0, 5.f));
        make.height.mas_equalTo(166.f);
    }];
}


+ (CGFloat)viewHeight {
    return [JHNewStoreHomeCategoryMallCollectionViewCell viewSize].height;
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryInfos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreHomeCategoryMallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHNewStoreHomeCategoryMallCollectionViewCell" forIndexPath:indexPath];
    cell.cateModel = self.categoryInfos[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [JHNewStoreHomeCategoryMallCollectionViewCell viewSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoryInfos.count > 0) {
        JHMallCategoryModel *model = self.categoryInfos[indexPath.item];
        if (model.targetModel) {
            [JHNewStoreHomeReport jhNewStoreHomeKingKongClickReport:model.name position_sort:[NSString stringWithFormat:@"%ld",indexPath.item]];
            [JHRootController toNativeVC:model.targetModel.vc withParam:model.targetModel.params from:JHFromHomeSourceBuy];
        }
    }
}

- (void)setCategoryInfos:(NSArray<JHMallCategoryModel *> *)categoryInfos {
    if (!categoryInfos || categoryInfos.count == 0) {
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    } else {
        _categoryInfos = categoryInfos;
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(166.f);
        }];
        [self.collectionView reloadData];
    }
}

@end
