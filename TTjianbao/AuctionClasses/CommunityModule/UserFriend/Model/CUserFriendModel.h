//
//  CUserFriendModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseModel.h"
@class CUserFriendData;

NS_ASSUME_NONNULL_BEGIN

@interface CUserFriendModel : YDBaseModel

//自定义请求参数
@property (nonatomic, assign) NSInteger pageIndex; //选项卡参数，1-关注、2-粉丝
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger uniq_id; //最后一条数据的uniq_id，用于翻页

@property (nonatomic, strong) NSMutableArray<CUserFriendData *> *list;

- (NSString *)toParams;
- (void)configModel:(CUserFriendModel *)model;

@end


@interface CUserFriendData : NSObject
@property (nonatomic, assign) NSInteger user_id; //用户id
@property (nonatomic,   copy) NSString *user_name; //用户名
@property (nonatomic,   copy) NSString *avatar; //用户头像 url
@property (nonatomic, assign) BOOL is_follow; //是否已关注
@property (nonatomic, assign) NSInteger uniq_id; //用于翻页
@property (nonatomic, assign) BOOL is_certification; // 是否为认证商户，1-yes
@property (nonatomic, assign) NSInteger role; //0普通用户，1鉴定主播（鉴定师），2直播卖货主播，3:助理 4:社区卖货主 5:马甲号
@property (nonatomic,   copy) NSString *title; //认证商家
@property (nonatomic,   copy) NSString *role_icon; //认证鉴定师
@property (nonatomic,   assign) int hasBigCustomer; //是否是大客户
@property (nonatomic,   copy) NSString *userTycoonLevelIcon; //称号等级
@property (nonatomic,   copy) NSString *title_level_icon; //称号等级
@property (nonatomic,   copy) NSString *game_level_icon; //称号等级
@property (nonatomic, assign) NSInteger is_ban; //是否违规 0正常 1违规 2沉帖

@end

NS_ASSUME_NONNULL_END
