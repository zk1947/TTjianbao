//
//  HJCollectionViewWaterfallLayout.m
//  Demo
//
//  Created by 张海军 on 2018/1/4.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

#import "HJCollectionViewWaterfallLayout.h"

static const NSInteger unionSize = 1;

@interface HJCollectionViewWaterfallLayout ()
@property (nonatomic, strong) NSMutableDictionary *sectionHeadersAttributes;
@property (nonatomic, strong) NSMutableDictionary *sectionFooterAttributes;
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
@property (nonatomic, strong) NSMutableArray *sectionItemHeights;
@property (nonatomic, strong) NSMutableArray *unionRects;
@end

@implementation HJCollectionViewWaterfallLayout

#pragma mark - init
- (instancetype)init{
    if (self = [super init]) {
        [self commInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commInit];
    }
    return self;
}

- (void)commInit{
    self.columCount = 1;
    self.minimumLineSpacing = 10.0;
    self.minimumInteritemSpacing = 10.0;
    
    self.sectionHeadersAttributes = [NSMutableDictionary dictionary];
    self.sectionFooterAttributes = [NSMutableDictionary dictionary];
    self.sectionItemAttributes = [NSMutableArray array];
    self.allItemAttributes = [NSMutableArray array];
    self.sectionItemHeights = [NSMutableArray array];
    self.unionRects = [NSMutableArray array];
}

#pragma mark - Override
- (void)prepareLayout{
    [super prepareLayout];
    
    // 清空对应数据
    [self.sectionHeadersAttributes removeAllObjects];
    [self.sectionFooterAttributes removeAllObjects];
    [self.sectionItemAttributes  removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.sectionItemHeights removeAllObjects];
    [self.unionRects removeAllObjects];
    
    // 多少组
    NSInteger numberSections = self.collectionView.numberOfSections;
    if (numberSections <= 0) {
        return;
    }
    
    // 构建每组 item 高度数组
    for (NSInteger i = 0; i < numberSections; i++) {
        NSInteger columCount = [self getColumCountAtSection:i];
        NSMutableArray *columItemHeights = [NSMutableArray arrayWithCapacity:columCount];
        for (NSInteger h = 0; h < columCount; h++) {
            [columItemHeights addObject:@0];
        }
        [self.sectionItemHeights addObject:columItemHeights];
    }
    
    CGFloat top = 0.0;
    UICollectionViewLayoutAttributes *attributes = nil;
    NSInteger numberOfSectionItem = 0;
    NSInteger sectionHeaderH = 0.0;
    NSInteger sectionFooterH = 0.0;
    NSInteger sectionColumCount = self.columCount;
    CGFloat minimumLineSpacing = 0.0;
    CGFloat minimumInteritemSpacing = 0.0;
    CGFloat itemW = 0.0;
    UIEdgeInsets sectionInset = UIEdgeInsetsZero;
    NSMutableArray *itemAttribus = nil; // 每组里面对应的item
    
    for (NSInteger section = 0; section < numberSections; section++) {
        numberOfSectionItem = [self.collectionView numberOfItemsInSection:section];
        sectionHeaderH = [self headerHeightAtSection:section];
        sectionFooterH = [self footerHeightAtSection:section];
        sectionInset   = [self insetsAtSection:section];
        sectionColumCount = [self getColumCountAtSection:section];
        minimumLineSpacing = [self minimumLineSpacingAtSection:section];
        minimumInteritemSpacing = [self minimumInteritemSpacingAtSection:section];
        
        // 头部
        if (numberOfSectionItem > 0 && sectionHeaderH) {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HJElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attributes.frame = CGRectMake(0, top, self.collectionView.bounds.size.width, sectionHeaderH);
            self.sectionHeadersAttributes[@(section)] = attributes;
            [self.allItemAttributes addObject:attributes];
            top = CGRectGetMaxY(attributes.frame);
        }
        
        top += sectionInset.top;
        for (NSInteger idx = 0; idx < sectionColumCount; idx++) {
            self.sectionItemHeights[section][idx] = @(top);
        }
        
        // item
        itemAttribus = [NSMutableArray arrayWithCapacity:numberOfSectionItem];
        itemW = [self itemWidthWithSection:section sectionInset:sectionInset];
        for (NSInteger item = 0; item < numberOfSectionItem; item++) {
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:item inSection:section];
            NSInteger columIdx = [self shortestColumnIndexInSection:section];
            CGFloat itemX = sectionInset.left + (itemW + minimumInteritemSpacing) * columIdx;
            CGFloat itemY = [self.sectionItemHeights[section][columIdx] floatValue];
            CGSize itemSize = [self getItemSizeAtIndexPath:itemIndexPath];
            CGFloat itemH = itemW * itemSize.height / itemSize.width;
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
            attributes.frame = CGRectMake(itemX, itemY, itemW, itemH);
            
            [itemAttribus addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            
            self.sectionItemHeights[section][columIdx] = @(CGRectGetMaxY(attributes.frame) + minimumLineSpacing);
        }
        [self.sectionItemAttributes addObject:itemAttribus];
        
        NSInteger maxHIndex = [self longestColumnIndexInSection:section];
        top = [self.sectionItemHeights[section][maxHIndex] floatValue] + sectionInset.bottom;
        for (NSInteger idx = 0; idx < sectionColumCount; idx++) {
            self.sectionItemHeights[section][idx] = @(top);
        }
        
        // 尾部
        if (numberOfSectionItem > 0 && sectionFooterH) {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HJElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attributes.frame = CGRectMake(0, top-minimumLineSpacing,
                                          self.collectionView.bounds.size.width,
                                          sectionFooterH);
            self.sectionFooterAttributes[@(section)] = attributes;
            [self.allItemAttributes addObject:attributes];
            top = CGRectGetMaxY(attributes.frame);
        }
        
        for (NSInteger idx = 0; idx < sectionColumCount; idx++) {
            self.sectionItemHeights[section][idx] = @(top);
        }
    }
    
    NSInteger idx = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while (idx < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        
        NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);
        
        for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }
        
        idx = rectEndIndex;
        
        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
    
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.bounds.size;
    contentSize.height = [[[self.sectionItemHeights lastObject] firstObject] floatValue];

    
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    if (path.section >= [self.sectionItemAttributes count]) {
        return nil;
    }
    if (path.item >= [(NSArray*)self.sectionItemAttributes[path.section] count]) {
        return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([kind isEqualToString:HJElementKindSectionHeader]) {
        attribute = self.sectionHeadersAttributes[@(indexPath.section)];
    } else if ([kind isEqualToString:HJElementKindSectionFooter]) {
        attribute = self.sectionFooterAttributes[@(indexPath.section)];
    }
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableDictionary *cellAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplHeaderAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplFooterAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *decorAttrDict = [NSMutableDictionary dictionary];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * unionSize;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            switch (attr.representedElementCategory) {
                case UICollectionElementCategorySupplementaryView:
                    if ([attr.representedElementKind isEqualToString:HJElementKindSectionHeader]) {
                        supplHeaderAttrDict[attr.indexPath] = attr;
                    } else if ([attr.representedElementKind isEqualToString:HJElementKindSectionFooter]) {
                        supplFooterAttrDict[attr.indexPath] = attr;
                    }
                    break;
                case UICollectionElementCategoryDecorationView:
                    decorAttrDict[attr.indexPath] = attr;
                    break;
                case UICollectionElementCategoryCell:
                    cellAttrDict[attr.indexPath] = attr;
                    break;
            }
        }
    }
    
    NSArray *result = [cellAttrDict.allValues arrayByAddingObjectsFromArray:supplHeaderAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:supplFooterAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:decorAttrDict.allValues];
    return result;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}


