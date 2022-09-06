//
//  JHRecycleHomeHotGoodsCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeHotGoodsCell.h"
#import "JHRecycleHomeHotGoodsCollectionViewCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHRecycleHomeGoodsViewController.h"
#import "JHRecycleItemViewModel.h"
#import "JHRecycleGoodsDetailInfoViewController.h"

@interface JHRecycleHomeHotGoodsCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JHRecycleHomeHotGoodsCell

#pragma mark  - UI
- (void)configUI{
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(12);
    }];
    [self.backView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.titleLabel);

    }];
    
    
    [self.backView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(46);
        make.left.right.equalTo(self.backView);
        make.height.mas_offset(0);
    }];
    
    [self.backView addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
}

#pragma mark  - LoadData
- (void)bindViewModel:(id)dataModel{
    [self.dataArray removeAllObjects];
    JHRecycleItemViewModel *itemViewModel = dataModel;
    JHRecycleHomeModel *recycleHomeModel = (JHRecycleHomeModel*)itemViewModel.dataModel;
    [self.dataArray addObjectsFromArray:recycleHomeModel.productAggVOList];
    NSInteger cellCount ;
    if (self.dataArray.count%3>0) {
    cellCount = self.dataArray.count/3+1;
  }
    else{
    cellCount = self.dataArray.count/3;
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(cellCount* HotGoodsCellHeight);
    }];
    
    [self.collectionView reloadData];
    
    self.moreButton.hidden = !(self.dataArray.count >= GoodLimitCount);
    _subTitleLabel.text = [NSString stringWithFormat:@"/ 累计回收%@件",recycleHomeModel.productCount?:@"0"];
   
}


#pragma mark  - Action
- (void)clickMoreBtnAction:(UIButton *)sender{
    JHRecycleHomeGoodsViewController *goodsVC = [[JHRecycleHomeGoodsViewController alloc] init];
    goodsVC.currentIndex = 0;
    goodsVC.goodsCateId = @"";
    [JHRootController.currentViewController.navigationController pushViewController:goodsVC animated:YES];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSeeMore" params:@{
        @"more_type":@"hotRecycleGoods",
        @"page_position":@"recycleHome"
    } type:JHStatisticsTypeSensors];
}


#pragma mark  - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHRecycleHomeHotGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHRecycleHomeHotGoodsCollectionViewCell class]) forIndexPath:indexPath];
    
    JHHomeHotRecycleProductsListModel *goodsListModel = self.dataArray[indexPath.row];
    [cell bindViewModel:goodsListModel params:nil];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    JHHomeHotRecycleProductsListModel *goodsListModel = self.dataArray[indexPath.row];
    
    JHRecycleGoodsDetailInfoViewController *vc = [[JHRecycleGoodsDetailInfoViewController alloc] init];
    vc.productId = goodsListModel.productId;
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    
    NSString *is_configure = goodsListModel.productId.length>0 ? @"false" : @"true";
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickGoods" params:@{
        @"commodity_id":goodsListModel.productId.length>0 ? goodsListModel.productId : @"无",
        @"is_configure":is_configure,
        @"goods_type":@"hotRecycle",
        @"page_position":@"recycleHome"
    } type:JHStatisticsTypeSensors];
}


#pragma mark  - 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 5;
        
//        CGFloat width = (ScreenW-12)*4/3;
//        CGFloat height = width + 50;
        flowLayout.itemSize = CGSizeMake(HotGoodsCellWidth, HotGoodsCellHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _collectionView.backgroundColor = UIColor.whiteColor;
        
        [_collectionView registerClass:[JHRecycleHomeHotGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHRecycleHomeHotGoodsCollectionViewCell class])];

    }
    return _collectionView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _titleLabel.text = @"大家都在卖";
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textColor = HEXCOLOR(0x222222);
        _subTitleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        //_subTitleLabel.text = @"/ 累计回收63463件";
    }
    return _subTitleLabel;
}
- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_moreButton setImage:[UIImage imageNamed:@"recycle_homeMore_right_icon"] forState:UIControlStateNormal];
        _moreButton.backgroundColor = HEXCOLOR(0xf7f7f7);
        _moreButton.layer.cornerRadius = 4;
        _moreButton.clipsToBounds = YES;
        [_moreButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [_moreButton addTarget:self action:@selector(clickMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreButton;
}
@end
