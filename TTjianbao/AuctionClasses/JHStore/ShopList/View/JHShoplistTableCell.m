//
//  JHShoplistTableCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShoplistTableCell.h"
#import "JHShopInfoView.h"
#import "JHGoodsCollecitonCell.h"
#import "JHSellerInfo.h"
#import "JHGoodsInfoMode.h"
#import "JHGoodsDetailViewController.h"


#define kcellSpace  25

@interface JHShoplistTableCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopInfoView *shopInfoView;
@property (nonatomic, copy) NSArray *goodsArray;



@end

@implementation JHShoplistTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSellerInfo:(JHSellerInfo *)sellerInfo {
    _sellerInfo = sellerInfo;
    if (!_sellerInfo) {
        return;
    }
    _shopInfoView.sellerInfo = _sellerInfo;
    _goodsArray = _sellerInfo.goodsArray;
    [_collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _shopInfoView = [[JHShopInfoView alloc] init];
    [self.contentView addSubview:_shopInfoView];
    JH_WEAK(self)
    _shopInfoView.focusBlock = ^{
        JH_STRONG(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(focusShop:)]) {
            [self.delegate focusShop:self.sellerInfo];
        }
    };
    
    _collectionView = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((ScreenW - 40)/3, 161);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 0;
        UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionV.backgroundColor = [UIColor whiteColor];
        collectionV.delegate = self;
        collectionV.dataSource = self;
        collectionV.showsVerticalScrollIndicator = NO;
        collectionV.showsHorizontalScrollIndicator = NO;
        [collectionV registerClass:[JHGoodsCollecitonCell class] forCellWithReuseIdentifier:@"JHGoodsCollecitonCell"];
        collectionV;
    });
    [self.contentView addSubview:_collectionView];
    
    _shopInfoView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(55);
    
    _collectionView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .bottomEqualToView(self.contentView)
    .topSpaceToView(_shopInfoView, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"JHGoodsCollecitonCell";
    JHGoodsCollecitonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    cell.goodsInfo = self.goodsArray[indexPath.row];
    return cell;
}

///跳转商品详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodsInfoMode *data = self.goodsArray[indexPath.item];
    JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
    vc.goods_id = data.goods_id;
    vc.entry_type = JHFromStoreShopHomePage; ///特卖店铺列表
    vc.entry_id = data.seller_id.stringValue; //传店铺id
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.goodsArray.count < 3) {
        return self.goodsArray.count;
    }
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (ScreenW - 40) / 3;
    JHGoodsInfoMode *model = self.goodsArray[indexPath.item];
    return CGSizeMake(itemWidth, model.height);
//    return CGSizeMake(itemWidth, itemWidth + 34 + 8);
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (CGFloat)cellHeight {
    CGFloat itemWidth = (ScreenW - 40) / 3;
    return _shopInfoView.height + itemWidth + 34 + kcellSpace;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
