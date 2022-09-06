//
//  JHNewStoreRecommendTagsView.m
//  TTjianbao
//
//  Created by hao on 2021/10/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreRecommendTagsView.h"
#import "JHRecommendTagsCollectionCell.h"

@interface JHNewStoreRecommendTagsView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHNewStoreRecommendTagsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
#pragma mark - UI
- (void)initSubviews{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}
#pragma mark - LoadData
- (void)setTagsDataArray:(NSArray *)tagsDataArray{
    _tagsDataArray = tagsDataArray;

    [self.collectionView reloadData];
}
#pragma mark - Action


#pragma mark - Delegate
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tagsDataArray.count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHRecommendTagsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHRecommendTagsCollectionCell class]) forIndexPath:indexPath];
    [cell bindViewModel:self.tagsDataArray[indexPath.row] params:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (self.recommendDelegate && [self.recommendDelegate respondsToSelector:@selector(didSelectItemOfIndex:)]) {
        [self.recommendDelegate didSelectItemOfIndex:indexPath.row];
    }
}
#pragma mark - Lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.itemSize = CGSizeMake(45, 65);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.contentInset = UIEdgeInsetsMake(8, 15, 8, 15);

        [_collectionView registerClass:[JHRecommendTagsCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHRecommendTagsCollectionCell class])];

    }
    return _collectionView;
}


@end
