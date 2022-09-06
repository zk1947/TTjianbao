//
//  JHRecycleOrderNodeView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderNodeView.h"
#import "JHRecycleOrderNodeItem.h"
#import "JHRecycleOrderNodeLineItem.h"
#import "JHRecycleOrderNodeFlowLayout.h"

@interface JHRecycleOrderNodeView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation JHRecycleOrderNodeView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
#pragma mark - Action functions
#pragma mark - Private Functions
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView reloadData];
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    [self addSubview:self.collectionView];
    
}
- (void)layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (void) registerCells {
    [self.collectionView registerClass:[JHRecycleOrderNodeItem class] forCellWithReuseIdentifier:@"JHRecycleOrderNodeItem" ];
    [self.collectionView registerClass:[JHRecycleOrderNodeLineItem class] forCellWithReuseIdentifier:@"JHRecycleOrderNodeLineItem" ];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHRecycleOrderNodeBaseViewModel *model = self.viewModel.itemList[indexPath.item];
    if (model.nodeType == RecycleOrderNodeTypeNomal) {
        JHRecycleOrderNodeItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHRecycleOrderNodeItem" forIndexPath:indexPath];
        if ([model isKindOfClass:[JHRecycleOrderNodeItemViewModel class]]) {
            item.viewModel = (JHRecycleOrderNodeItemViewModel *)model;
        }
        return item;
    }else {
        JHRecycleOrderNodeLineItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHRecycleOrderNodeLineItem" forIndexPath:indexPath];
        if ([model isKindOfClass:[JHRecycleOrderNodeLineItemViewModel class]]) {
            item.viewModel = (JHRecycleOrderNodeLineItemViewModel *)model;
        }
        return item;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderDetailBaseViewModel *model = self.viewModel.itemList[indexPath.item];
    return CGSizeMake(model.width, collectionView.bounds.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderNodeViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JHRecycleOrderNodeFlowLayout *layout = [[JHRecycleOrderNodeFlowLayout alloc] init];
        layout.cellType = AlignWithCenter;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = false;
        [_collectionView setPagingEnabled:true];
    }
    return _collectionView;
}

@end
