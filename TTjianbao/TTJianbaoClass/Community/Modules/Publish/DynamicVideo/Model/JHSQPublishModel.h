//
//  JHSQPublishModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPublishCoverModel : NSObject

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSString *url;

@end
/// 服务器数据模型
@interface JHSQPublishModel : NSObject

/// 图片URL数组
@property (nonatomic, copy) NSArray *images;

/// 视频
@property (nonatomic, copy) NSString *video_url;

/// 封面
@property (nonatomic, strong) JHSQPublishCoverModel *cover_info;

/// 标题
@property (nonatomic, copy) NSString *title;

/// 文字
@property (nonatomic, copy, nullable) NSString *content;

//纯文字内容(长文章用)
@property (nonatomic, copy) NSString *desc;
//长文章数据内容
@property (nonatomic, copy) NSArray *resource_data;
/// 话题数组
@property (nonatomic, strong) NSMutableArray *topic;

/// 版块
@property (nonatomic, copy, nullable) NSString *channel_id;
@property (nonatomic, copy, nullable) NSString *channel_name;

///资源类型：1 图片 2 视频  3：图片和视频都有（长帖子）
//@property (nonatomic, assign) NSInteger resource_type;

///  20   动态   ;   30   帖子   ;  40   视频
@property (nonatomic, assign) NSInteger item_type;

/// 毫秒
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, copy) NSString *item_id;

@end

NS_ASSUME_NONNULL_END
