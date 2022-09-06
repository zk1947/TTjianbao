//
//  JHCustomerHonorCerTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerHonorCerTableViewCell.h"
#import "JHHonorCerCollectionViewCell.h"
#import "JHLiveRoomModel.h"
#import "NSObject+Cast.h"

@interface JHCustomerHonorCerTableViewCell () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, strong) UILabel          *titleLabel;
@property (nonatomic, strong) UICollectionView *hcCollectionView;
@end

@implementation JHCustomerHonorCerTableViewCell
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
    layout.minimumLineSpacing                       = 0.f;
    layout.scrollDirection                          = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *hcCollectionView              = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    hcCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
    hcCollectionView.delegate                       = self;
    hcCollectionView.dataSource                     = self;
    hcCollectionView.showsHorizontalScrollIndicator = NO;
    hcCollectionView.contentInset                   = UIEdgeInsetsMake(0, 15.f, 0.f, 0.f);
    hcCollectionView.clipsToBounds = NO;
    [self.contentView addSubview:hcCollectionView];
    self.hcCollectionView                           = hcCollectionView;
    
    [hcCollectionView registerClass:[JHHonorCerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHHonorCerCollectionViewCell class])];
    
    [hcCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10.f, 0.f, 15.f, 0.f));
    }];
}


#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHHonorCerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHHonorCerCollectionViewCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

#pragma mark - FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150.f, 111.5f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.honnerCerActionBlock) {
        self.honnerCerActionBlock(indexPath);
    }
}

- (void)setViewModel:(id)viewModel {
    JHLiveRoomModel *model = [JHLiveRoomModel cast:viewModel];
    [self.dataSourceArray removeAllObjects];
    if (model) {
        [self.dataSourceArray addObjectsFromArray:model.certificateList];
    }
    [self.hcCollectionView reloadData];
}


@end
