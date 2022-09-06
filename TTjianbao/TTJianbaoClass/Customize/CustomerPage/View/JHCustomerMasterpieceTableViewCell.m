//
//  JHCustomerMasterpieceTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerMasterpieceTableViewCell.h"
#import "JHMasterpieceCollectionViewCell.h"
#import "JHLiveRoomModel.h"
#import "NSObject+Cast.h"

@interface JHCustomerMasterpieceTableViewCell () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, strong) UILabel          *titleLabel;
@property (nonatomic, strong) UICollectionView *mpCollectionView;
@end

@implementation JHCustomerMasterpieceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)setupViews {
    UICollectionViewFlowLayout *layout              = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing                  = 10.f;
    layout.minimumLineSpacing                       = 10.f;
    layout.scrollDirection                          = UICollectionViewScrollDirectionHorizontal;
    /// layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
//    layout.estimatedItemSize                        = CGSizeMake(150.f, 0);
    UICollectionView *mpCollectionView              = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    mpCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
    mpCollectionView.delegate                       = self;
    mpCollectionView.dataSource                     = self;
    mpCollectionView.showsHorizontalScrollIndicator = NO;
    mpCollectionView.contentInset                   = UIEdgeInsetsMake(0, 15.f, 0.f, 0.f);
    [self.contentView addSubview:mpCollectionView];
    self.mpCollectionView                           = mpCollectionView;
    
    [mpCollectionView registerClass:[JHMasterpieceCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMasterpieceCollectionViewCell class])];
    
    [mpCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10.f, 0.f, 5.f, 0.f));
    }];
}


#pragma mark - Delegate DataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(150.f, 188.f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMasterpieceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMasterpieceCollectionViewCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

#pragma mark - FlowLayoutDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.masterActionBlock) {
        self.masterActionBlock(indexPath.row);
    }
}

- (void)setViewModel:(id)viewModel {
    JHLiveRoomModel *model = [JHLiveRoomModel cast:viewModel];
    [self.dataSourceArray removeAllObjects];
    if (model) {
        [self.dataSourceArray addObjectsFromArray:model.opusList];
    }
    [self.mpCollectionView reloadData];
}

@end
