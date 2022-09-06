//
//  JHCustomerFeeDescTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerFeeDescTableCell.h"
#import "JHCustomerFeeListCell.h"
#import "JHLiveRoomModel.h"

@interface JHCustomerFeeDescTableCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL showAll;



@end

@implementation JHCustomerFeeDescTableCell

- (void)setFeeInfoArray:(NSArray<JHCustomerFeesInfo *> *)feeInfoArray {
    if (!feeInfoArray || feeInfoArray.count == 0) return;
    _feeInfoArray = feeInfoArray;
    [_collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showAll = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;
    UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    ccView.backgroundColor = UIColor.whiteColor;
    ccView.delegate = self;
    ccView.dataSource = self;
    [self.contentView addSubview:ccView];
    _collectionView = ccView;
    ccView.scrollEnabled = NO;
    
    [ccView registerClass:[JHCustomerFeeListCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomerFeeListCell class])];
    
    [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 5, 15));
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenW-30-10)/2, 40.f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomerFeeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomerFeeListCell class]) forIndexPath:indexPath];
    cell.feeInfo = self.feeInfoArray[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feeInfoArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
