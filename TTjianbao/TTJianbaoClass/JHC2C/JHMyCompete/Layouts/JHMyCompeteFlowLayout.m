//
//  JHMyCompeteFlowLayout.m
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteFlowLayout.h"
#import "JHMyCompeteFlowLayoutDelegate.h"

@interface JHMyCompeteFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray; //属性数组
@property (nonatomic, strong) NSMutableArray *columnHeightsArray;        //
@property (nonatomic, assign) CGFloat itemWidth;                        //item、宽度

@end

@implementation JHMyCompeteFlowLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        
        _attributesArray = [[NSMutableArray alloc] init];
        _columnHeightsArray = [[NSMutableArray alloc] init];
        // 设置默认属性
        _columnCount = 2;
        _contentHeight = 0.0;
        _itemSpacing = CGSizeMake(9, 9);
        _sectionInset = UIEdgeInsetsMake(9, 12, 0, 12);
        
    }
    return self;
}

- (CGFloat)itemWidth {
    CGFloat allmargin = (_columnCount - 1) * _itemSpacing.width;
    CGFloat remainingWidth = self.collectionView.bounds.size.width - allmargin - _sectionInset.left - _sectionInset.right;
    return remainingWidth / _columnCount;
}


/// 计算每个item的大小和位置
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    [self.columnHeightsArray removeAllObjects];
    
    for (int i = 0; i < self.columnCount; i++) {
        [self.columnHeightsArray addObject:[NSNumber numberWithInteger:_sectionInset.top]];
    }
    
    [self.attributesArray removeAllObjects];
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attr];
    }
    
}

/// 返回每一个item的布局属性
/// @param indexPath <#indexPath description#>
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat cellW = self.itemWidth;
    
    CGFloat cellH = [self.delegate shopCVLayout:self heighForItemAtIndexPath:indexPath itemWidth:cellW];
    
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
    
    CGFloat cellX = _sectionInset.left + destColumn * (cellW + _itemSpacing.height);
    CGFloat cellY = minColumnHeight;
    if (cellY != _sectionInset.top) {
        
        cellY += _itemSpacing.width;
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

/// 返回collectionview的滚动范围
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + _sectionInset.bottom);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}

@end
