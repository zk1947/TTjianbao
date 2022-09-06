//
//  JHFansEquityCollectionView.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansEquityCollectionView.h"
#import "JHEquityInfoCollectionViewCell.h"

@interface JHFansEquityCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHFansEquityLVModel *model;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation JHFansEquityCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.backgroundColor = UIColor.whiteColor;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    titleLabel.textColor = kColor333;
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"专属权益";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    
    _nameLabel.font = JHFont(10);
    _nameLabel.textColor = kColor999;
    _nameLabel.numberOfLines = 1;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right);
        make.top.equalTo(@15);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(40, 0, 0, 0));
    }];
}
- (void)resetCollectWithModel:(JHFansEquityLVModel *)model{
    self.model = model;
    _nameLabel.text = [NSString stringWithFormat:@" （共%ld项）",self.model.rewardVos.count];
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.rewardVos.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHEquityInfoCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHEquityInfoCollectionViewCell class]) forIndexPath:indexPath];

    [cell resetCollectCell:self.model.rewardVos[indexPath.item] andBgImage:self.model.isget];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     CGSize size = CGSizeMake(self.width/3, 116);
     return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;


    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(0, 0);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        
        [_collectionView registerClass:[JHEquityInfoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHEquityInfoCollectionViewCell class])];
        

    }
    return _collectionView;
}

@end
