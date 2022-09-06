//
//  HGPageViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NELivePlayerViewController.h"
#import "JHBaseViewExtController.h"

@protocol HGPageViewControllerDelegate <NSObject>
- (void)pageViewControllerLeaveTop;
@end
@interface HGPageViewController : JHBaseViewExtController
@property (nonatomic, weak) id<HGPageViewControllerDelegate> delegate;
@property (nonatomic) NSInteger pageIndex;

- (void)makePageViewControllerScroll:(BOOL)canScroll;
- (void)makePageViewControllerScrollToTop;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end
