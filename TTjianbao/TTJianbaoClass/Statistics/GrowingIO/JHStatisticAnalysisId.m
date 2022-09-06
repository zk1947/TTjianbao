//
//  JHStatisticAnalysisId.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStatisticAnalysisId.h"

#pragma mark -------- 社区发布 beign --------

///点击社区发帖入口
NSString *const JHStatisticSQPublishEnter = @"community_write_enter";

///点击社区发帖入口_写文章
NSString *const JHStatisticSQPublishArticleEnter = @"community_write_article_enter";

///点击社区发帖入口_动态
NSString *const JHStatisticSQPublishDynamicEnter = @"community_write_Twitter_enter";

///点击社区发帖入口_小视频
NSString *const JHStatisticSQPublishVideoEnter = @"community_write_video_enter";

///点击导航+发帖入口_连线鉴定
NSString *const JHStatisticSQPublishConnectionEnter = @"write_Connection";

///点击导航+发帖入口_写文章
NSString *const JHStatisticSQPublishNavArticleEnter = @"write_article_enter";

///点击导航+发帖入口_动态
NSString *const JHStatisticSQPublishNavDynamicEnter = @"write_Twitter_enter";

///点击导航+发帖入口_小视频
NSString *const JHStatisticSQPublishNavVideoEnter = @"write_video_enter";

///选择/取消选择原图 (1,0)
NSString *const JHSQPublishSelectImageOriginal = @"write_selectpic_original_click";

/// 按钮方式添加图片/视频
NSString *const JHSQPublishAddSourcesButtonClick = @"write_addpic_btn_click";

/// 描述中+方式添加图片/视频
NSString *const JHSQPublishAddSourcesDescClick = @"write_addpic_click";

/// 删除插入的图片/视频
NSString *const JHSQPublishDeleteSourcesClick = @"write_delpic_click";

/// 编辑器内排序
NSString *const JHSQPublishEditSortClick = @"write_drag_click";

/// 批量排序
NSString *const JHSQPublishEditAllSortClick = @"write_sort_click";

/// 选择话题
NSString *const JHSQPublishSeleteTopicClick = @"write_selectopic_enter";

/// 选择话题中搜索话题
NSString *const JHSQPublishSeleteTopicSearchClick = @"write_selectopic_serch_click";

#pragma mark -------- 社区发布 end --------

@implementation JHStatisticAnalysisId

@end
