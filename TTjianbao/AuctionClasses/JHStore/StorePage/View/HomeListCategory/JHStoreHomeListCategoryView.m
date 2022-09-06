//
//  JHStoreHomeListCategoryView.m
//  TTjianbao
//
//  Created by wuyd on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeListCategoryView.h"

@interface JHStoreHomeListCategoryView ()
//@property (nonatomic, assign) CGFloat curOffset;
//@property (nonatomic, assign) CGFloat lastOffset;
@end

@implementation JHStoreHomeListCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//重写父类方法
- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == JXCategoryViewAutomaticDimension)
    {
        if (self.categoryDataSource &&
            [self.categoryDataSource respondsToSelector:@selector(homeListCategory:forIndex:)])
        {
            return [self.categoryDataSource homeListCategory:self forIndex:index];
        }
        else
        {
            return ceilf([self.titles[index]
                          boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height)
                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                          attributes:@{NSFontAttributeName : self.titleFont}
                          context:nil].size.width);
        }
    }
    else {
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
    
    //判断上下滑动时
    /**
    if (scrollView.contentOffset.y < lastOffset ){
       //向上
       NSLog(@"上滑");
    } else if (scrollView.contentOffset.y > lastOffset ){
       //向下
       NSLog(@"下滑");
    }
     */
    
    
    //判断左右滑动时
    /**
    if (self.collectionView.contentOffset.x < _lastOffset ){
        //向右
        NSLog(@"左滑-lastOffset = %.2f, curOffset = %.2f", _lastOffset, self.collectionView.contentOffset.x);
    } else if (self.collectionView. contentOffset.x > _lastOffset ){
        //向左
        NSLog(@"右滑-lastOffset = %.2f, curOffset = %.2f", _lastOffset, self.collectionView.contentOffset.x);
    }
     */
}

@end
