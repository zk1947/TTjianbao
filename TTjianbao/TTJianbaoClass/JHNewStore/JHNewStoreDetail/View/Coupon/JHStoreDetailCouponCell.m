//
//  JHStoreDetailCouponCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponCell.h"
#import "JHStoreDetailCouponItem.h"
#import "JHStoreDetailBaseFlowLayout.h"

@interface JHStoreDetailCouponCell()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
/// 领券蒙层
@property (nonatomic, strong) UIImageView *maskImageView;
/// 领券
@property (nonatomic, strong) UIButton *colletButton;
/// 更多图标
@property (nonatomic, strong) UIImageView *moreImageView;
@end

@implementation JHStoreDetailCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"ssss");
   
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
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.collectionView];
    [self addSubview:self.maskImageView];
    [self addSubview:self.colletButton];
    [self addSubview:self.moreImageView];
}
- (void) layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.right.equalTo(self).offset(-LeftSpace);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.height.mas_equalTo(24);
    }];
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.width.mas_equalTo(70);
    }];
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-LeftSpace);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    [self.colletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreImageView.mas_left).offset(-4);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(40);
    }];
    
}
- (void) registerCells {
    [self.collectionView registerClass:[JHStoreDetailCouponItem class] forCellWithReuseIdentifier:@"JHStoreDetailCouponItem" ];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailCouponItemViewModel *model = self.viewModel.itemList[indexPath.item];
    JHStoreDetailCouponItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHStoreDetailCouponItem" forIndexPath:indexPath];
    item.viewModel = model;
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailCouponItemViewModel *model = self.viewModel.itemList[indexPath.item];
    return CGSizeMake(model.width, collectionView.bounds.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailCouponViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JHStoreDetailBaseFlowLayout *layout = [[JHStoreDetailBaseFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.scrollEnabled = false;
        [_collectionView setUserInteractionEnabled:false];
    }
    return _collectionView;
}
- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newStore_coupon_mask"]];
    }
    return _maskImageView;
}
- (UIButton *)colletButton {
    if (!_colletButton) {
        _colletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _colletButton
        .jh_fontNum(13)
        .jh_title(@"领券")
        .jh_titleColor([UIColor colorWithHexString:@"FF6A00"]);
        _colletButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_colletButton setUserInteractionEnabled:false];
    }
    return _colletButton;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newStore_more_orange_icon"]];
    }
    return _moreImageView;
}
@end
