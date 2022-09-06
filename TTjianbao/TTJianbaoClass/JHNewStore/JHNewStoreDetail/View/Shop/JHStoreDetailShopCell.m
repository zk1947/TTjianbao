//
//  JHStoreDetailShopCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailShopCell.h"
#import "JHStoreDetailShopItem.h"
#import "JHStoreDetailBaseFlowLayout.h"

@interface JHStoreDetailShopCell()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation JHStoreDetailShopCell

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
    
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.collectionView];
}
- (void) layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.right.equalTo(self).offset(-LeftSpace);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-LeftSpace);
    }];
}
- (void)registerCells {
    [self.collectionView registerClass:[JHStoreDetailShopItem class] forCellWithReuseIdentifier:@"JHStoreDetailShopItem"];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailShopItemViewModel *model = self.viewModel.itemList[indexPath.item];
    JHStoreDetailShopItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHStoreDetailShopItem" forIndexPath:indexPath];
    item.viewModel = model;
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailShopItemViewModel *model = self.viewModel.itemList[indexPath.item];
    return CGSizeMake(model.width, model.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return shopItemSpace;
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailShopViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JHStoreDetailBaseFlowLayout *layout = [[JHStoreDetailBaseFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.scrollEnabled = false;
        _collectionView.userInteractionEnabled = false; // 不需要点单item
    }
    return _collectionView;
}
@end
