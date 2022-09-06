//
//  HGSegmentedPageViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGCategoryView.h"
#import "HGPageViewController.h"
#import "JHSourceMallSegmentView.h"
#import "HGPopGestureCompatibleScrollView.h"

@protocol HGSegmentedPageViewControllerDelegate <NSObject>
@optional
- (void)segmentedPageViewControllerWillBeginDragging;
- (void)segmentedPageViewControllerDidEndDragging;
- (void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index;
@end

@interface HGSegmentedPageViewController : UIViewController
@property (nonatomic, strong) JHSourceMallSegmentView *categoryView;
@property (nonatomic, strong) UIColor *categoryButtonClolor;
@property (nonatomic, copy) NSArray<HGPageViewController *> *pageViewControllers;
@property (nonatomic, strong, readonly) HGPageViewController *currentPageViewController;
@property (nonatomic, weak) id<HGSegmentedPageViewControllerDelegate> delegate;
-(void)setPageIndex:(NSUInteger)index;
@property (nonatomic, strong) HGPopGestureCompatibleScrollView *scrollView;
@property (nonatomic) CGFloat segmentWidth;
//-(void)setup;
@end

