//
//  JHMallMoreCategoryView.m
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallMoreCategoryView.h"
#import "SearchKeyListFlowLayout.h"
#import "JHMallMoreCategoryTitleCell.h"
#import "JHMallCateModel.h"
#import <NSString+YYAdd.h>
#import "JHMallCateModel.h"

@interface JHMallMoreCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHMallCateModel *lastCateModel;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation JHMallMoreCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 0;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    SearchKeyListFlowLayout *layout = [[SearchKeyListFlowLayout alloc] init];
    UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    ccView.backgroundColor = [UIColor whiteColor];
    ccView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    ccView.delegate = self;
    ccView.dataSource = self;
    [self addSubview:ccView];
    _collectionView = ccView;
    [ccView registerClass:[JHMallMoreCategoryTitleCell class] forCellWithReuseIdentifier:kMallCateTitleIdentifer];
    [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    ///监听ccview的contentSize
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)setChannelArray:(NSArray<JHMallCateModel *> *)channelArray {
    if (!channelArray) {
        return;
    }
    _channelArray = channelArray;
    for (JHMallCateModel *model in _channelArray) {
        if (model.isDefault) {
            self.lastCateModel = model;
        }
    }
    [self.collectionView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.heightBlock) {
            self.heightBlock(self.collectionView.contentSize.height);
        }
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallMoreCategoryTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMallCateTitleIdentifer forIndexPath:indexPath];
    cell.cateModel = self.channelArray[indexPath.item];
    return cell;
}

//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallCateModel *model = self.channelArray[indexPath.item];
//    CGFloat imgWidth = 50.f;///包含两边的间距
    CGSize size = [model.name sizeForFont:[UIFont fontWithName:kFontNormal size:13.0] size:CGSizeMake(HUGE, 28) mode:NSLineBreakByWordWrapping];
//    CGFloat cellWidth = (size.width+imgWidth) > (ScreenW-20) ? (ScreenW - 20) : (size.width+imgWidth);
    return CGSizeMake(size.width + 30, 28.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat space = 12.f;
    return UIEdgeInsetsMake(5, space, 15, space);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
};

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath:---- %ld", (long)indexPath.item);
    self.lastCateModel.isDefault = NO;
    JHMallCateModel *model = self.channelArray[indexPath.item];
    if ([model.Id isEqualToString:self.lastCateModel.Id]) {
        return;
    }
    model.isDefault = YES;
    [collectionView reloadData];
    self.lastCateModel = model;
    if (self.selectBlock) {
        self.selectBlock(model, indexPath.item);
    }
    [JHRootController.currentViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

@end
