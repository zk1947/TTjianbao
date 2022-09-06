//
//  JHNewStoreHomeGoodsCagetoryView.m
//  TTjianbao
//
//  Created by user on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeGoodsCagetoryView.h"

@implementation JHNewStoreHomeGoodsCagetoryView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//重写父类方法
- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == JXCategoryViewAutomaticDimension) {
        if (self.categoryDataSource &&
            [self.categoryDataSource respondsToSelector:@selector(newStoreListCategory:forIndex:)]) {
            return [self.categoryDataSource newStoreListCategory:self forIndex:index];
        } else {
            return ceilf([self.titles[index]
                          boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                          attributes:@{NSFontAttributeName : self.titleFont}
                          context:nil].size.width);
        }
    } else {
        return self.cellWidth;
    }
}

#pragma mark -
#pragma mark - UIScrollView Delegate
//如果一次有效滑动,只执行一次 可以把判断写在scrollViewDidEndDragging代理里
//实现scrollView代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //全局变量记录滑动前的contentOffset
    //lastOffset = scrollView.contentOffset.y;//判断上下滑动时
    //_lastOffset = self.collectionView.contentOffset.x;//判断左右滑动时
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScrollCallBack) {
        self.didScrollCallBack(self.collectionView);
    }
}
@end
