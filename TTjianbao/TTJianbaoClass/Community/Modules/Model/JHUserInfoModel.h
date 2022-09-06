//
//  JHUserInfoModel.h
//  TaodangpuAuction
//
//  Created by lihui on 2020/6/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoModel : NSObject

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

//@property (nonatomic, strong) MyShareModel  *share_info;
@property (nonatomic, assign) BOOL isSpecialSale;  ///是否为特卖商家
@property (nonatomic, strong) NSNumber *sellerId;  ///商家ID


@end

NS_ASSUME_NONNULL_END
