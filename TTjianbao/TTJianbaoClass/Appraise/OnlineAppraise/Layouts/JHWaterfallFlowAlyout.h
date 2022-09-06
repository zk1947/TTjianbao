//
//  JHWaterfallFlowAlyout.h
//  TTjianbao
//
//  Created by lihui on 2021/1/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHWaterfallFlowAlyout;

@protocol JHWaterfallFlowLayoutDelegate <NSObject>

@required
/// 返回`计算后的高`
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(JHWaterfallFlowAlyout *)layout
                itemWidth:(CGFloat)width
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/// 动态切换`排数`(default = 2 if not return).
- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(JHWaterfallFlowAlyout*)layout
    numberOfColumnInSection:(NSInteger)section;

/// 动态`行间距`
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(JHWaterfallFlowAlyout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
/// 动态`列间距`
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(JHWaterfallFlowAlyout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
/// 动态`块偏移`
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(JHWaterfallFlowAlyout*)layout
        insetForSectionAtIndex:(NSInteger)section;

/// 动态`块头部高度`
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JHWaterfallFlowAlyout*)layout referenceHeightForHeaderInSection:(NSInteger)section;
/// 动态`块尾部高度`
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JHWaterfallFlowAlyout*)layout referenceHeightForFooterInSection:(NSInteger)section;


//@required
/**
// * 每个item的高度
// */
//- (CGFloat)waterFallLayout:(JHWaterfallFlowAlyout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;
//
//@optional
///**
// * 有多少列
// */
//- (NSUInteger)columnCountInWaterFallLayout:(JHWaterfallFlowAlyout *)waterFallLayout;
//
///**
// * 每列之间的间距
// */
//- (CGFloat)columnMarginInWaterFallLayout:(JHWaterfallFlowAlyout *)waterFallLayout;
//
///**
// * 每行之间的间距
// */
//- (CGFloat)rowMarginInWaterFallLayout:(JHWaterfallFlowAlyout *)waterFallLayout;
//
///**
// * 每个item的内边距
// */
//- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(JHWaterfallFlowAlyout *)waterFallLayout;
//
//- (CGFloat)heightForCollectionViewHeader:(JHWaterfallFlowAlyout *)waterFallLayout section:(NSInteger)section;
//- (CGFloat)heightForCollectionViewFooter:(JHWaterfallFlowAlyout *)waterFallLayout section:(NSInteger)section;

@end

@interface JHWaterfallFlowAlyout : UICollectionViewLayout
//@property (nonatomic, weak) id<JHWaterfallFlowLayoutDelegate>delegate;

@property (nonatomic, weak) id<JHWaterfallFlowLayoutDelegate> dataSource;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) BOOL sectionHeadersPinToVisibleBounds;

@end

NS_ASSUME_NONNULL_END
