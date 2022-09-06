//
//  JHStatisticAnalysisId.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -------- 社区发布 beign --------

///点击社区发帖入口
extern NSString *const JHStatisticSQPublishEnter;

///点击社区发帖入口_写文章
extern NSString *const JHStatisticSQPublishArticleEnter;

///点击社区发帖入口_动态
extern NSString *const JHStatisticSQPublishDynamicEnter;

///点击社区发帖入口_小视频
extern NSString *const JHStatisticSQPublishVideoEnter;

///点击导航+发帖入口_连线鉴定
extern NSString *const JHStatisticSQPublishConnectionEnter;

///点击导航+发帖入口_写文章
extern NSString *const JHStatisticSQPublishNavArticleEnter;

///点击导航+发帖入口_动态
extern NSString *const JHStatisticSQPublishNavDynamicEnter;

///点击导航+发帖入口_小视频
extern NSString *const JHStatisticSQPublishNavVideoEnter;

///选择/取消选择原图 (1,0)
extern NSString *const JHSQPublishSelectImageOriginal;

/// 按钮方式添加图片/视频
extern NSString *const JHSQPublishAddSourcesButtonClick;

/// 描述中+方式添加图片/视频
extern NSString *const JHSQPublishAddSourcesDescClick;

/// 删除插入的图片/视频
extern NSString *const JHSQPublishDeleteSourcesClick;

/// 编辑器内排序
extern NSString *const JHSQPublishEditSortClick;

/// 批量排序
extern NSString *const JHSQPublishEditAllSortClick;

/// 选择话题
extern NSString *const JHSQPublishSeleteTopicClick;

/// 选择话题中搜索话题
extern NSString *const JHSQPublishSeleteTopicSearchClick;

#pragma mark -------- 社区发布 end --------

@interface JHStatisticAnalysisId : NSObject

@end

NS_ASSUME_NONNULL_END
