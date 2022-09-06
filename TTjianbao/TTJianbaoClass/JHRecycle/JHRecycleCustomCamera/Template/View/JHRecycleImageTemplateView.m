//
//  JHRecycleImageTemplateView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImageTemplateView.h"
#import "JHRecycleImageTemplateNomalCell.h"
#import "JHRecycleImageTemplateAddCell.h"
@interface JHRecycleImageTemplateView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation JHRecycleImageTemplateView

#pragma mark - Life Cycle Functions

- (instancetype)initWithType : (RecycleTemplateCellType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.type = type;
        self.viewModel.type = type;
        [self setupUI];
        [self registerCells];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.reloadData subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView reloadData];
    }];
    [[RACObserve(self.viewModel, currentIndex) skip:1]
    subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        NSInteger index = [x integerValue];
        NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:true];
    }];
}

- (void)scrollToItem {
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.viewModel.currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:true];
}

#pragma mark - Private functions

- (void) registerCells {
    [self.collectionView registerClass:[JHRecycleImageTemplateNomalCell class]
            forCellWithReuseIdentifier:@"JHRecycleImageTemplateNomalCell" ];
    [self.collectionView registerClass:[JHRecycleImageTemplateAddCell class]
            forCellWithReuseIdentifier:@"JHRecycleImageTemplateAddCell" ];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleImageTemplateCellViewModel *model = self.viewModel.itemList[indexPath.item];
    [model.selectedEvent sendNext:nil];
    if (self.cellClickIndex) {
        self.cellClickIndex(indexPath.item);
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleImageTemplateCellViewModel *model = self.viewModel.itemList[indexPath.item];
    
    if (model.cellType == RecycleTemplateCellTypeNomal) {
        JHRecycleImageTemplateNomalCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHRecycleImageTemplateNomalCell" forIndexPath:indexPath];
        item.viewModel = model;
        item.viewModel.index = indexPath.item;
        return item;
    }else {
        JHRecycleImageTemplateAddCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHRecycleImageTemplateAddCell" forIndexPath:indexPath];
        item.viewModel = model;
        item.viewModel.index = indexPath.item;
        return item;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 64;
    CGFloat height = collectionView.frame.size.height;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = UIColor.redColor;
    [self addSubview:self.collectionView];
}
- (void)layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark - Lazy
- (JHRecycleImageTemplateViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHRecycleImageTemplateViewModel alloc] init];
        [self bindData];
    }
    return _viewModel;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = false;
    }
    return _collectionView;
}
@end
