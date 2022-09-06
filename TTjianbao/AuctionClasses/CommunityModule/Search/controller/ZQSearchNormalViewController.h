//
//  ZQSearchNormalViewController.h
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQSearchConst.h"
#import "JHDiscoverSearchModel.h"
#import "CTopicModel.h"

@class JHHotWordModel;
@class CSearchKeyData;

@interface ZQSearchNormalViewController : UIViewController

//- (void)setHotDataSource:(NSArray *)datas;
- (void)refreshHistoryView;

///设置热搜词
- (void)setHotList:(NSArray<JHHotWordModel *> *)hotList;
///设置话题
- (void)setTopicList:(NSArray<CTopicData *> *)topicList;


- (void)updateHistoryList;

@property (nonatomic, strong) NSMutableArray <CSearchKeyData*>*historyList;
@property (nonatomic, weak) id<ZQSearchChildViewDelegate> delegate;

@end
