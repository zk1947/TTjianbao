//
//  JHMallListView.h
//  TTjianbao
//
//  Created by lihui on 2020/12/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"


NS_ASSUME_NONNULL_BEGIN

@class JHMallCateModel;

@interface JHMallListView : BaseView
@property (nonatomic, assign) BOOL isRefresh;
///所属下标
@property (nonatomic, assign) NSInteger pageIndex;
///为宝友把关数量
@property (nonatomic, copy) NSString *orderCount;

@property (nonatomic, assign) BOOL needRequestData;

- (instancetype)initWithChannelInfo:(JHMallCateModel * _Nullable)model;
- (void)scrollViewToListTop;
- (void)refreshData;
- (void)beginPullSteam;
- (void)shutdownPlayStream;
- (void)changeCategaryUpLoad;
@end

NS_ASSUME_NONNULL_END
