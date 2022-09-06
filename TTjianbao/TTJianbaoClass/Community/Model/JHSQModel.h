//
//  JHSQModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  社区业务数据模型
//

#import "YDBaseModel.h"
#import "CTopicModel.h"

@class JHPostData;      //帖子数据
@class JHPlateInfo;     //版块信息
@class JHOwnerInfo;     //版主信息
@class JHVideoInfo;     //短视频信息
@class JHCommentData;   //评论数据
@class JHPublisher;     //发布者信息
@class JHTopicInfo;     //话题信息
@class JHShareInfo;     //分享信息
@class JHLevelInfo;     //用户等级信息（任务等级、游戏等级、角色、版主、土豪等，目前只有图标信息）
@class JHSQUploadModel; //本地上传

NS_ASSUME_NONNULL_BEGIN

@interface JHSQModel : YDBaseModel

//数组总数
@property (nonatomic, assign) NSInteger total_num;

@property (nonatomic, strong) NSMutableArray <JHPostData *> *list;
///自定义视频url
@property (nonatomic, strong) NSMutableArray <NSURL *> *videoUrls;

- (NSString *)toPostListUrl; //获取推荐列表接口

- (NSString *)toCollectPostListUrl; //获取收藏列表接口

- (void)configModel:(JHSQModel *)model;
- (void)configModel:(JHSQModel *)model QueryWord:(NSString *)queryword;
- (void)configModel:(JHSQModel *)model hideComment:(BOOL)hideComment;

@end


typedef NS_ENUM(NSInteger, JHPostDataShowStatus) {
    JHPostDataShowStatusChecking = 0,
    JHPostDataShowStatusNormal = 10,
    JHPostDataShowStatusDelete = 20,
};

#pragma mark - 社区贴子数据 <完>
@interface JHPostData : NSObject

/// 编辑审核中  0-默认  1-表示编辑审核中状态（版主或者本人编辑提交后变为1）（3.6.5）
@property (nonatomic, assign) BOOL is_edit_check;

///是否是运营后台发
@property (nonatomic, assign) BOOL is_back;

/// 是否是版主 （3.6.5）
@property (nonatomic, assign) BOOL isPlateOwner;
/// 0-默认
/// 2-关注的人(取帖子信息中publisher 中的信息)
/// 3-关注的板块(取帖子信息中plate_info中的信息)
@property (nonatomic, assign) NSInteger recommend_type;
@property (nonatomic, assign) JHPostItemType item_type; //帖子类型
@property (nonatomic,   copy) NSString *uniq_id; //收藏列表last_id标识
@property (nonatomic,   copy) NSString *item_id; //帖子id
@property (nonatomic,   copy) NSString *cate_id; //分类id，版块主页的分类id，首页用不到
@property (nonatomic,   copy) NSString *origin_id; //鉴定视频使用的id 在线鉴定页面用的，社区用不到 留着
@property (nonatomic, assign) NSInteger video_appraise_result;  ///1：鉴定为真  0： 鉴定为假 2:无法鉴定
@property (nonatomic, assign) NSInteger source; //来源：1贴吧、2微拍堂、3朋友圈、4快手、5鉴定视频、6UGC内容
@property (nonatomic,   copy) NSString *publish_time; //发布时间
@property (nonatomic,   copy) NSString *title; //帖子标题
@property (nonatomic,   copy) NSString *content; //帖子内容
@property (nonatomic, assign) CGFloat contentHeight; //帖子内容高度 <自定义属性>
@property (nonatomic, strong) NSMutableAttributedString *contentAttrText; //帖子内容 <自定义属性：content对应的attributedString>
@property (nonatomic, strong) NSArray *resource_data; //帖子内容content 数组模式
@property (nonatomic, strong) NSMutableAttributedString *postContentAttrText; //长文章帖子内容 数组模式
@property (nonatomic, strong) NSMutableAttributedString *contentAttributedString;
@property (nonatomic, assign) BOOL is_self; //是否是自己发布的帖子
@property (nonatomic, assign) BOOL is_like; //是否已点赞
@property (nonatomic, assign) BOOL is_collect; //是否已收藏
@property (nonatomic, assign) NSInteger content_level; //1精华帖
@property (nonatomic, assign) NSInteger content_style; //0无 2置顶 3公告
@property (nonatomic, assign) NSInteger scan_num; //浏览量
@property (nonatomic, assign) NSInteger like_num; // 点赞数
///自定义属性
@property (nonatomic, copy) NSString *likeString;
@property (nonatomic, assign) NSInteger share_num; //分享数
///自定义属性 目的是为了将分享数超过1w的转换方式显示
@property (nonatomic, copy) NSString *shareString;
@property (nonatomic, assign) NSInteger comment_num; //评论数

