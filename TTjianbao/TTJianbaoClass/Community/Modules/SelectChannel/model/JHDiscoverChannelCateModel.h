//
//  JHDiscoverChannelCateModel.h
//  TTjianbao
//
//  Created by jingxin on 2019/5/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSQModel.h"
@class CTopicSaleInfo;

@interface MyShareModel: NSObject
@property(nonatomic, strong) NSString *title;// 标题
@property(nonatomic, strong) NSString *desc;// 描述
@property(nonatomic, strong) NSString *img;// 图片
@property(nonatomic, strong) NSString *url;// 分享地址
@end


@interface Publisher :NSObject
@property (nonatomic, assign) NSInteger     user_id;//宝友id
@property (nonatomic,   copy) NSString      *uniq_id; //商品唯一标识 -- v2.2.4新增
@property (nonatomic,   copy) NSString      *wy_accid; //网易用户ID
@property (nonatomic,   copy) NSString      *code;// 宝友号
@property (nonatomic,   copy) NSString      *title;//认证商家
@property (nonatomic,   copy) NSString      *user_name; // 名称
@property (nonatomic,   copy) NSString      *avatar;// 头像
@property (nonatomic,   copy) NSString      *introduction;// 个人介绍（主页个性签名）
@property (nonatomic,   copy) NSString      *desc;// 描述（如：2.2万粉丝，102件宝贝）

@property (nonatomic,   copy) NSString      *follow_num; // 关注数（此用户关注别人的数量）
@property (nonatomic, assign) NSInteger     fans_num_int;//粉丝数
@property (nonatomic,   copy) NSString      *fans_num; // 粉丝数（此用户被人关注的数量）
@property (nonatomic,   copy) NSString      *like_num;// 被点赞数

@property (nonatomic, assign) NSInteger     is_follow; // 是否已关注，1-yes
@property (nonatomic, assign) NSInteger     is_certification;// 是否为认证商户，1-yes

@property (nonatomic,   copy) NSString      *channel_name; //直播间名称
@property (nonatomic,   copy) NSString      *consume_tag_icon; //大客户标识icon
@property (nonatomic,   copy) NSString      *create_business_time; //社区商户创建时间

//0普通用户，1鉴定主播，2卖货主播，3助理，4社区商户，5马甲号，6既是社区主播又是卖货主播，7回血主播，8回血助理
@property (nonatomic, assign) NSInteger     role;
@property (nonatomic, assign) NSInteger     shop_id; // 店铺ID

@property (nonatomic,   copy) NSString      *experience_num; //当前总经验值
@property (nonatomic, assign) BOOL          is_experience_new; //（当日）是否有新增经验
@property (nonatomic,   copy) NSString      *title_level_icon; //称号等级图标
@property (nonatomic,   copy) NSString      *game_level; //小游戏等级 - 整型数
@property (nonatomic,   copy) NSString      *game_level_icon; //小游戏等级图标 - 勋章
@property (nonatomic,   copy) NSString      *room_id; //直播间ID，大于0表示直播中
@property (nonatomic,   copy) NSString      *role_icon; //鉴定师图标

@property (nonatomic, assign) NSInteger hasBigCustomer; //是否是大客户
@property (nonatomic,   copy) NSString *userTycoonLevelIcon; //大客户标识icon

@property (nonatomic, assign) NSInteger     publish_treasure_num;//发布的宝贝数量
@property (nonatomic, assign) NSInteger     like_treasure_num;//喜欢的宝贝数量

@property (nonatomic, assign) NSInteger     is_ban; //是否违规

@property (nonatomic, strong) JHShareInfo *share_info;
@property (nonatomic, assign) BOOL isSpecialSale;  ///是否为特卖商家
@property (nonatomic, strong) NSNumber *sellerId;  ///商家ID

@end



@interface JHDiscoverChannelCateModel :NSObject
@property (nonatomic, strong) NSString *item_uniq_id;//全局商品唯一标识
@property (nonatomic, strong) NSString *uniq_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, assign) JHSQItemType item_type; //item_id和item_type一起标识商品唯一性
@property (nonatomic, assign) JHSQLayoutType layout;
@property (nonatomic, strong) NSDictionary *target;//当item_type为JHComItemTypeAD时，广告的落地信息
@property (nonatomic,   copy) NSString *cate_id;//鉴定视频的分类ID
@property (nonatomic, assign) NSInteger is_need_appraise; //是否是鉴定贴

@property (nonatomic , strong) NSString     *title;// 商品标题
@property (nonatomic , strong) NSString     *content;// 描述信息 ** 2.1.0新增
@property (nonatomic , assign) NSInteger    title_row;// 标题显示行数
@property (nonatomic , strong) NSString     *image;// 列表中的展示图，可能是图片 可能是动图
@property (nonatomic ,   copy) NSString     *static_image;//静态图，image是动图时使用
@property (nonatomic , assign) CGFloat      wh_scale; // 图片宽高比
@property (nonatomic , assign) CGFloat      wh_scale_static;
@property (nonatomic , assign) NSInteger    is_like;// 是否已点赞，1-yes 0 -no
@property (nonatomic , strong) NSString     *like_num;//用于显示的点赞数量
@property (nonatomic, assign) NSInteger     like_num_int;//点赞数目
@property (nonatomic, strong) NSString      *sale_tag;//可售标签 0已售 1可售
@property (nonatomic, assign) NSInteger     is_can_buy; //商品当前是否可售
@property (nonatomic, strong) NSArray<NSString *> *flag_images;//标签图片地址
@property (nonatomic, strong) Publisher    *publisher;// 发布人

@property (nonatomic, assign) NSInteger status; //文章状态， 1-可见，2-违规，3-沉帖
/*拉流url:时长5s
 *1,正在直播:有此字段
 *2,其他情况:无此字段
 */
@property (nonatomic, strong) NSString *rtmp_pull_url;

@property (nonatomic,   copy) NSString *price; //原价
@property (nonatomic, strong) CTopicSaleInfo *saleInfo; // ** 新增特卖信息（对应字段：especially_buy_info）

//计算之后的JHDiscoverHomeFlowCollectionCell高度
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat titleHeight;

#pragma mark - 3.1.6新增 - 临时适配
@property (nonatomic,   copy) NSString *publish_time; //发布时间
@property (nonatomic,   copy) NSString *video; //视频地址
@property (nonatomic, assign) NSInteger is_self; //？？？
@property (nonatomic, assign) NSInteger appraise_result; //鉴定结果
@property (nonatomic, assign) NSInteger source; //来源：1贴吧、2微拍堂、3朋友圈、4快手、5鉴定视频、6UGC内容
@property (nonatomic, assign) NSInteger comment_num_int; // 总评论数
//@property (nonatomic, strong) JHSQResourceInfo *resource_cover; //图片信息
//@property (nonatomic, strong) JHShareInfo  *share_info; //分享信息
//@property (nonatomic, strong) NSMutableArray<NSString *> *images; //图片集合（滑动）
//@property (nonatomic, strong) NSMutableArray<JHSQLabelsInfo *> *labels;//标签
//@property (nonatomic, strong) NSMutableArray<JHSQCommentsInfo *> *comments; //评论列表

///3.1.8新增  显示标签文字
@property (nonatomic, copy) NSString *content_tag;


@end
