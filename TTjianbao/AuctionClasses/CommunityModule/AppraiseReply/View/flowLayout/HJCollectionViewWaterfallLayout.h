//
//  HJCollectionViewWaterfallLayout.h
//  Demo
//
//  Created by 张海军 on 2018/1/4.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const HJElementKindSectionHeader = @"HJElementKindSectionHeader";
static NSString *const HJElementKindSectionFooter = @"HJElementKindSectionFooter";

@class HJCollectionViewWaterfallLayout;
@protocol HJCollectionViewWaterfallLayoutDelegate <UICollectionViewDelegate>

@required
/**
 item size
 */
- (CGSize)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 每组单行的排布个数
 */
- (NSInteger)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout columCountAtSection:(NSInteger)section;
/**
 每组头部视图的高度
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForHeaderAtSection:(NSInteger)section;
/**
 每组尾部视图的高度
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForFooterAtSection:(NSInteger)section;

/**
 每组的UIEdgeInsets
 */
- (UIEdgeInsets)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSection:(NSInteger)section;

/**
 每组的minimumLineSpacing 行与行之间的距离
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSection:(NSInteger)section;

/**
 每组的minimumInteritemSpacing 同一行item之间的距离 
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSection:(NSInteger)section;

@end

@interface HJCollectionViewWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak)   id<HJCollectionViewWaterfallLayoutDelegate>delegate;
@property (nonatomic, assign) NSInteger columCount;            // 每行多少个item 默认为 1
@property (nonatomic, assign) CGFloat minimumLineSpacing;      // 行于行之间的距离 默认 10.0
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; // 同一行item之间的距离 默认 10.0
@property (nonatomic, assign) CGFloat sectionHeaderH;          // 组头部视图的高度
@property (nonatomic, assign) CGFloat sectionFooterH;          // 组尾部视图的高度
@end
