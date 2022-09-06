//
//  JHApplyCustomizeOrderView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/9/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHApplyCustomizeOrderView.h"
#import "JHApplyCustomizeOrderCell.h"
#import "UIView+CornerRadius.h"
#import "PayMode.h"
#import "JHOrderReturnViewController.h"
#import "JHApplyMicRecommendCell.h"
#import "JHGrowingIO.h"

@interface JHApplyCustomizeOrderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation JHApplyCustomizeOrderView
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
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10,10, 10,10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //  _collectionView.backgroundColor = kColorF5F6FA;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
     
              _collectionView.showsVerticalScrollIndicator = NO;
              _collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[JHApplyCustomizeOrderCell class] forCellWithReuseIdentifier:@"JHApplyCustomizeOrderCell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}
#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
          return 1;
    }
     return self.dataModes.count;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        JHApplyCustomizeOrderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHApplyCustomizeOrderCell" forIndexPath:indexPath];
          cell.iscamera = YES;
        
          return cell;
    }
    else{
        
        JHApplyCustomizeOrderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHApplyCustomizeOrderCell" forIndexPath:indexPath];
         cell.orderModel = self.dataModes[indexPath.row];
        if (indexPath.row == self.selectIndex) {
            cell.selectImage.hidden = NO;
        }
        else{
            cell.selectImage.hidden = YES;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_cam_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        if(self.cameraBlock){
            self.cameraBlock();
        }
    }
    else{
          [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_ordercam_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        self.selectIndex = indexPath.row;
        [self.collectionView reloadData];
        if(self.clickBlock){
             self.clickBlock(self.dataModes[self.selectIndex]);
        }
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
        return header;
    }
    
    return [[UICollectionReusableView alloc] init];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
         return CGSizeMake(0, 0);
      }
     return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
            return  UIEdgeInsetsMake(0,15, 0,15);
          }
    return  UIEdgeInsetsMake(0,0, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, self.height);
}
-(void)setDataModes:(NSMutableArray<OrderMode *> *)dataModes{
    
    _dataModes = dataModes;
    if (_dataModes.count>0) {
        self.selectIndex = 0;
        if(self.clickBlock){
           self.clickBlock(self.dataModes[self.selectIndex]);
        }
    }
  
    [self.collectionView reloadData];
    
}
@end




