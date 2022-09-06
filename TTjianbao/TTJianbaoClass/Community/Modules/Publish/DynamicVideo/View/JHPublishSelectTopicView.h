//
//  JHPublishSelectTopicView.h
//  TTjianbao
//  Description:选择话题View
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishSelectTopicView : UIView

//此页面全部数据
- (void)updateTopicData:(id)topic;
//刷新选择话题cell
- (void)updateSelectedArray:(id)model;
//选中话题数组
- (NSArray*)topicSelectedArray;
@end

NS_ASSUME_NONNULL_END
