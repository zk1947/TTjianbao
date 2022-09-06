//
//  ZQSearchNormalLayout.m
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQSearchNormalLayout.h"

@implementation ZQSearchNormalLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 9.f;
        self.minimumInteritemSpacing = 8.f;
        self.maximumInteritemSpacing = 9.f;
//        self.isFold = YES;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [attributes count]; ++i) {
        //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
        
        CGFloat preAttrMaxX = CGRectGetMaxX(preAttr.frame);
        //根据  maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = preAttrMaxX + self.minimumInteritemSpacing;
        // 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
        if (CGRectGetMinX(curAttr.frame) > targetX) {
            // 换行时不用调整
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }
//        if (curAttr.indexPath.section == 0 && !curAttr.representedElementKind) {
//            if (CGRectGetMaxY(curAttr.frame) > (3 * curAttr.frame.size.height + 20 + 50))
//            {
//                curAttr.frame = self.isFold ? CGRectZero : curAttr.frame;
//            }else{
//                curAttr.frame = curAttr.frame;
//            }
//        }
    }
    return attributes;
}


@end
