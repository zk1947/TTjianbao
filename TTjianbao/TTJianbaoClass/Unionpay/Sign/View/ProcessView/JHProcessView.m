//
//  JHProcessView.m
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHProcessView.h"
#import "JHProcessCollectionViewCell.h"
#import "JHUnionPayModel.h"

@interface JHProcessView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHProcessModel *lastProcess;

@end

@implementation JHProcessView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentSelectIndex = 0;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _collectionView = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        ccView.backgroundColor = [UIColor clearColor];
        ccView.delegate = self;
        ccView.dataSource = self;
        ccView;
    });
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[JHProcessCollectionViewCell class] forCellWithReuseIdentifier:kProcessCellIdentifer];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex {
    _currentSelectIndex = currentSelectIndex;
    [self configProcessData];
    [_collectionView reloadData];
}

- (void)setProcessArray:(NSArray *)processArray {
    if (!processArray) {
        return;
    }
    _processArray = processArray;
    [self configProcessData];
    [_collectionView reloadData];
}

- (void)configProcessData {
    for (int i = 0; i < _processArray.count; i ++) {
        JHProcessModel *model = _processArray[i];
        model.showLeftLine = (i != 0);
        model.showRightLine = (i != _processArray.count - 1);
        if (i < _currentSelectIndex) {
            ///已经完成 左右两边的线均为黄色
            model.isFinished = YES;
            model.leftlineColor = HEXCOLOR(0xFFEE00);
            model.rightlineColor = HEXCOLOR(0xFFEE00);
        }
        else if (i == self.currentSelectIndex) {
            ///当前正在执行的步骤
            model.isFinished = YES;
            model.leftlineColor = HEXCOLOR(0xFFEE00);
            model.rightlineColor = HEXCOLOR(0xE3E3E3);
        }
        else {
            model.isFinished = NO;
            model.leftlineColor = HEXCOLOR(0xE3E3E3);
            model.rightlineColor = HEXCOLOR(0xE3E3E3);
        }
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.processArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHProcessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProcessCellIdentifer forIndexPath:indexPath];
    JHProcessModel *model = self.processArray[indexPath.item];
    cell.processModel = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.width/self.processArray.count, self.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}





@end
