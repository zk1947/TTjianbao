//
//  JHStoneResaleViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JHBaseViewExtController.h"
#import "HGSegmentedPageViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoneResaleViewController : JHBaseViewExtController
- (void)segmentedPageViewControllerWillBeginDragging ;
- (void)segmentedPageViewControllerDidEndDragging ;
-(void)tableBarSelect:(NSInteger)currentIndex;//点tablebar 刷新
-(void)scrollPageIndex:(NSUInteger)index;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@end

NS_ASSUME_NONNULL_END
