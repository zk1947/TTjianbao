//
//  JHMessageHeader.h
//  TTjianbao
//
//  Created by Jesse on 2020/3/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHMessageHeader_h
#define JHMessageHeader_h

//消息中心请求前缀,服务端变化太频繁了
#define kMessageCenterReqPathPrefix     @"/mc/app/mc/auth/msg/"
/*
* 分类->类型type (string, optional)
* express:订单物流,
* announce_activity:活动公告=>优惠活动
* announce_common:平台公告,
* forum:社区互动,
* settle:店铺结算,
* promote:促销优惠,
* stone:原石回血
* >>>>>kefu:客服不在此类(现在融合到一起),本地调用第三方
*/
#define kMsgSublistTypeExpress  @"express"   //订单物流
#define kMsgSublistTypeActivity @"announce_activity"   //活动公告=>优惠活动
#define kMsgSublistTypeCommon   @"announce_common"   //平台公告
#define kMsgSublistTypeForum    @"forum"   //社区互动(??互动消息)
#define kMsgSublistTypeSettle   @"settle"   //店铺结算
#define kMsgSublistTypePromote  @"promote"   //促销优惠
#define kMsgSublistTypeStone    @"stone"   //原石回血
#define kMsgSublistTypeOrderRemind    @"order_remind"   //订单提醒
#define kMsgSublistTypePlatformNotify   @"system_notice"   //系统消息
#define kMsgSublistTypeKefu    @"jh_kefu"   //客服
#define kMsgSublistTypeChat    @"jh_chat"   //商家用户chat
#define kMsgSublistTypeAppraiseReply   @"appraise_reply"   //鉴定回复
#define kMsgSublistTypeComment   @"comment"   //评论
#define kMsgSublistTypeLike   @"like"   //点赞

#define kMsgSublistTypeGreet  @"at" //@我的
#define kMsgSublistTypeCommunityNew  @"community_official" //社区官方消息 hutao--add
#define kMsgSublistTypeIM  @"imSession" //1v1 IM
/*分类->子类:
 *相当于三级分类thirdType,暂时忽略二级分类secondType
 */
/*原石回血：thirdType=*/
#define kMsgSublistStoneTypeSub    @"stone1"   //原石回血subcell
#define kMsgSublistStoneTypeAccountIn    @"stoneAccountIn"   //原石回血-stoneAccountIn 入账,
#define kMsgSublistStoneTypeWaitPublish    @"stoneWaitPublish"   //原石回血-待上架
/*促销优惠：thirdType=*/
#define kMsgSublistSpendCouponTypeWillExpire    @"couponWillExpire"   //促销优惠-红包即将过期
#define kMsgSublistSpendCouponTypeGet    @"couponGet"   //促销优惠-红包获得
#define kMsgSublistSpendCouponTypeSellerWillExpire    @"sellerCouponWillExpire"   //促销优惠-代金券即将过期
#define kMsgSublistSpendCouponTypeSellerGet    @"sellerCouponGet"   //促销优惠-代金券获得
#define kMsgSublistSpendCouponTypeBountyWillExpire    @"bountyWillExpire"   //促销优惠- 津贴即将过期
#define kMsgSublistSpendCouponTypeBountyGet    @"bountyGet"   //促销优惠- 津贴获得
/*社区互动：thirdType=forumPost 社区帖子,forumFollow 有人关注*/
#define kMsgSublistForumTypeFollow   @"forumFollow"   //关注样式
#define kMsgSublistForumTypePost   @"forumPost"   //社区帖子

/*社区互动->关注状态*/
#define kMsgSublistForumFollowYes     @"1" //关注
#define kMsgSublistForumFollowNo      @"0" //取消关注

/**消息中心showType->关联
 * 1<显示 2<接收数据model
 * 即使「显示类型」与「数据model」是一一对应的
 **/
#define kMsgSublistShowTypeCommon @"common_icon" //左侧小图片+右上标题+右下描述
#define kMsgSublistShowTypeCommonNotice @"common_icon_notitle" //左侧小图片+右描述
#define kMsgSublistShowTypeActivitySlogan @"common_slogan" //优惠活动&平台公告:顶部标题+中部描述+底部大图
#define kMsgSublistShowTypeOrderTransport @"orderStatusChange" //订单物流
#define kMsgSublistShowTypeForumFollow @"forumFollow" //宝友关注

//消息分类sublist事件处理类型
typedef NS_ENUM(NSUInteger, JHMsgSubEventsType)
{
    //reload list
    JHMsgSubEventsTypeReload,
    //cell event
    JHMsgSubEventsTypeForumCare,
    JHMsgSubEventsTypeHeadImage,
    JHMsgSubEventsTypeOpenWeb,
    JHMsgSubEventsTypeOpenPage,
    JHMsgSubEventsTypeGrowing,
    //cell 评论
    JHMsgSubEventsTypeCommentEnterArticle,
    JHMsgSubEventsTypeCommentDelete,
    JHMsgSubEventsTypeCommentComment,
    JHMsgSubEventsTypeCommentLike,
    JHMsgSubEventsTypePersonPage,
};

#endif /* JHMessageHeader_h */
