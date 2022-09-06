//
//  JHLotteryListController.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  在PageController中是档期列表数据，直接跳转过来是活动详情
//

#import "YDBaseViewController.h"
#import "JXCategoryView.h"
#import "JHLotteryModel.h"
#import "JHLotteryActivityDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryListController : YDBaseViewController <JXCategoryListContentViewDelegate>

///整体刷新的block
@property (nonatomic, copy) void (^refreshBlock) (JHLotteryListController *controller);

@property (nonatomic, strong) JHLotteryData *curData; //活动数据

@property (nonatomic, copy) NSString *codeStr;
///往期
@property (nonatomic, assign) BOOL isHistory;

@property (nonatomic, assign) BOOL needAddAddress;

///发送分享成功请求
- (void)sendShareCompleteRequest;

///pageController刷新缓存的ListController时 刷新数据
- (void)updateListData;

@end

NS_ASSUME_NONNULL_END
