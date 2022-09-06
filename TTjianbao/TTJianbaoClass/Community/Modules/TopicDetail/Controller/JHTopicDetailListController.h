//
//  JHTopicDetailListController.h
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "JXPagerView.h"
#import "JHTopicDetailListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicDetailListController : JHBaseListPlayerViewController <JXPagerViewListViewDelegate>

@property (nonatomic, assign) BOOL appear;

@property (nonatomic, strong) JHTopicDetailListViewModel *viewModel;
///是否支持进入帖子详情页
@property (nonatomic, assign) BOOL supportEnterVideo;


///刷新数据
- (void)refreshDataBlock:(dispatch_block_t __nullable)block;;

///更多数据
- (void)loadMoreDataBlock:(dispatch_block_t __nullable)block;

@end

NS_ASSUME_NONNULL_END
