//
//  JHShopWindowController.h
//  TTjianbao
//
//  Created by wuyd on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//  专题（橱窗）页
//

#import "YDBaseViewController.h"
#import "JXPagerView.h"
#import "JHSortMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopWindowController : YDBaseViewController <JXPagerViewListViewDelegate>

///橱窗id
@property (nonatomic, assign) NSInteger showcaseId;
///导航标签id
@property (nonatomic, assign) NSInteger tagId;

///排序类型
@property (nonatomic, assign) JHMenuSortType sortType;

//从哪个页面push过来的
@property (nonatomic,   copy) NSString* fromSource;
@property (nonatomic,   copy) NSString* topicName;

- (void)refreshWithSort:(JHMenuSortType)sort;

@end

NS_ASSUME_NONNULL_END
