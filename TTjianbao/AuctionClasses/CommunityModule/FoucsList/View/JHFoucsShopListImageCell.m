//
//  JHFoucsShopListImageCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFoucsShopListImageCell.h"
#import "JHFoucsShopListImageCollectionViewCell.h"

@interface JHFoucsShopListImageCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHFoucsShopListImageCell

-(void)setGoodsArray:(NSArray<JHFoucsShopProductInfo *> *)goodsArray
{
    if (!IS_ARRAY(goodsArray)) {
        return;
    }
    
    _goodsArray = goodsArray;
    [self.collectionView reloadData];
}


-(UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = [JHFoucsShopListImageCell cellSize];
        flowLayout.minimumInteritemSpacing = 10;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollEnabled = NO;
        [collectionView registerClass:[JHFoucsShopListImageCollectionViewCell class] forCellWithReuseIdentifier:[JHFoucsShopListImageCollectionViewCell cellIdentifier]];
        [self.contentView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHFoucsShopListImageCollectionViewCell *cell = [JHFoucsShopListImageCollectionViewCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    if(indexPath.item < self.goodsArray.count)
    {
        JHFoucsShopProductInfo *model = self.goodsArray[indexPath.item];
        [cell.goodsView jh_setImageWithUrl:model.coverImage.url];
        cell.goodsNameLabel.text = model.productName;
    }
    
    return cell;
}

///跳转商品详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.enterShopBlock)
    {
        self.enterShopBlock();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(3, self.goodsArray.count);
}

+(CGSize)cellSize
{
    return CGSizeMake(floor((ScreenW - 40)/3.f), (ScreenW - 40)/3.f + 49);
}

@end
