//
//  YDWaterFlowLayout.m
//  TTjianbao
//
//  Created by wuyd on 2019/10/16.
//  Copyright © 2019 wuyd. All rights reserved.
//

#import "YDWaterFlowLayout.h"

static const CGFloat        YDDefaultRowSpacing = 10; //默认行间距
static const CGFloat        YDDefaultColumeSpacing = 10; //默认列间距
static const UIEdgeInsets   YDDefaultEdgeInset = {10, 10, 10, 10}; //默认边缘间距

static const UIEdgeInsets   YDNewStoreDefaultEdgeInset = {9, 9, 9, 9}; //默认边缘间距


@interface YDWaterFlowLayout ()

@property (nonatomic, assign) CGFloat maxColumnHeight; //最高的内容高度
@property (nonatomic, strong) NSMutableArray *attrsArray; //所有cell布局属性
@property (nonatomic, strong) NSMutableArray *columnHeights; //存放每一列最大y值

- (NSInteger)columnCount; //列数
- (CGFloat)rowSpace; //行间距
- (CGFloat)columnSpace; //列间距
- (UIEdgeInsets)edgeInsets; //边缘缩进

@end


@implementation YDWaterFlowLayout

// 生成布局信息
- (void)prepareLayout {
    [super prepareLayout];

    self.maxColumnHeight = 0;
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    [self.attrsArray removeAllObjects];
    
    //创建每一组cell的布局属性
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        //获取每一组头视图(header)属性
        if([self.delegate respondsToSelector:@selector(yd_flowLayout:sizeForHeaderInSection:)]){
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:headerAttrs];
        }
        
        //获取每组内所有cell的布局属性
        NSInteger rowNum = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger i = 0; i < rowNum; i++) {
            //创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            //获取indexPath位置cell对应的布局属性
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
        
        //获取每一组尾视图(footer)属性
        if ([self.delegate respondsToSelector:@selector(yd_flowLayout:sizeForFooterInSection:)]) {
            UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:footerAttrs];
        }
    }
}

//返回所有header、footer、ccell的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

//返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //设置布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes  layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.frame = [self itemFrameAtIndexPath:indexPath];
    
    return attrs;
}

//返回indexPath位置 Header、Footer 对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attri;
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        //头视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        attri.frame = [self headerFrameAtIndexPath:indexPath];
        
    } else {
        //尾视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        attri.frame = [self footerViewFrameAtIndexPath:indexPath];
    }
    
    return attri;
}

//返回内容高度
- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.maxColumnHeight + self.edgeInsets.bottom);
}


#pragma mark -
#pragma mark - Help Methods

- (CGRect)itemFrameAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    //设置布局属性item的frame
    CGFloat w = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnSpace) / self.columnCount;
    
    CGFloat h = 0;
    if ([self.delegate respondsToSelector:@selector(yd_flowLayout:sizeForItemAtIndexPath:)]) {
        h = [self.delegate yd_flowLayout:self sizeForItemAtIndexPath:indexPath].height;
    }
    
    //找出高度最低列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        //取出每一列高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnSpace);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowSpace;
    }
    
    //更新最低列高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(CGRectMake(x, y, w, h)));
    
    //获取内容最大高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.maxColumnHeight < columnHeight) {
        self.maxColumnHeight = columnHeight;
    }
    
    return CGRectMake(x, y, w, h);
}

//返回头视图的布局frame
- (CGRect)headerFrameAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    
    if([self.delegate respondsToSelector:@selector(yd_flowLayout:sizeForHeaderInSection:)]){
        size = [self.delegate yd_flowLayout:self sizeForHeaderInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight;
    
    if (![self.delegate respondsToSelector:@selector(yd_flowLayout:sizeForFooterInSection:)]
        || [self.delegate yd_flowLayout:self sizeForFooterInSection:indexPath.section].height == 0) {
        
        y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight + self.rowSpace;
    }
    
    self.maxColumnHeight = y + size.height ;
    
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.maxColumnHeight)];
    }
    
    return CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
}

//返回尾视图的布局frame
- (CGRect)footerViewFrameAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    
    if([self.delegate respondsToSelector:@selector(yd_flowLayout:sizeForFooterInSection:)]){
        size = [self.delegate yd_flowLayout:self sizeForFooterInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = size.height == 0 ? self.maxColumnHeight : self.maxColumnHeight + self.rowSpace;
    
    self.maxColumnHeight = y + size.height;
    
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.maxColumnHeight)];
    }
    
    return  CGRectMake(x, y, self.collectionView.frame.size.width, size.height);
}


#pragma mark -
#pragma mark - 获取item属性

- (CGFloat)columnSpace {
    if ([self.delegate respondsToSelector:@selector(yd_spacingForColumnInFlowLayout:)]) {
        return [self.delegate yd_spacingForColumnInFlowLayout:self];
    } else {
        if (self.isNewStore) {
            return 9.f;
        }
        return  YDDefaultColumeSpacing;
    }
}

- (CGFloat)rowSpace {
    if ([self.delegate respondsToSelector:@selector(yd_spacingForRowInFlowLayout:)]) {
        return [self.delegate yd_spacingForRowInFlowLayout:self];
    } else {
        if (self.isNewStore) {
            return 9.f;
        }
        return YDDefaultRowSpacing;
    }
}

- (NSInteger)columnCount {
    if ([self.delegate respondsToSelector:@selector(yd_numberOfColumnsInFlowLayout:)]) {
        return [self.delegate yd_numberOfColumnsInFlowLayout:self];
    }
    return 0;
}

- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(yd_edgeInsetInFlowLayout:)]) {
        return [self.delegate yd_edgeInsetInFlowLayout:self];
    } else {
        if (self.isNewStore) {
            return YDNewStoreDefaultEdgeInset;
        }
        return  YDDefaultEdgeInset;
    }
}

#pragma mark -
#pragma mark - Lazy Methods
- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray {
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

@end
