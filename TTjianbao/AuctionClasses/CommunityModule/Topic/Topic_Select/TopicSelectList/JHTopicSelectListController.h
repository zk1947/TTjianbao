//
//  JHTopicSelectListController.h
//  TTjianbao
//
//  Created by wuyd on 2019/7/29.
//  Copyright © 2019 Netease. All rights reserved.
//  话题选择列表页，热门话题列表在 <JHTopicSelectListView> 展示，搜索结果在本页展示
//

@class CTopicData;

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicSelectListController : UIViewController

+ (void)showFromVC:(UIViewController *)preVC defaultData:(nullable CTopicData *)defaultData doneBlock:(void(^)(CTopicData * _Nullable data))block;

@end

NS_ASSUME_NONNULL_END
