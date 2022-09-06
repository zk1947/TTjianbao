//
//  JHShopHotSellConllectionViewLayout.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShopHotSellConllectionViewLayout.h"

@interface JHShopHotSellConllectionViewLayout ()

@property(nonatomic,strong) NSMutableArray* attributesArray;

@property(nonatomic,strong) NSMutableArray* columnHeightsArray;

@property(nonatomic,assign) CGFloat contentHeight;

@end

@implementation JHShopHotSellConllectionViewLayout


-(NSMutableArray *)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}
- (NSMutableArray *)columnHeightsArray{
    if (!_columnHeightsArray) {
        _columnHeightsArray = [[NSMutableArray alloc] init];
    }
    return _columnHeightsArray;
}
-(NSUInteger)columnCount{
    if([self.shopLayoutDelegate respondsToSelector:@selector(numberOfColumnInShopCVFlowLayout:)])
    {
        return  [self.shopLayoutDelegate numberOfColumnInShopCVFlowLayout:self];
    }else
    {
        return 2;
    }
}

-(CGFloat)columnSpace{
    if([self.shopLayoutDelegate respondsToSelector:@selector(columnSpaceInShopCVFlowLayout:)])
    {
        return  [self.shopLayoutDelegate columnSpaceInShopCVFlowLayout:self];

    }else
    {
        return 0;
    }
}

-(CGFloat)rowSpace{
    if([self.shopLayoutDelegate respondsToSelector:@selector(rowSpaceInShopCVFlowLayout:)]){
        return [self.shopLayoutDelegate rowSpaceInShopCVFlowLayout:self];
    }else{
        return 0;
    }
}

-(UIEdgeInsets)itemEdgeInset{
    if([self.shopLayoutDelegate respondsToSelector:@selector(itemEdgeInsetInShopCVFlowLayout:)]){
        return  [self.shopLayoutDelegate itemEdgeInsetInShopCVFlowLayout:self];
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    [self.columnHeightsArray removeAllObjects];
    
    for (int i = 0; i < self.columnCount; i++) {
        [self.columnHeightsArray addObject:[NSNumber numberWithInteger:[self itemEdgeInset].top]];
    }
    
    [self.attributesArray removeAllObjects];
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attr];
    }
    
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    
    CGFloat cellW = (collectionViewWidth - [self itemEdgeInset].left - [self itemEdgeInset].right - ([self columnCount] -1)* [self columnSpace])/[self columnCount];
    
    CGFloat cellH = [self.shopLayoutDelegate shopCVLayout:self heighForItemAtIndexPath:indexPath itemWidth:cellW];
    
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeightsArray[0] doubleValue];
    
    for (int i = 1; i < self.columnCount; i++) {
        
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeightsArray[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat cellX = [self itemEdgeInset].left + destColumn * (cellW + [self columnSpace]);
    CGFloat cellY = minColumnHeight;
    if (cellY != [self itemEdgeInset].top) {
        
        cellY += [self rowSpace];
    }
    
    attr.frame = CGRectMake(cellX, cellY, cellW, cellH);
    // 更新最短那一列的高度
    self.columnHeightsArray[destColumn] = @(CGRectGetMaxY(attr.frame));
    
    // 记录内容的高度 - 即最长那一列的高度
    CGFloat maxColumnHeight = [self.columnHeightsArray[destColumn] doubleValue];
    if (self.contentHeight < maxColumnHeight) {
        self.contentHeight = maxColumnHeight;
    }
    return attr;
}
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + [self itemEdgeInset].bottom);
}
@end
