//
//  JHBasePostDetailController.h
//  TTjianbao
//
//  Created by lihui on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHPostDetailHeaderTableCell.h"
#import "JHSubCommentTableCell.h"
#import "JHPostDetailPicInfoTableCell.h"
#import "JHPostDetailTextTableCell.h"
#import "JHPostDtailEnterTableCell.h"
#import "JHPostDetailPlateEnterTableCell.h"
#import "JHPostMainCommentHeader.h"
#import "JHPostDetailToolBar.h"
#import "JHPostDetailEnum.h"
#import "TTjianbaoMarcoEnum.h"
#define kToolBarHeight  (UI.bottomSafeAreaHeight + 44)

NS_ASSUME_NONNULL_BEGIN

@class JHPostData;

@interface JHBasePostDetailController : JHBaseViewController

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIView *tableFooter;
///底部工具栏
@property (nonatomic, strong) JHPostDetailToolBar *toolBar;
@property (nonatomic, strong) JHPostDetailModel *postDetaiInfo;

/// 0-不做处理   1-滚动到评论  2-滚动到评论+弹起评论框
@property (nonatomic, assign) NSInteger scrollComment;

///刷新
- (void)refreshData;
///加载更多
- (void)loadMoreData;

- (void)setupRecyclingMoneyLayer:(JHPostDetailModel *)detailModel ;
///底部工具栏的点击事件
- (void)bottomToolBarAction:(JHPostDetailActionType)actionType;

@end

NS_ASSUME_NONNULL_END
