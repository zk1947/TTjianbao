//
//  JHUserInfoModel.h
//  TTjianbao
//
//  Created by lihui on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "YDBaseModel.h"
#import "JHSQModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHUserMedalInfo;
@class JHStoreSellerInfo;
@class JHShareInfo;
@class JHPostData;

@interface JHUserInfoPostModel : YDBaseModel

@property (nonatomic, strong) NSMutableArray <JHPostData *> *list;
//获取推荐列表接口
- (NSString *)toUserPostUrl:(NSInteger)type userId:(NSString *)userId;
- (void)configModel:(JHSQModel *)model;

@end

@interface JHUserInfoModel : NSObject
///头像
@property (nonatomic, copy) NSString *avatar;
///宝友号
@property (nonatomic, copy) NSString *code;
//当前总经验值
@property (nonatomic, copy) NSString *experience_num;
///（当日）是否有新增经验
@property (nonatomic, assign) BOOL is_experience_new;
///粉丝数
@property (nonatomic, assign) NSInteger fans_num_int;
///粉丝数（此用户被人关注的数量）
@property (nonatomic, copy) NSString *fans_num;
///关注数（此用户关注别人的数量）
@property (nonatomic, copy) NSString *follow_num;
///个人介绍（主页个性签名）
@property (nonatomic, copy) NSString *introduction;
///是否为认证商户，1-yes
@property (nonatomic, assign) NSInteger is_certification;
///是否已关注，1-yes
@property (nonatomic, assign) NSInteger is_follow;
///是否为特卖商家
@property (nonatomic, assign) BOOL isSpecialSale;
///被点赞数
@property (nonatomic, copy) NSString *like_num;
///喜欢的宝贝数量
@property (nonatomic, assign) NSInteger like_treasure_num;
///发布的宝贝数量
@property (nonatomic, assign) NSInteger publish_treasure_num;
//直播间ID，大于0表示直播中
@property (nonatomic, copy) NSString *room_id;
///商家ID
@property (nonatomic, copy) NSString *sellerId;
///店铺ID
@property (nonatomic, assign) NSInteger shop_id;
///认证商家
@property (nonatomic, copy) NSString *title;
///宝友id
@property (nonatomic, copy) NSString *user_id;
///名称
@property (nonatomic, copy) NSString *user_name;
///勋章信息
@property (nonatomic, strong) JHUserMedalInfo *levelInfo;
///0  普通用户 1  鉴定主播 | 2  卖货主播 | 3  助理 | 4  社区商户
///5  马甲号 |  6  既是社区主播又是卖货主播 | 7  回血主播 | 8  回血助理
@property (nonatomic, assign) NSInteger role;
///是否直播中
@property (nonatomic, assign) BOOL is_live;
///店铺信息
@property (nonatomic, strong) JHStoreSellerInfo *storeInfo;
///分享信息
@property (nonatomic, strong) JHShareInfo *shareInfo;

@end

///勋章信息
@interface JHUserMedalInfo : NSObject

//大客户标识icon
@property (nonatomic, copy) NSString *consume_tag_icon;
//小游戏等级图标 - 勋章 武林盟主等
@property (nonatomic, copy) NSString *game_level_icon;
///版主图标
@property (nonatomic, copy) NSString *plate_icon;
//鉴定师图标 商家
@property (nonatomic, copy) NSString *role_icon;
//称号等级图标 宝友
@property (nonatomic, copy) NSString *title_level_icon;
///商家认证标识
@property (nonatomic, copy) NSString *cert_icon;


@end


@interface JHStoreSellerInfo : NSObject
///头像
@property (nonatomic, copy) NSString *head_img;
///商铺名称
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *publish_num;
@property (nonatomic, assign) NSInteger seller_id;

@end


NS_ASSUME_NONNULL_END
