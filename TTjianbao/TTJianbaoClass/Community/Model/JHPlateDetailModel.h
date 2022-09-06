//
//  JHPlateDetailModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  板块详情数据
//

#import "YDBaseModel.h"
#import "JHSQModel.h"
#import "JHTopicDetailModel.h"
#import "JHTopicDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateDetailModel : NSObject

///版块id<id>
@property (nonatomic, copy) NSString *ID;

///版块名称
@property (nonatomic, copy) NSString *name;

///版块小图
@property (nonatomic, copy) NSString *image;

///版块详情头部大图
@property (nonatomic, copy) NSString *bg_image;

///版块描述
@property (nonatomic, copy) NSString *desc;

///浏览量
@property (nonatomic, copy) NSString *scan_num;

///评论数
@property (nonatomic, copy) NSString *comment_num;

///分享数
@property (nonatomic, copy) NSString *share_num;

///帖子总数
@property (nonatomic, copy) NSString *content_num;

///是否已关注
@property (nonatomic, assign) BOOL is_follow;

///版主信息 同发布者（3.3.0一个版主）
@property (nonatomic, strong) JHPublisher *owner;

///版主信息集合 同发布者（3.4.0支持多个版主）
@property (nonatomic, copy) NSArray <JHPublisher *> *owners;

///公告/置顶列表
@property (nonatomic, copy) NSArray <JHPostData *> *sign_list;

///话题列表
@property (nonatomic, copy) NSArray <JHTopicInfo *> *topic_list;

///分类标签列表
@property (nonatomic, copy) NSArray <JHTopicDetailCateModel *> *cate_tabs;

@property (nonatomic, strong) JHShareInfo *share_info;

@end

NS_ASSUME_NONNULL_END
