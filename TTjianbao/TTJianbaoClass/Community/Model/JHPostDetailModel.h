//
//  JHPostDetailModel.h
//  TTjianbao
//
//  Created by lihui on 2020/8/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSQModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHPostAnchorInfo;
@class JHCommentModel;
@class JHTallyInfo;
@class JHPublisher;
@class JHShareInfo;
@class JHShopInfo;
@class JHPlateInfo;
@class JHPostDetailResourceModel;
@class JHTopicInfo;

@interface JHPostDetailModel : NSObject

///内容属性，1-UDC文章，2-商品
@property (nonatomic, assign) JHPostItemType item_type;
///帖子唯一标识
@property (nonatomic,   copy) NSString *item_id;
///商品唯一标识，与item_id作用一样，值不同
@property (nonatomic,   copy) NSString *uniq_id;
@property (nonatomic,   copy) NSString *item_uniq_id;
///item_type= 1信息 2商品 3评论 4回复 5用户 6广告  7话题  8投票贴 10 猜价帖
///商品对应的文章展示类型，1-图文，2-视频
@property (nonatomic, assign) NSInteger layout;
///帖子标题
@property (nonatomic,   copy) NSString *title;
///商品描述
@property (nonatomic, copy) NSString *content;
///商品缩略图列表
@property (nonatomic, strong) NSArray <NSString *>*images_thumb;
///商品中间的缩略图列表
@property (nonatomic, strong) NSArray <NSString *>*images_medium;
///商品大图列表
@property (nonatomic, strong) NSArray <NSString *>*images;
///标题显示行数
@property (nonatomic, assign) NSInteger title_raw;
///数据来源
@property (nonatomic,   copy) NSString *source;
@property (nonatomic, assign) BOOL is_collect; //是否已收藏
@property (nonatomic, assign) BOOL is_self; //是否是自己发布的帖子
@property (nonatomic, assign) NSInteger content_level; //1精华帖 0普通帖
@property (nonatomic, assign) NSInteger content_style; //0无 2置顶 3公告
@property (nonatomic, strong) JHPlateInfo *plate_info; //版块信息
@property (nonatomic, strong) JHShareInfo *share_info; //分享信息
///是否已点赞，1-yes
@property (nonatomic, assign) NSInteger is_like;
///点赞数量（如1.3W，用于显示）
@property (nonatomic,   copy) NSString *like_num;
///点赞数量Int类型
@property (nonatomic, assign) NSInteger like_num_int;
///总评论数
@property (nonatomic, assign) NSInteger comment_num;
///剩余评论数
@property (nonatomic, assign) NSInteger remaining_comment_count;
///是否是鉴定贴
@property (nonatomic, assign) NSInteger is_need_appraise;

///商品分享次数(显示类型）
@property (nonatomic,   copy) NSString *share_count;
@property (nonatomic, assign) NSInteger share_num; //分享数
///自定义属性 目的是为了将分享数超过1w的转换方式显示
@property (nonatomic, copy) NSString *shareString;

///商品分享次数（数值类型）
@property (nonatomic, assign) NSInteger share_count_int;
///商品发布时间
@property (nonatomic, copy) NSString *publish_time;
///视频url
@property (nonatomic,   copy) NSString *video_url;
///视频预览图
@property (nonatomic,   copy) NSString *video_preview_image;

///文章封面
@property (nonatomic,   copy) NSString *preview_image;
///图片宽高比
@property (nonatomic, assign) CGFloat wh_scale;
///是否是违规贴
@property (nonatomic, assign) NSInteger is_ban;
///发布人
@property (nonatomic, strong) JHPublisher *publisher;
///直播间信息
@property (nonatomic, strong) JHPostAnchorInfo *archorInfo;
///店铺信息
@property (nonatomic, strong) JHShopInfo *shopInfo;
@property (nonatomic, strong) JHVideoInfo *videoInfo;
///分享的模型属性
@property (nonatomic, strong) JHShareInfo *shareInfo;

///标签
@property (nonatomic, strong) NSMutableArray<JHTallyInfo *> *labels;
///标签
@property (nonatomic, strong) NSMutableArray<JHTopicInfo *> *topics;
///评论列表
@property (nonatomic, strong) NSArray<JHCommentModel *>*comments;
@property (nonatomic, strong) JHPlateInfo *plateInfo;

///长文章描述信息相关
@property (nonatomic, strong) NSArray <JHPostDetailResourceModel *>*resourceData;

///自定义变量 用于布局小视频全屏时
//帖子内容 <自定义属性：content对应的attributedString>
@property (nonatomic, strong) NSMutableAttributedString *contentAttrText;
///内容高度
@property (nonatomic, assign) CGFloat contentHeight;
///默认为no
@property (nonatomic, assign) BOOL showAll;
///时间宽度
@property (nonatomic, assign) CGFloat timeWidth;
///文章状态
@property (nonatomic, assign) JHPostDataShowStatus show_status;
@property (nonatomic, strong) NSArray *resource_data; //帖子内容content 数组模式
@property (nonatomic, strong) NSMutableAttributedString *postContentAttrText; //长文章帖子内容 数组模式

///编辑修改时间（3.6.5）
@property (nonatomic, copy) NSString *update_time;

///是否是编辑审核中
@property (nonatomic, assign) BOOL is_edit_check;
///是否是运营后台发
@property (nonatomic, assign) BOOL is_back;

///分页时间
@property (nonatomic, copy) NSString *last_date;

///372新增 主要目的是记录该数据在列表中的位置 --- TODO lihui
@property (nonatomic, assign) NSInteger listIndex;

@end

typedef NS_ENUM(NSInteger, JHPostDetailResourceType) {
    ///文字
    JHPostDetailResourceTypeText = 1,
    ///图片
    JHPostDetailResourceTypeImage = 2,
    ///视频
    JHPostDetailResourceTypeVideo = 3,
};

@interface JHPostDetailResourceSubModel : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *attrs;

@property (nonatomic, copy) NSArray *attrArray;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *video_cover_url;

@property (nonatomic, copy) NSString *video_url;

@end

@interface JHPostDetailResourceModel : NSObject
///资源类型
@property (nonatomic, assign) JHPostDetailResourceType type;
@property (nonatomic, copy) NSDictionary *data;

@property (nonatomic, strong) JHPostDetailResourceSubModel *dataModel;

@end

@interface JHPostAnchorInfo : NSObject

@property (nonatomic, copy) NSString *room_id;      ///房间号
@property (nonatomic, copy) NSString *live_name;    ///直播间名称
@property (nonatomic, copy) NSString *head_img;     ///头像
///0：禁用 1：空闲 2：直播中 3：直播录制
@property (nonatomic, assign) NSInteger status;///直播间状态
@property (nonatomic, assign) NSInteger watching_num;  ///观看人数

@end

@interface JHTallyInfo :NSObject
///标签id
@property (nonatomic, assign) NSInteger labelId;
///0-默认标签，1-热搜，2话题，3店铺信息，4主播信息
@property (nonatomic, assign) NSInteger type;
///标签文本
@property (nonatomic,   copy) NSString *name;
///type=4时用来判断直播状态，（0休息中，1直播中）
@property (nonatomic, assign) NSInteger status;
@end

@interface JHShopInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *seller_id;
@property (nonatomic, copy) NSString *publish_num;

@end


NS_ASSUME_NONNULL_END
