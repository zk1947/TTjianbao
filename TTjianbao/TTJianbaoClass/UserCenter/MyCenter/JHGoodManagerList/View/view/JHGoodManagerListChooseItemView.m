//
//  JHGoodManagerListChooseItemView.m
//  TTjianbao
//
//  Created by user on 2021/8/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListChooseItemView.h"
#import "JHGoodManagerListChooseItemCollectionViewCell.h"
#import "CommAlertView.h"
#import "JHGoodManagerSingleton.h"

@interface JHGoodManagerListChooseItemView () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *chooseCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataArray;
@end

@implementation JHGoodManagerListChooseItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xFFFFFF);

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _chooseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _chooseCollectionView.backgroundColor = HEXCOLOR(0xFFFFFF);
    _chooseCollectionView.delegate = self;
    _chooseCollectionView.dataSource = self;
    _chooseCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_chooseCollectionView];
    
    [_chooseCollectionView registerClass:[JHGoodManagerListChooseItemCollectionViewCell class] forCellWithReuseIdentifier:@"JHGoodManagerListChooseItemCollectionViewCell"];
    [_chooseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodManagerListChooseItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHGoodManagerListChooseItemCollectionViewCell" forIndexPath:indexPath];
    [cell setViewModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isAuction) {
        return  CGSizeMake(ScreenW/4.6f, 46.f);
    }
    return  CGSizeMake(ScreenW/4.f, 46.f);

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    for (int i = 0; i<self.dataArray.count; i++) {
        JHGoodManagerListTabChooseModel *model = self.dataArray[i];
        if (model.isSelected) {
            index = i;
            break;
        }
    }
    if (index == indexPath.row) {
        return;
    }
    JHGoodManagerListTabChooseModel *model = self.dataArray[indexPath.row];
    [JHGoodManagerSingleton shared].productStatus = [NSString stringWithFormat:@"%ld",model.productStatus];
    [self changeData:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——NEWLIST" object:nil];
}

- (void)changeData:(NSInteger)indexpathRow {
    for (int i = 0; i<self.dataArray.count; i++) {
        JHGoodManagerListTabChooseModel *model = self.dataArray[i];
        if (i == indexpathRow) {
            model.isSelected = YES;
        } else {
            model.isSelected = NO;
        }
    }
    [self.chooseCollectionView reloadData];
}

- (void)setviewModel:(NSArray<JHGoodManagerListTabChooseModel *> *)viewModel {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:viewModel];
//    for (int i = 0; i<self.dataArray.count; i++) {
//        JHGoodManagerListTabChooseModel *model = self.dataArray[i];
//        if (i == 0) {
//            model.isSelected = YES;
//        } else {
//            model.isSelected = NO;
//        }
//    }
    [self.chooseCollectionView reloadData];
}

@end
