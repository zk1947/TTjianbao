//
//  JHStoreDetailTagCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailTagCell.h"
#import "JHStoreDetailTagItem.h"
#import "JHStoreDetailTagFlowLayout.h"

@interface JHStoreDetailTagCell()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation JHStoreDetailTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    [self.collectionView reloadData];
//    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(ScreenW - 24).priority(100);
//    }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.collectionView];
}
- (void) layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, LeftSpace, TagTopSpace, LeftSpace));
//        make.height.mas_equalTo(ScreenW - 24).priority(100);
    }];
}
- (void) registerCells {
    [self.collectionView registerClass:[JHStoreDetailTagItem class] forCellWithReuseIdentifier:@"JHStoreDetailTagItem"];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailTagItemViewModel *model = self.viewModel.itemList[indexPath.item];
    JHStoreDetailTagItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHStoreDetailTagItem" forIndexPath:indexPath];
    item.viewModel = model;
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailTagItemViewModel *model = self.viewModel.itemList[indexPath.item];
    return CGSizeMake(model.width, model.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return TagItemSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return TagItemSpace;
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailTagViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
    
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JHStoreDetailTagFlowLayout *layout = [[JHStoreDetailTagFlowLayout alloc] initWthType:AlignWithLeft];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.scrollEnabled = false;
    }
    return _collectionView;
}
@end
