//
//  JHMarketSpecialTableViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketSpecialTableViewCell.h"
#import "JHMarketSpecialCollectionViewCell.h"
#import "TTjianbao.h"

@interface JHMarketSpecialTableViewCell () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JHMarketSpecialTableViewCell

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
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.contentView addSubview:_collectionView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[JHMarketSpecialCollectionViewCell class] forCellWithReuseIdentifier:@"JHMarketSpecialCollectionViewCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        ///尽量不要修改间距 ！！！！！ UI确认完之后的
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0.f, 0, 0.f));
        make.height.mas_equalTo(80.f);
    }];
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryInfos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMarketSpecialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHMarketSpecialCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.categoryInfos[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMarketHomeSpecialItemModel *model = self.categoryInfos[indexPath.item];
    CGFloat height = (ScreenW - 24.f) * model.height / model.width;
    return  CGSizeMake(ScreenW - 24.f, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 12, 5, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoryInfos.count > 0) {
        
    }
}

- (void)setCategoryInfos:(NSArray *)categoryInfos{
    if (!categoryInfos || categoryInfos.count == 0) {
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    } else {
        _categoryInfos = categoryInfos;
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(80*_categoryInfos.count+10);
            make.height.mas_equalTo([self getCollectionH]+5);
        }];
        [self.collectionView reloadData];
    }
}

- (CGFloat)getCollectionH{
    CGFloat allH = 0;
    for (JHMarketHomeSpecialItemModel *model in _categoryInfos) {
        allH += (ScreenW - 24.f) * model.height / model.width + 10;
    }
    return allH;
}

@end