@property (nonatomic, strong) JHPublisher *publisher; // 发布者信息
@property (nonatomic, strong) JHPlateInfo *plate_info; //版块信息
@property (nonatomic, strong) JHShareInfo *share_info; //分享信息
@property (nonatomic, strong) JHVideoInfo *video_info; //短视频信息
@property (nonatomic,   copy) NSString *image; //广告、直播间、话题使用的image，其他帖子类型使用images_thumb
@property (nonatomic, strong) NSMutableArray<NSString *> *images_thumb; //帖子、动态图片缩略图
@property (nonatomic, strong) NSMutableArray<NSString *> *images_medium; //帖子、动态图片中图
@property (nonatomic, strong) NSMutableArray<NSString *> *images_origin; //帖子、动态图片原图
@property (nonatomic, strong) NSMutableArray<JHTopicInfo *> *topics; //话题集合
@property (nonatomic, strong) NSMutableArray<JHCommentData *> *hot_comments; //热评数据，应该只有一条
///帖子状态:show_status 0待审核 10正常 20删除
@property (nonatomic, assign) JHPostDataShowStatus show_status;

//---------------------广告数据------------------
@property (nonatomic, strong) TargetModel *target;
//拉流url:时长5s，正在直播:有此字段，其他情况:无此字段
@property (nonatomic,   copy) NSString *rtmp_pull_url;
//----------------------------------------------

/** 自定义：是否隐藏热评和快捷评论栏 */
@property (nonatomic, assign) BOOL hideComment;

///本地帖子 --- 355新增
@property (nonatomic, strong) JHSQUploadModel *localPost;

@property (nonatomic, copy) NSString *last_date;

///360埋点新增字段 搜索词
@property (nonatomic, copy) NSString *queryWord;

///372新增 目的:记录数据在列表中的下标
@property (nonatomic, assign) NSInteger listIndex;

//配置内容<isNormal：是否是长文贴>
- (void)configPostContent:(NSString *)content isNormal:(BOOL)isNormal;
- (void)configPostContentArray:(NSArray *)contentArray isNormal:(BOOL)isNormal;

@end


#pragma mark - 版块数据 <完>
@interface JHPlateInfo : NSObject
@property (nonatomic,   copy) NSString *ID;             //<id>
@property (nonatomic,   copy) NSString *name;           //版块名称
@property (nonatomic,   copy) NSString *image;          //版块图片
@property (nonatomic, assign) NSInteger post_num;       //帖子总数
@property (nonatomic, assign) NSInteger scan_num;       //浏览量
@property (nonatomic, assign) NSInteger comment_num;    //评论数
@property (nonatomic, assign) NSInteger share_num;      //分享数
@property (nonatomic, assign) NSInteger join_num;       //参与人数
@property (nonatomic, strong) JHOwnerInfo *owner;       //版主信息
@property (nonatomic, strong) NSMutableArray *owners;   //版主集合
@end

#pragma mark - 版主信息 <完>
@interface JHOwnerInfo : NSObject
@property (nonatomic, copy) NSString *user_id; //版主id
@property (nonatomic, copy) NSString *user_name; //版主昵称
@end



#pragma mark - 短视频信息 <完>
@interface JHVideoInfo : NSObject
@property (nonatomic, copy) NSString *url; //视频地址
@property (nonatomic, copy) NSString *image; //封面图地址
@property (nonatomic, copy) NSString *duration; //视频总时长
@property (nonatomic, strong) UIImage *coverImage; //<自定义属性：封面图>
@end


#pragma mark - 评论数据 <用的老版本3.3.0以前的数据>
@interface JHCommentData :NSObject
@property (nonatomic,   copy) NSString *comment_id;//本条评论/回复id
@property (nonatomic,   copy) NSString *parent_id; //回复的是哪个评论：0:评论，>0回复
@property (nonatomic,   copy) NSString *content; //评论内容
@property (nonatomic, strong) JHPublisher *publisher; //评论人信息
@property (nonatomic, strong) JHPublisher *mention; //@用户
@property (nonatomic,   copy) NSString  *time; //评论/回复 时间
@property (nonatomic,   copy) NSString  *publisher_tag; //发布者标识（如：作者、鉴定师）
@property (nonatomic, assign) NSInteger is_like; //内容是否被点赞，0-未赞，1-已赞
@property (nonatomic, assign) NSInteger like_num; //点赞数
@property (nonatomic, assign) NSInteger reply_count; //总回复数
@property (nonatomic, assign) NSInteger remaining_reply_count; //剩余回复数
@property (nonatomic, assign) NSInteger is_ban; //是否违规 0正常 1违规 2沉帖
@property (nonatomic, assign) NSInteger sort_num; //？？？
@property (nonatomic, strong) NSMutableArray<JHCommentData *> *reply_list; //回复人列表
@property (nonatomic, strong) NSMutableArray<NSString *> *comment_images; //评论附图
@property (nonatomic, strong) NSMutableArray<NSString *> *comment_images_thumb; //评论附图缩略图
@property (nonatomic, strong) NSMutableArray<NSString *> *comment_images_medium; //评论附图缩略中图
@property (nonatomic, copy) NSString *img_type;

