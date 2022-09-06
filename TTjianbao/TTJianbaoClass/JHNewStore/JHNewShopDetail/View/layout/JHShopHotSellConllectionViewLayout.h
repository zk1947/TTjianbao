//
//  JHShopHotSellConllectionViewLayout.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHShopHotSellConllectionViewLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol JHShopHotSellConllectionViewLayoutDelegate <NSObject>

@required

-(CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout*)shopCVLayout heighForItemAtIndexPath:(NSIndexPath*)indexPath itemWidth:(CGFloat)itemWidth;

@optional

-(NSInteger)numberOfColumnInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout*)shopCVLayout;

-(CGFloat)columnSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout*)shopCVLayout;

-(CGFloat)rowSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout*)shopCVLayout;

-(UIEdgeInsets)itemEdgeInsetInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout*)shopCVFlowLayout;


@end

@interface JHShopHotSellConllectionViewLayout : UICollectionViewLayout

@property(nonatomic,weak) id<JHShopHotSellConllectionViewLayoutDelegate> shopLayoutDelegate;

@end

NS_ASSUME_NONNULL_END
