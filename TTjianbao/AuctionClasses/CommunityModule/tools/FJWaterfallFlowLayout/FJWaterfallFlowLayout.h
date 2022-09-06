//
//  FJWaterfallFlowLayout.h
//  FJWaterfallFlow
//
//  Created by fujin on 16/1/8.
//  Copyright © 2016年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter;

@class FJWaterfallFlowLayout;
@protocol FJWaterfallFlowLayoutDelegate <NSObject>
@required
//item heigh
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@optional
//section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//section footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

@interface FJWaterfallFlowLayout : UICollectionViewLayout

@property(nonatomic, assign)UIEdgeInsets sectionInset; //sectionInset
@property(nonatomic, assign)CGFloat lineSpacing;  //line space
@property(nonatomic, assign)CGFloat itemSpacing; //item space
@property(nonatomic, assign)CGFloat colCount; //column count
@property(nonatomic, weak)id<FJWaterfallFlowLayoutDelegate> delegate;
@property (nonatomic, assign) BOOL isShowDefaultImage;


@end
