//
//  JHIMQuickView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIMQuickView.h"
#import "JHIMQuickViewCell.h"


static CGFloat const LeftSpacing = 10.f;

@interface JHIMQuickView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHIMQuickView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self registerCells];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHIMQuickModel *model = self.dataSource[indexPath.item];
    if (self.handler) {
        self.handler(model);
    }
}
- (void)setupData {
    [self.collectionView reloadData];
}
#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xf9f9f9);
    [self addSubview:self.collectionView];
}
- (void)registerCells {
    [self.collectionView registerClass:[JHIMQuickViewCell class] forCellWithReuseIdentifier:@"JHIMQuickViewCell"];
}
- (void)layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LeftSpacing);
        make.right.mas_equalTo(-LeftSpacing);
        make.top.mas_equalTo(16);
        make.bottom.mas_equalTo(-8);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHIMQuickModel *model = self.dataSource[indexPath.item];
    JHIMQuickViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHIMQuickViewCell" forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return estimated; // CGSizeMake(64, 30);
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}
#pragma mark -  Lazy
- (void)setDataSource:(NSArray<JHIMQuickModel *> *)dataSource {
    _dataSource = dataSource;
    [self setupData];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.estimatedItemSize = CGSizeMake(64, 30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = false;
    }
    return _collectionView;
}
@end
