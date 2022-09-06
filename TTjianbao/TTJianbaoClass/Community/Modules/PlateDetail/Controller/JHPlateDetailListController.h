//
//  JHPlateDetailListController.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "JXPagerView.h"
#import "JHPlateDetailListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateDetailListController : JHBaseListPlayerViewController<JXPagerViewListViewDelegate>

@property (nonatomic, assign) BOOL appear;

@property (nonatomic, strong) JHPlateDetailListViewModel *viewModel;

///刷新数据
- (void)refreshDataBlock:(dispatch_block_t __nullable)block;;

///更多数据
- (void)loadMoreDataBlock:(dispatch_block_t __nullable)block;

- (void)updatePublishDataJustNow;

@end

NS_ASSUME_NONNULL_END