@property (nonatomic, strong) NSArray *content_ad; //评论数组
@property (nonatomic,   copy) NSMutableAttributedString *contentAttributedString; //评论内容,富文本格式
@property (nonatomic, strong) YYTextLayout *textLayout; //评论内容,富文本格式
@end

#pragma mark - 发布者信息 <完>
@interface JHPublisher :NSObject
@property (nonatomic,   copy) NSString  *code;// 宝友id
@property (nonatomic,   copy) NSString  *user_id; //宝友id
@property (nonatomic,   copy) NSString  *room_id; //直播间ID
@property (nonatomic,   copy) NSString  *channel_name; //直播间名称（沿用的老版本字段）
@property (nonatomic,   copy) NSString  *user_name; //用户名
@property (nonatomic,   copy) NSString  *avatar; //头像
@property (nonatomic,   copy) NSString  *desc; //描述（如：2.2万粉丝，102件宝贝）
@property (nonatomic, assign) NSInteger is_ban; //是否违规 0正常 1违规 2沉帖
@property (nonatomic, assign) NSInteger status; //0禁用、1空闲、2直播中、3直播录制
@property (nonatomic, assign) NSInteger fans_num; //粉丝数
@property (nonatomic, assign) NSInteger watching_num; //直播间观看人数
@property (nonatomic, assign) BOOL is_live; //直播状态
@property (nonatomic, assign) BOOL is_follow; //是否已关注
@property (nonatomic, assign) BOOL is_certification; //是否为认证商户
@property (nonatomic, assign) NSInteger role; //用户类型
@property (nonatomic, strong) JHLevelInfo *levelInfo; //用户等级信息 <level_icons> 使用时可以用levelIcons
//自定义：所有等级图标，内部自动设置
@property (nonatomic, strong) NSMutableArray<NSString *> *levelIcons;
///自定义变量 用于布局小视频全屏时
///昵称的宽度
@property (nonatomic, assign) CGFloat nameWidth;

/// 回收版本新增--用于判断主播身份
///已开通的业务线
@property (nonatomic, copy) NSArray <NSString *>*businessLines;
///是否开通直播
@property (nonatomic, assign) BOOL hasOpenLiving;
///是够开通回收
@property (nonatomic, assign) BOOL hasOpenRecyle;
///是否开通优店
@property (nonatomic, assign) BOOL hasOpenExcellent;
//直播类型 0:卖场直播间 1:原石直播间 2:定制师直播间 3:回收直播间
@property (nonatomic, assign) int liveType;
///
/// 是否是 普通用户
@property (nonatomic, assign) BOOL blRole_default;
/// 是否是 鉴定主播
@property (nonatomic, assign) BOOL blRole_appraiseAnchor;
/// 是否是 普通卖场主播
@property (nonatomic, assign) BOOL blRole_saleAnchor;
/// 是否是 普通卖场主播助理
@property (nonatomic, assign) BOOL blRole_saleAnchorAssistant;
/// 是否是 社区商户
@property (nonatomic, assign) BOOL blRole_communityShop;
/// 是否是 马甲
@property (nonatomic, assign) BOOL blRole_maJia;
/// 是否是 社区商户+卖货商户
@property (nonatomic, assign) BOOL blRole_communityAndSaleAnchor;
/// 是否是 回血主播
@property (nonatomic, assign) BOOL blRole_restoreAnchor;
/// 是否是 回血主播助理
@property (nonatomic, assign) BOOL blRole_restoreAssistant;
/// 是否是 定制主播
@property (nonatomic, assign) BOOL blRole_customize;
/// 是否是 定制主播助理
@property (nonatomic, assign) BOOL blRole_customizeAssistant;
/// 是否是 回收主播
@property (nonatomic, assign) BOOL blRole_recycle;
/// 是否是 回收主播助理
@property (nonatomic, assign) BOOL blRole_recycleAssistant;