#pragma mark - prive method
/**
 获取当前组头部视图的高度
 */
- (CGFloat)headerHeightAtSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:heightForHeaderAtSection:)]) {
        return [self.delegate hj_collectionView:self.collectionView layout:self heightForHeaderAtSection:section];
    }
    return self.sectionHeaderH;
}

/**
 获取当前组尾部视图的高度
 */
- (CGFloat)footerHeightAtSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:heightForFooterAtSection:)]) {
        return [self.delegate hj_collectionView:self.collectionView layout:self heightForFooterAtSection:section];
    }
    return self.sectionFooterH;
}

/**
 获取当前组 inset 值
 */
- (UIEdgeInsets)insetsAtSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:insetForSection:)]) {
        return [self.delegate hj_collectionView:self.collectionView layout:self insetForSection:section];
    }
    return UIEdgeInsetsZero;
}

/**
 获取当前 item size
 */
- (CGSize)getItemSizeAtIndexPath:(NSIndexPath*)indexPath{
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate hj_collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}

/**
 获取 item 的宽度
 */
- (CGFloat)itemWidthWithSection:(NSInteger)section sectionInset:(UIEdgeInsets)sectionInset{
    NSInteger columCount = self.columCount;
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:columCountAtSection:)]) {
        columCount = [self.delegate hj_collectionView:self.collectionView layout:self columCountAtSection:section];
    }
    return  (self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right - (columCount - 1) * [self minimumInteritemSpacingAtSection:section]) / columCount;
}

/**
 获取每组单行排布数
 */
- (NSInteger)getColumCountAtSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:columCountAtSection:)]) {
        return [self.delegate hj_collectionView:self.collectionView layout:self columCountAtSection:section];
    }
    return self.columCount;
}

/*
 获取该组中行与行之间的距离 minimumLineSpacing;
 */
- (CGFloat)minimumLineSpacingAtSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:minimumLineSpacingForSection:)]) {
        return [self.delegate hj_collectionView:self.collectionView layout:self minimumLineSpacingForSection:section];
    }
    return self.minimumLineSpacing;
}

/**
 获取该组 同一行相邻item之间的距离 minimumInteritemSpacing
 */
- (CGFloat)minimumInteritemSpacingAtSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(hj_collectionView:layout:minimumInteritemSpacingForSection:)]) {
        return [self.delegate hj_collectionView:self.collectionView layout:self minimumInteritemSpacingForSection:section];
    }
    return self.minimumInteritemSpacing;
}

/**
 获取colum中最小高度的位置
 */
- (NSUInteger)shortestColumnIndexInSection:(NSInteger)section {
    __block NSInteger index = 0;
    __block CGFloat maxH = MAXFLOAT;
    NSArray *columItemH = self.sectionItemHeights[section];
    [columItemH enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat currentH = [obj floatValue];
        if (currentH < maxH) {
            maxH = currentH;
            index = idx;
        }
    }];
    return index;
}

/**
 获取colum中最大高度的位置
 */
- (NSUInteger)longestColumnIndexInSection:(NSInteger)section {
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    NSArray *columItemH = self.sectionItemHeights[section];
    [columItemH enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

@end
