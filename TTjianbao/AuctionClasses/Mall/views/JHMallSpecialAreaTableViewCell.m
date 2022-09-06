//
//  JHMallSpecialAreaTableViewCell.m
//  TTjianbao
//
//  Created by 姜超 on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallSpecialAreaTableViewCell.h"

#import "JHWindowCollectionCell.h"
#import "UIView+CornerRadius.h"
#import "JHStoreHomeCardModel.h"
#import "JHMallAreaCollectionViewCell.h"

@interface JHMallSpecialAreaTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *showcaseList;
@property (nonatomic, assign) UIRectCorner rectCorner;

@end

@implementation JHMallSpecialAreaTableViewCell

+ (CGFloat)cellHeight {
    return (ScreenW-20-2)/3*imageRate;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
        _rectCorner = UIRectCornerAllCorners;
        [self clipCorners];
    }
    return self;
}

- (void)initViews {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = kColorF5F6FA;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = YES;
        [self.contentView addSubview:_collectionView];

        [_collectionView registerClass:[JHMallAreaCollectionViewCell class] forCellWithReuseIdentifier:kCellId_JHMallSpecialAreaId];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
               
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
    }
}

- (void)clipCorners {
    
    [_collectionView layoutIfNeeded];
    [_collectionView yd_setCornerRadius:8.f corners:_rectCorner];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.specialAreaModes.count>3) {
          return 3;
    }
    return self.specialAreaModes.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHMallSpecialAreaId forIndexPath:indexPath];
    cell.specialAreaMode = self.specialAreaModes[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    JHMallSpecialAreaModel *model = self.specialAreaModes[indexPath.row];
   [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:@""];
     NSDictionary *dic = @{@"position":model.code,@"areaId":model.operationAreaItemId};
    DDLogInfo(@"target==%@",[model mj_keyValues]);
    DDLogInfo(@"dic==%@",dic);
       [JHGrowingIO trackEventId:JHTrackMallSpecialAreaClick variables:dic];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        header.backgroundColor = kColorF5F6FA;
        return header;
    }
    
    return [[UICollectionReusableView alloc] init];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenW-20, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenW - 20-2)/3, [JHMallSpecialAreaTableViewCell cellHeight]);
}
-(void)setSpecialAreaModes:(NSMutableArray<JHMallSpecialAreaModel *> *)specialAreaModes{
    
    _specialAreaModes=specialAreaModes;
    [self.collectionView reloadData];
}
@end
