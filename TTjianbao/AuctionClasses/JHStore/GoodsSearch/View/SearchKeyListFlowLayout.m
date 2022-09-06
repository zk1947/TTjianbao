//
//  SearchKeyListFlowLayout.m
//  ForkNews
//
//  Created by wuyd on 2018/5/14.
//  Copyright © 2018年 wuyd. All rights reserved.
//

#import "SearchKeyListFlowLayout.h"
#import "SearchKeyListHeader.h"

@interface UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end


@implementation UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset
{
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end


@implementation SearchKeyListFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0, 15, 10, 15);
        //整体边距优先级
        self.minimumLineSpacing = 10; //行间距
        self.minimumInteritemSpacing = 10; //item间距
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    
    return updatedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
    
    BOOL isFirstItemInSection = indexPath.item == 0;
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
    
    if (isFirstItemInSection) {
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);
    
    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
    
    if (isFirstItemInRow) {
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
        
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
        
    } else {
        return self.sectionInset;
    }
}

@end



