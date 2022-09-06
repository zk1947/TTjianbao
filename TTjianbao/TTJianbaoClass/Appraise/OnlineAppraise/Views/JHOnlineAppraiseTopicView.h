//
//  JHOnlineAppraiseTopicView.h
//  TTjianbao
//
//  Created by lihui on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///在线鉴定首页 - 中间显示话题（鉴定师）列表部分

#import <UIKit/UIKit.h>

@class JHOnlineAppraiseModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHOnlineAppraiseTopicView : UIView
///话题列表信息
@property (nonatomic, copy) NSArray <JHOnlineAppraiseModel *>*topicInfo;

@end

NS_ASSUME_NONNULL_END
