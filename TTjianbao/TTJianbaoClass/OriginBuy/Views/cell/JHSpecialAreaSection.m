//
//  JHSpecialAreaSection.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSpecialAreaSection.h"
#import "JHMallSpecialAreaCollectionViewCell.h"
#import "UIView+CornerRadius.h"
#import "PayMode.h"
#import "JHOrderReturnViewController.h"
#import "JHApplyMicSuccessAlertView.h"
#import "NTESLiveManager.h"
#import "JHGrowingIO.h"
@interface JHSpecialAreaSection () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray<JHOperationImageModel *> * imageModes;
@end

@implementation JHSpecialAreaSection
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

       
        [self initViews];
       
        // [self yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
      
    }
      return self;
}
- (void)initViews {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
      //  _collectionView.backgroundColor = kColorF5F6FA;
         _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [self addSubview:_collectionView];

        [_collectionView registerClass:[JHMallSpecialAreaCollectionViewCell class] forCellWithReuseIdentifier:kCellId_JHMallSpecialAreaId];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
               
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}
#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.imageModes.count<=4?self.imageModes.count:4;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallSpecialAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHMallSpecialAreaId forIndexPath:indexPath];
   // cell.backgroundColor = [CommHelp randomColor];
    cell.specialAreaMode = self.imageModes[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    JHOperationImageModel * mode = self.imageModes[indexPath.row];
    [JHRootController handleMessageModel:mode.target from:@""];
    [self trackEventWithModel:indexPath]; //埋点
}

- (void)trackEventWithModel:(NSIndexPath *)indexPath
{
    NSInteger count = self.imageModes.count;
    NSInteger row = indexPath.row;
    JHOperationImageModel * model = self.imageModes[row];
    
    if(count == 1)
    {//认为是banner
        NSString* bannerId = [NSString stringWithFormat:@"Banner%@", model.detailsId ? : @""];
        [JHGrowingIO trackEventId:JHMarketTopBannerClick variables: @{@"id":bannerId}];
    }
    else if(count > 1)
    {//认为是运营位,产品要位置
        [JHGrowingIO trackEventId:JHMarketSecondTabSwitch variables: @{@"second_tabname":@(row)}];
    }
    else
    {
        //do nothing
    }
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
    NSInteger  count =self.imageModes.count<=4?self.imageModes.count:4;
    if (count == 3 || count == 4) {
        NSInteger itemW = (ScreenW - 22)/count;
        if(count -1 == indexPath.item)
        {
            itemW = (ScreenW - 20 - itemW * (count - 1));
        }
        return CGSizeMake(itemW, self.height);
    }
    
    return CGSizeMake((ScreenW - 20)/count, self.height);
}
-(void)setDetailMode:(JHOperationDetailModel *)detailMode{
    
        _detailMode=detailMode;
        _imageModes=[_detailMode.definiDetails mutableCopy];
         [self.collectionView reloadData];
}
@end


