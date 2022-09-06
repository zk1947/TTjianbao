//
//  JHTrackingAudienceLiveRoomModel.h
//  TTjianbao
//
//  Created by apple on 2021/1/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTrackingBaseModel.h"
#import "ChannelMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHTrackingAudienceLiveRoomModel : JHTrackingBaseModel
@property (nonatomic, copy) NSNumber *watch_duration;    //观看时长
@property (nonatomic, copy) NSString *source_page;  //    来源页面
@property (nonatomic, copy) NSString *source_module;   // 来源模块
@property (nonatomic, copy) NSString *channel_id;    //直播间id
@property (nonatomic, copy) NSString *channel_name;    //直播间名称
@property (nonatomic, copy) NSString *anchor_id;    //主播ID
@property (nonatomic, copy) NSString *anchor_nick_name;    //主播名称
@property (nonatomic, copy) NSString *anchor_role;    //主播角色
@property (nonatomic, copy) NSString *channel_local_id;    //频道id
@property (nonatomic, copy) NSArray *first_channel;    //直播间一级分类
@property (nonatomic, copy) NSArray *second_channel;    //直播间二级分类
@property (nonatomic, copy) NSString *first_commodity;    //商品一级分类
@property (nonatomic, copy) NSString *second_commodity;    //商品二级分类
@property (nonatomic, copy) NSString *third_commodity;    //商品三级分类
@property (nonatomic, assign) BOOL is_follow_anchor;    //是否关注主播
@property (nonatomic, copy) NSString *connection_type;  //连线类型:定制 鉴定
@property (nonatomic, copy) NSArray *anchor_range;  //鉴定范围
@property (nonatomic, copy) NSString *operation_type;  ///操作类型 微信分享  朋友圈分享等
@property (nonatomic, copy) NSString *comment_content;   ///发言内容
@property (nonatomic, copy) NSString *page_position;   ///所在页面
@property (nonatomic, strong) NSDecimalNumber *allowance;       ///津贴金额
@property (nonatomic, copy) NSString *red_envelope_id;   ///红包id
@property (nonatomic, copy) NSString *red_envelope_name;  ///红包名称


-(void)transitionWithModel:(ChannelMode *)model needFollowStatus:(BOOL)isNeed;
@end

NS_ASSUME_NONNULL_END
