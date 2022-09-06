//
//  JHApplyMicRecommendView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHApplyMicRecommendView.h"
#import "JHMallSpecialAreaCollectionViewCell.h"
#import "UIView+CornerRadius.h"
#import "PayMode.h"
#import "JHGrowingIO.h"
#import "JHOrderReturnViewController.h"
#import "JHApplyMicRecommendCell.h"

@interface JHApplyMicRecommendView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHApplyMicRecommendView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

       
        [self initViews];
      
    }
      return self;
}
- (void)initViews {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
      //  _collectionView.backgroundColor = kColorF5F6FA;
         _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [self addSubview:_collectionView];

        [_collectionView registerClass:[JHApplyMicRecommendCell class] forCellWithReuseIdentifier:@"JHApplyMicRecommendCell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
               
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}
#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataModes.count<=3?self.dataModes.count:3;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHApplyMicRecommendCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHApplyMicRecommendCell" forIndexPath:indexPath];
       cell.liveRoomMode = self.dataModes[indexPath.row];
       return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [JHGrowingIO trackEventId:JHLiveRoomMicRecommendClick variables: @{@"channelLocalId":self.dataModes[indexPath.row].ID}];
    if (self.clickBlock) {
        self.clickBlock(self.dataModes[indexPath.row].ID);
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
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, 10, 0, 10);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((float)(self.width - 20-10)/3, self.height);
}
-(void)setDataModes:(NSMutableArray<JHLiveRoomMode *> *)dataModes{
    
       _dataModes = dataModes;
       [self.collectionView reloadData];
    
}
@end



