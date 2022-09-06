//
//  JHOriginalMallViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/8/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JHBaseViewExtController.h"
#import "HGSegmentedPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSourceMallViewController : JHBaseViewExtController <JXCategoryListContentViewDelegate>
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, copy) JHActionBlocks refreshBlock;

///选择tabbar后执行下拉刷新
- (void)tableBarSelect:(NSInteger)currentIndex;
- (BOOL)celebrateRunning;

@end

NS_ASSUME_NONNULL_END
