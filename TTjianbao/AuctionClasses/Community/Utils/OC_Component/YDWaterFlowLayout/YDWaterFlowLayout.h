//
//  YDWaterFlowLayout.h
//  TTjianbao
//
//  Created by wuyd on 2019/10/16.
//  Copyright © 2019 wuyd. All rights reserved.
//  瀑布流布局，支持头尾视图
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YDWaterFlowLayout;

@protocol YDWaterFlowLayoutDelegate <NSObject>

/** item Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
/** header Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForHeaderInSection:(NSInteger)section;
/** footer Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForFooterInSection:(NSInteger)section;

/** 列数*/
- (NSInteger)yd_numberOfColumnsInFlowLayout:(YDWaterFlowLayout *)flowLayout;

/** 行间距*/
- (CGFloat)yd_spacingForRowInFlowLayout:(YDWaterFlowLayout *)flowLayout;
/** 列间距*/
- (CGFloat)yd_spacingForColumnInFlowLayout:(YDWaterFlowLayout *)flowLayout;

/** 边缘缩进*/
- (UIEdgeInsets)yd_edgeInsetInFlowLayout:(YDWaterFlowLayout *)flowLayout;

@end


@interface YDWaterFlowLayout : UICollectionViewLayout
@property (nonatomic, assign) BOOL isNewStore;
@property (nonatomic,   weak) id<YDWaterFlowLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