@end

#pragma mark - 话题信息 <完>
@interface JHTopicInfo : NSObject
@property (nonatomic,   copy) NSString *ID; //<id>
@property (nonatomic,   copy) NSString *name; //话题名称
@property (nonatomic,   copy) NSString *title; //话题名称
@property (nonatomic, assign) NSInteger scan_num; //浏览量
@property (nonatomic, assign) NSInteger content_num; //帖子总数
@property (nonatomic, assign) NSInteger comment_num; //评论数
@property (nonatomic, assign) JHTopicTagType tag_type; //话题标签
@property (nonatomic, copy) NSString *tag_url;  //标签的图片链接


@end

#pragma mark - 用户等级信息（任务等级、游戏等级、角色、版主、土豪等）<完>
@interface JHLevelInfo : NSObject
@property (nonatomic, copy) NSString *role_icon;        //角色标
@property (nonatomic, copy) NSString *title_level_icon; //任务等级标
@property (nonatomic, copy) NSString *game_level_icon;  //游戏标
@property (nonatomic, copy) NSString *plate_icon;       //版主标
@property (nonatomic, copy) NSString *consume_tag_icon; //大客户、土豪标
@end

typedef NS_ENUM(NSInteger, JHCommentType) {
    ///评论
    JHCommentTypeMain = 0,
    ///评论的回复
    JHCommentTypeReplyToComment,
    ///回复的回复
    JHCommentTypeReplyToReply
};

///评论相关的数模型 所有项目的评论数据结构统一用这个！！！ -- TODO lihui
@interface JHCommentModel : NSObject
///本条评论/回复id
@property (nonatomic, copy) NSString *comment_id;
///回复的是哪个评论：0:评论，>0回复
@property (nonatomic, assign) NSInteger parent_id;
///评论内容
@property (nonatomic, copy) NSString *content;
///以前的数据 现在貌似不用了
@property (nonatomic, copy) NSArray *images;
///评论人信息
@property (nonatomic, strong) JHPublisher *publisher;
///@用户
@property (nonatomic, strong) JHPublisher *mention;
///评论/回复时间
@property (nonatomic, copy) NSString *time;
///发布者标识（如：作者、鉴定师）
@property (nonatomic, assign) NSInteger publisher_tag;
///内容是否被点赞，0-未赞，1-已赞
@property (nonatomic, assign) BOOL is_like;
///点赞数
@property (nonatomic, assign) NSInteger like_num;
///总回复数
@property (nonatomic, assign) NSInteger reply_count;
///剩余回复数
@property (nonatomic, assign) NSInteger remaining_reply_count;
///是否违规 0正常 1违规 2沉帖
@property (nonatomic, assign) BOOL is_ban;
@property (nonatomic, assign) BOOL is_check;
///回复人列表
@property (nonatomic, copy) NSArray <JHCommentModel *>*reply_list;
///？？？
@property (nonatomic, assign) NSInteger sort_num;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) JHPostDataShowStatus show_status;
///评论图片
@property (nonatomic, copy) NSArray <NSString *>*comment_images;
@property (nonatomic, copy) NSArray <NSString *>*comment_images_thumb;
@property (nonatomic, copy) NSArray <NSString *>*comment_images_medium;
///图片类型 长图 GIF 普通
@property (nonatomic, copy) NSString *img_type;

///自定义属性
///评论内容
@property (nonatomic, strong) NSMutableAttributedString *replyCommentAttrString; 
@property (nonatomic, strong) NSMutableAttributedString *commentAttrString; //评论内容,富文本格式  , 详情页不展示查图片,用这个展示
@property (nonatomic, strong) NSMutableAttributedString *publisherAttri;
@property (nonatomic, strong) NSMutableAttributedString *mentionAttri;
@property (nonatomic, strong) NSMutableAttributedString *contentAttri;
@property (nonatomic, assign) BOOL isDetailView; //是否在详情页展示,是的话,不加@符号

///是否有评论图片  默认没有
@property (nonatomic, assign) BOOL hasPicture;
///评论内容高度
@property (nonatomic,strong) YYTextLayout *textLayout;
///查看图片的回调block
@property (nonatomic, copy) void(^seePicBlock)(void);
@property (nonatomic,   copy) NSArray *content_ad; //评论数组
///372新增 楼层
@property (nonatomic, assign) NSInteger floor;
///评论类型 0 评论  1 评论的回复  2 回复的回复
@property (nonatomic, assign) JHCommentType comment_level;

@end

NS_ASSUME_NONNULL_END
