//
//  JHGrowingIO.h
//  TTjianbao
//
//  Created by mac on 2019/7/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Growing.h>
#import "JHSQConstants.h"
#import "JHStatisticAnalysisId.h"

@class ChannelMode;
@class AppraisalDetailMode;

#define JHKeyPagefrom @"pagefrom"
#define JHKeyState @"state"
#define JHKeyMainSatus @"主态"
#define JHKeyCustomerSatus @"客态"
#define JHKeyValue @"value"

//pagefrom=（源头直播间、鉴定直播间、鉴定视频页、互动消息页、其他）；state=（主态、客态）
extern NSString *const JHPageFromSaleRoom;
extern NSString *const JHPageFromAppraiseRoom;
extern NSString *const JHPageFromAppraiseVideo;
extern NSString *const JHPageFromInteraction;
extern NSString *const JHPageFromOther;


//直播间来源

#define JHLiveFrompush @"push"//推送
#define JHLiveFromsellBanner @"sellBanner"//卖场banner
#define JHLiveFromidentifyBanner @"identifyBanner"//鉴定banner
#define JHLiveFrompersonalBanner @"personalBanner"//个人中心banner
#define JHLiveFromHomeStoreBanner @"homeStoreBanner"//商城首页(限时特卖)banner
#define JHLiveFromsplashBanner @"splashBanner"//启动页
#define JHLiveFromh5 @"h5"//
#define JHLiveFromhomeMarket @"homeMarket"//卖场首页
#define JHLiveFromhomeMarketTabSecondLabel @"tab_secend_label"//卖场首页-二级标签
#define JHLiveFromhomeMarketTopRecommend @"top_recommend"//卖场首页-上部推荐
#define JHLiveFromhomeMarketCommonRecommend @"homeMarketRecommend"//卖场首页-普通list(下部)推荐
#define JHLiveFromhomeMarketEverybodyAttention @"everybody_attention"//卖场首页-大家关注
#define JHLiveFromhomeIdentify @"homeIdentify"//鉴定首页
#define JHLiveFromvideoDetail @"videoDetail"////个人中心鉴定历史
#define JHLiveFromvideoDetail2 @"videoDetail2"////在线鉴定视频 在播主播头像
#define JHLiveFromanchorIntroduce @"anchorIntroduce"////主播介绍页
#define JHLiveFromanchorRecommend @"anchorRecommend"////主播推荐
#define JHLiveFromorderDetail @"orderDetail"////订单详情 主播头像
#define JHLiveFromwaitCountDownTipView @"waitCountDownTipView"////连线倒计时
#define JHLiveFrommyVoucher @"myVoucher"////我的代金券去使用
#define JHLiveFromboughtFragment @"boughtFragment"////买家订单列表
#define JHLiveFromroomFinish @"roomFinish"////主播结束页推荐
#define JHLiveFromconfirmOrder @"confirmOrder"////确认订单页
#define JHLiveFromshopOverview @"shopOverview"//我的店铺培训直播间
#define JHLiveFromMessage @"message"//消息
#define JHLiveFromInteractMessage @"interactMessage"//互动消息
#define JHLiveFromaudienceIdentifyRecord @"audienceIdentifyRecord"//用户鉴定记录
#define JHLiveFromanchorIdentifyRecord @"anchorIdentifyRecord"//主播鉴定记录
#define JHLiveFromorderReportDetail @"orderReportDetail"//订单鉴定详情
#define JHLiveFromliveRecordActivity @"liveRecordActivity"//商家直播记录
#define JHLiveFrompublishActivity @"publishActivity"//帖子发布页
#define JHLiveFromChat @"kefuChat"//客服聊天
#define JHLiveFromLiveRoom @"liveRoom"  //直播间
#define JHLiveFromCustomizeHomePage @"CustomizeHomePage"  //直播间

//商城页面来源
#define JHFromStoreHomePage @"saleHomeMarketList" /*!商城首页列表*/
#define JHFromStoreHomePageBanner @"socialMarketSaleBanner" //商城首页广告
#define JHFromStoreShopHomePage @"saleShop" /*!商城店铺页*/
#define JHFromStoreShopWindowPage @"saleSpecialTopic" /*!商城橱窗主页（专题列表）*/
#define JHFromStoreHomeShopWindowList @"saleHomeMarketShowcase" /*!商城首页橱窗列表（今日推荐样式横滑列表）*/
#define JHFromStoreGoodsDetail @"saleCommodityDetail" /*!商品详情页店铺信息*/
#define JHFromStoreGoodsDetailBottomShopBtn @"saleCommodityDetailShortcut" /*!商品详情页底部店铺按钮*/
#define JHFromStoreSearchResult @"saleSearchWareResult" /*!商城商品搜索结果页(搜索结果切大图页)*/
#define JHFromStoreCollectionList @"saleWareCollection" /*!商城商品收藏列表*/
#define JHFromStoreFollowShopList @"saleFollowShopList" /*!商城用户关注店铺列表*/
#define JHFromChatPage  @"chatPage"//客服页面

///2.5新增页面来源
/*!个人中心推荐*/
#define JHFromStoreFollowPersonalRecommend  @"recommendCommoditiesPersonal"
/*!订单列表推荐*/
#define JHFromStoreFollowOrderListRecommend @"recommendCommoditiesOrderList"
/*!订单详情推荐*/
#define JHFromStoreFollowOrderDetailRecommend @"recommendCommoditiesOrderDetail"
/*!商品详情推荐*/
#define JHFromStoreFollowGoodsDetailRecommend  @"recommendCommoditiesCommodityDetail"
/*!商城秒杀列表*/
#define JHFromStoreFollowSaleFlashList @"saleFlashList" //秒杀专题列表
#define JHFromStoreFollowSaleFlashListFastBuy @"saleFlashListFastBuy" //秒杀里马上抢按钮

/**
 进入鉴定师profile页
 */
#define JHEventAssayerprofile @"assayerprofile"

/**
 源头直播页
 */

#define JHEventBusinessliveshow @"businessliveshow"


/**
 源头直播banner
 */

#define JHEventBusinesslivebanner @"businesslivebanner"

/**
 进入源头直播间
 */

#define JHEventBusinessliveplay @"businessliveplay"


/**
 在线鉴定页
 */
#define JHEventOnlineauthenticate @"onlineauthenticate"

/**
 点击免费鉴定
 */
#define JHEventClickfreeauthenticate @"clickfreeauthenticate"

/**
 进入鉴定直播间
 */
#define JHEventAuthoptionalliveplay @"authoptionalliveplay"

/**
 进入鉴定剪辑
 */
#define JHEventAuthoptionalvideoplay @"authoptionalvideoplay"

/**
 点评估报告
 */
#define JHEventAppraisalreport @"appraisalreport"

/**
 个人中心页
 */
#define JHEventPersonalcenter @"personalcenter"

/**
 点评估报告
 */
#define JHEventAppraisalreport @"appraisalreport"

/**
 通知中心
 */
#define JHEventNotificationcenter @"notificationcenter"

/**
 登录页面触发
 */
#define JHEventLogingamelaunch @"logingamelaunch"

/**
 登录方式选择
 */
#define JHEventLoginchoice @"loginchoice"

/**
 绑定手机号
 */
#define JHEventBindphonenumber @"bindphonenumber"

/**
 绑定成功
 */
#define JHEventBindphonenumbersucceed @"bindphonenumbersucceed"

/**
 登录成功
 */
#define JHEventLoginsucceed @"loginsucceed"


//埋点三期

#define JHTracklive_in @"live_in"//进入事件
#define JHTracklive_out @"live_out"//退出事件
#define JHTracklive_landbtn @"live_landbtn"//点赞按钮
#define JHTracklive_watch_doubleland @"live_watch_doubleland"//双击点赞
#define JHTracklive_bottom_sendmsgbtn @"live_bottom_sendmsgbtn"//底部发言按钮点击
#define JHTracklive_sendmsg_sendbtn @"live_sendmsg_sendbtn"//发言发送按钮点击
#define JHTracklive_sendmsg_result @"live_sendmsg_result"//发言
#define JHTracklive_gouwugonglue @"live_gouwugonglue"//购物攻略点击
#define JHTracklive_dz_gl_click @"dz_gl_click"//定制攻略点击
#define JHTracklive_maijiapingjia @"live_maijiapingjia"//买家评价点击
#define JHTracklive_tuihuanhuo @"live_tuihuanhuo"//退换货图标点击
#define JHTracklive_tousujianyi @"live_tousujianyi"//投诉建议点击
#define JHTracklive_closebtn @"live_closebtn"//关闭按钮点击
#define JHTracklive_bottom_sharebtn @"live_bottom_sharebtn"//底部分享按钮按钮点击
#define JHTracklive_share_weixin @"live_share_weixin"//微信分享点击
#define JHTracklive_share_pengyouquan @"live_share_pengyouquan"//微信朋友圈分享点击
#define JHTracklive_share_cancelbtn @"live_share_cancelbtn"//分享弹窗取消点击
#define JHTracklive_share_suc @"live_share_suc"//分享成功或取消
#define JHTracklive_share_fail @"live_share_fail"//分享失败
#define JHTracklive_bottom_kefu @"live_bottom_kefu"//底部客服按钮点击
#define JHTracklive_duration @"live_duration"//直播间停留时长
#define JHTracklive_info_attention @"live_info_attention"//主播关注按钮点击
#define JHTracklive_orderreceive_show @"live_orderreceive_show"//用户收单弹窗显示
#define JHTracklive_orderreceive_paybtn @"live_orderreceive_paybtn"//用户收单弹窗-去支付显示
#define JHTracklive_orderreceive_close_btn @"live_orderreceive_close_btn"//用户收单弹窗-关闭点击
#define JHTracklive_right_orderunpaybtn @"live_right_orderunpaybtn"//右侧未支付订单按钮点击
#define JHTracklive_bottom_identifyapplybtn @"live_bottom_identifyapplybtn"//底部申请鉴定按钮点击
#define JHTracklive_bottom_giftbtn @"live_bottom_giftbtn"//底部礼物按钮点击
#define JHTracklive_identifyapply_xianshi @"live_identifyapply_xianshi"//申请鉴定弹窗显示
#define JHTracklive_identifyapply_paishe @"live_identifyapply_paishe"//申请鉴定拍照点击
#define JHTracklive_identifyapply_applybtn @"live_identifyapply_applybtn"//申请鉴定按钮点击
#define JHTracklive_identifywait_cancelbtn @"live_identifywait_cancelbtn"//连麦等待弹窗-取消点击
#define JHTracklive_identifywait_closebtn @"live_identifywait_closebtn"//连麦等待弹窗-关闭点击
#define JHTracklive_identifywait2_show @"live_identifywait2_show"//连麦等待弹窗2(前方有人)-显示
#define JHTracklive_identifywait2_wait @"live_identifywait2_wait"//连麦等待弹窗2-继续等待按钮点击
#define JHTracklive_identifywait2_guangguang @"live_identifywait2_guangguang"//连麦等待弹窗2-逛逛卖场按钮点击
#define JHTracklive_chat_invite_show @"live_chat_invite_show"//连麦邀请弹窗-显示
#define JHTracklive_chat_invite_jujue @"live_chat_invite_jujue"//连麦邀请弹窗-拒绝点击
#define JHTracklive_chat_invite_tongyi @"live_chat_invite_tongyi"//连麦邀请弹窗-同意点击
#define JHTracklive_chat_invite_chaoshi @"live_chat_invite_chaoshi"//连麦邀请弹窗-超时
#define JHTracklive_chat_connect_suc @"live_chat_connect_suc"//连麦成功
#define JHTracklive_anchorinfo_click @"live_anchorinfo_click"//主播信息点击
#define JHTrackvidoe_detail2_in @"vidoe_detail2_in"//进入事件
#define JHTrackvideo_detail2_duration @"video_detail2_duration"//停留时长
#define JHTrackvideo_detail2_touxiangdianji @"video_detail2_touxiangdianji"//头像点击
#define JHTrackvideo_detail2_guanzhudianji @"video_detail2_guanzhudianji"//关注按钮点击
#define JHTrackvideo_detail2_baogaodianji @"video_detail2_baogaodianji"//评估报告点击
#define JHTrackvideo_detail2_left_comment_dianji @"video_detail2_left_comment_dianji"//左下方评论按钮点击
#define JHTrackvideo_detail2_bottom_comment_dianji @"video_detail2_bottom_comment_dianji"//底部评论按钮点击
#define JHTrackvideo_detail2_landclick @"video_detail2_landclick"//点赞
#define JHTrackvideo_detail2_shareclick @"video_detail2_shareclick"//分享按钮点击
#define JHTrackvideo_detail2_share_weixin @"video_detail2_share_weixin"//分享微信
#define JHTrackvideo_detail2_share_pengyouquan @"video_detail2_share_pengyouquan"//微信朋友圈分享点击
#define JHTrackvideo_detail2_share_cancelbtn @"video_detail2_share_cancelbtn"//分享弹窗取消点击次数
#define JHTrackvideo_detail2_share_suc @"video_detail2_share_suc"//分享成功或取消
#define JHTrackvideo_detail2_share_fail @"video_detail2_share_fail"//分享失败
#define JHTrackvideo_detail2_commentpage_show @"video_detail2_commentpage_show"//评论弹窗-显示
#define JHTrackvideo_detail2_commentpage_closeclick @"video_detail2_commentpage_closeclick"//评论弹窗-关闭按钮点击
#define JHTrackvideo_detail2_commentpage_sendclick @"video_detail2_commentpage_sendclick"//评论弹窗-评论发送按钮点击
#define JHTrackvideo_detail2_commentpage_sendcommit @"video_detail2_commentpage_sendcommit"//评论弹窗-评论发结果

#define JHTrackconfirm_order_quzhifu @"confirm_order_quzhifu"//去支付按钮点击
#define JHTrackorder_pay_paybtn @"order_pay_paybtn"//支付按钮点击
#define JHTrackorder_pay_result_weixin @"order_pay_result_weixin"//支付结果
#define JHTrackorder_pay_mul_paybtn @"order_pay_mul_paybtn"//确认支付按钮点击
#define JHTrackorder_pay_mul_result_weixin @"order_pay_mul_result_weixin"//支付结果

#define JHTracklive_orderreceive_show_process @"live_orderreceive_show_process" //用户收单弹窗显示加工服务单
#define JHTracklive_orderreceive_paybtn_process @"live_orderreceive_paybtn_process"//用户收单弹窗加工服务单-去支付显示
#define JHTracklive_orderreceive_closebtn_process @"live_orderreceive_closebtn_process"//用户收单弹窗加工服务单-关闭点击
#define JHTrackorder_detail_user_replacePayClick @"order_detail_user_replacePayClick"//订单详情代付按钮点击
#define JHTrackreplacePay_paybtn @"replacePay_paybtn"//代付按钮点击
#define JHTrackreplacePay_payResult @"replacePay_payResult"//代付分享结果

#define JHtrackvideo_detail_in @"video_detail_in" //以前的鉴定视频
#define JHtrackvideo_detail_duration @"video_detail_duration" //以前的鉴定视频

//v3.0.4
#define JHTrackStoneRestoreClick_reoffer @"drawer_stonerestore_btn_reoffer" //抽屉-我的出价-重新出价
#define JHTrackStoneRestoreClick_payleft @"drawer_stonerestore_btn_payleft" //抽屉-我的出价-支付尾款
#define JHTrackStoneRestoreClick_refuseOffer @"drawer_stonerestore_btn_refuseoffer" //抽屉-买家出价-拒绝
#define JHTrackStoneRestoreClick_receiveoffer @"drawer_stonerestore_btn_receiveoffer" //抽屉-买家出价-接受
#define JHTrackStoneRestoreClick_changeprice @"drawer_stonerestore_btn_changeprice" //抽屉-我的回血-修改价格
#define JHTrackStoneRestoreClick_cancelsale @"drawer_stonerestore_btn_cancelsale" //抽屉-我的回血-取消寄售
#define JHTrackStoneRestoreClick_offer @"drawer_stonerestore_btn_offer" //抽屉-原石回血-出价
#define JHTrackStoneRestore_orderpay @"stonerestore_pay" //提交订单-支付意向金页面:{"result":"true|false"}
#define JHTrackStoneRestore_orderoffer @"stonerestore_offer" //提交订单-出价并支付意向金页面:{"result":"true|false"}


//v3.1.7
//确认订单页面停留时长
#define JHTrackConfirmOrderDuration  @"confirm_Order_duration"
//地址提示弹窗显示
#define JHTrackConfirmOrderAddressAlertShow  @"confirm_Order_AddressAlert_show"
//地址提示弹窗点击去设置
#define JHTrackConfirmOrderAddressAlertSetAddressClick  @"confirm_Order_AddressAlert_SetAddress_click"
//地址提示弹窗点击取消
#define JHTrackConfirmOrderAddressAlertCancelClick @"confirm_Order_AddressAlert_Cancel_click"
//添加收货地址按钮按钮
#define JHTrackConfirmOrderAddAddressClick @"confirm_Order_AddAddress_click"
//保存并使用按钮点击
#define JHTrackCreatAddressSaveandUseClick @"create_Address_SaveandUse_click"

//进入确认订单页面
#define JHTrackConfirmOrderEnter  @"confirm_Order_enter"
//卖家同意出价，去支付尾款
#define JHConfirmFromSellerAgreePrice  @"confirmFromSellerAgreePrice"
//买家收到回血加工服务单
#define JHConfirmFromRestoreWorkOrder  @"confirmFromRestoreWorkOrder"
//我买到的订单列表
#define JHConfirmFromBoughtList  @"confirmFromBoughtList"
//从客服过来
#define JHConfirmFromKF  @"confirmFromKF"
//买家收到普通加工服务单
#define JHConfirmFromCommonWorkOrder  @"confirmFromCommonWorkOrder"
 //买家收到订单
#define JHConfirmFromOrderDialog  @"confirmFromOrderDialog"
//我的出价列表去支付尾款
#define JHConfirmFromMyOffer  @"confirmFromMyOffer"
//石头详情
#define JHConfirmFromStoneDetail  @"confirmFromStoneDetail"
//商品详情
#define JHConfirmFromGoodsDetail  @"confirmFromGoodsDetail"

//专题点击
#define JHTrackMallSpecialTopicClick  @"home_market_special_topic_click"
//专区点击
#define JHTrackMallSpecialAreaClick  @"home_market_special_area_click"

/*!到添加地址页的来源*/

//进入新增地址页面
#define JHTrackCreateAddressEnter @"create_Address_enter"
//从确认订单
#define JHAddAddressFromConfirm  @"addAddressFromConfirm"
//从地址管理
#define JHAddAddressFromAddressManger  @"addAddressFromAddressManger"

//特卖商城（3.1.4）- 商品搜索页
#define JHTrackMarketSaleSearchListIn   @"market_sale_search_ware_result_list_in"
#define JHTrackMarketSaleSearchFromInputBox   @"saleSearchWareInputBox" //搜索框
#define JHTrackMarketSaleSearchFromHotAdvert   @"saleSearchWareHotAdvert" //热搜广告
#define JHTrackMarketSaleSearchFromHistory   @"saleSearchWareHistory"  //历史记录
#define JHTrackMarketSaleSearchFromCategory   @"saleSearchWareCategory" //商品分类
//- 专题列表页
#define JHTrackMarketSaleTopicListIn   @"market_sale_special_topic_list_in"
#define JHTrackMarketSaleTopicFromNewcomer   @"saleHomeMarketNewcomerSaleSpecial" //新人专区
#define JHTrackMarketSaleTopicFromActive   @"saleHomeMarketActiveSaleSpecial" //活动专题
#define JHTrackMarketSaleTopicFromZone   @"saleHomeMarketZoneSaleSpecial" //专区专题
//- 广告位
#define JHTrackMarketSaleBannerItemClick   @"banner_item_click"
#define JHTrackMarketSaleClickSellBanner   JHLiveFromsellBanner //@"sellBanner" //源头直播
#define JHTrackMarketSaleClickIdentifyBanner   JHLiveFromidentifyBanner //@"identifyBanner" //在线鉴定
#define JHTrackMarketSaleClickPersonalBanner   JHLiveFrompersonalBanner //@"personalBanner" //个人中心
#define JHTrackMarketSaleClickSaleBanner   @"saleBanner" //特卖商城
#define JHTrackMarketSaleClickSplashBanner   JHLiveFromsplashBanner //@"splashBanner" //启动页广告

///v3.1.7
///来源
//订单鉴定报告来源：
//1.买家-订单详情 orderDetail
//2.买家-买家订单列表 boughtFragment
//3.卖家-订单列表  orderListSeller
//4.卖家-订单详情   orderDetailSeller
//5.直播间评价列表  orderEvaluateListInRoom
//6.鉴定师鉴定页面填写评估报告页面：identifyActivity
//7.商城-商品详情评论列表的更多-评论列表页  saleOrderEvaluateListFull
//8.卖家-评价管理   evaluateListSeller
//9.卖家-订单搜索结果页  searchOrderResult
//10.特卖商品详情-评价列表-鉴定详情  saleOrderEvaluateList
//11.卖家-原石回血订单详情 stoneRestoreOrderDetailSeller
//12.买家-原石回血订单详情  stoneRestoreOrderDetail
//13.订单支付成功页面 orderPay

#define JHFromOrderListSeller @"orderListSeller"
#define JHFromOrderDetailSeller @"orderDetailSeller"
#define JHFromOrderEvaluateListInRoom @"orderEvaluateListInRoom"
#define JHFromIdentifyActivity @"identifyActivity"
#define JHFromSaleOrderEvaluateListFull @"saleOrderEvaluateListFull"
#define JHFromEvaluateListSeller @"evaluateListSeller"
#define JHFromSearchOrderResult @"searchOrderResult"
#define JHFromSaleOrderEvaluateList @"saleOrderEvaluateList"
#define JHFromStoneRestoreOrderDetailSeller @"stoneRestoreOrderDetailSeller"
#define JHFromStoneRestoreOrderDetail @"stoneRestoreOrderDetail"
#define JHFromOrderPaySuccess @"orderPay"

///进入评估报告事件
#define JHtrackorder_report_detail_in @"order_report_detail_in"
///评估报告停留时长
#define JHtrackorder_report_detail_duration @"order_report_detail_duration"
#define JHtrackvideoplay_in @"videoplay_in"
#define JHtrackvideoplay_duration @"videoplay_duration"

//消息中心(317)
#define JHTrackMsgCenterEnter   JHEventNotificationcenter  //进入消息中心
#define JHTrackMsgCenterPushDuration   @"msg_show_timeduration"  //开启消息弹框停留时长
#define JHTrackMsgCenterPushOpenClick   @"msg_push_alert_open_click"  //去开启按钮
#define JHTrackMsgCenterPushCloseClick   @"msg_push_alert_close_click"  //关闭按钮
#define JHTrackMsgCenterTopPushClick   @"msg_tap_alert_click"  //消息中心顶部开启消息通知按钮
//#define JHTrackMsgCenterDuration   @"msg_center_timeduration"  //消息中心页面停留时间
#define JHTrackMsgCenterImportantCateClick   @"msg_important_important_click"  //重要分类
#define JHTrackMsgCenterCateClick   @"msg_important_click"  //分类
#define JHTrackMsgCenterServiceClick   @"msg_service_click"  //客服
#define JHTrackMsgCenterContactCustomerClick   @"msg_service_platform_click"  //商家会话~联系平台
#define JHTrackMsgCenterListClick   @"msg_list_page_tclick"  //各分类列表
#define JHTrackMsgCenterListDuration   @"msg_list_page_timeduration"  //各分类列表页列表停留
//#define JHTrackMsgCenterListAttenttionClick   @"msg_community_list_attention_click"  //社区互动列表页关注
#define JHTrackMsgCenterListAttenttionAlertClick   @"msg_community_list_attention_alert_click"  //社区互动列表宝友关注按钮点击
#define JHTrackMsgCenterListPacketClick   @"msg_sales_list_packet_click"  //促销优惠列表页红包
#define JHTrackMsgCenterStoneListClick   @"msg_stone_list_click"  //原石回血列表页角色
//318特卖
#define JHTrackMarketSaleTopicTabSwitch @"storeshop_topic_tab_switch"
#define JHTrackMarketSaleDetailShareSuccess @"sale_ware_detail_share_success" //特卖商品详情-分享成功
#define JHTrackMarketSaleDetailCollect @"sale_ware_detail_collect" //特卖商品详情-收藏

//321
//直播间放心购
#define JHTrackChannelLocalld_mind_rest_click @"channel_mind_rest_click_room"
//卖场放心购
#define JHTrackChannel_mind_rest_click_market @"channel_mind_rest_click_market"
//分流页跳过
#define JHTrackGuide_jump_with_cowry_click @"guide_jump_with_cowry_click"

///3.2.3新增
///点击在线鉴定服务
#define JHClickFreeAppraiseIntroduce  @"identifyActivity_online_click"
///免费申请鉴定点击
#define JHClickFreeAppraiseBtn  @"identifyActivity_apply_click"
//3.3.0买点
#define JHClickOneKeyLoginClick  @"enter_direct_click" //点击一键登录
#define JHClickOtherLoginClick  @"enter_other_click" //点击其他手机号登录
#define JHClickWechatLoginClick  @"loginchoice" //点击微信登录
#define JHClickQQLoginClick  @"enter_QQ_click" //点击QQ登录
#define JHClickLoginPageEnter  @"enter_live_in" //进入事件（login&bind）
#define JHClickOrderDetailSaleOrderEvaluateList  @"orderDetail_saleOrderEvaluateList_click" //直播放心购详情 进入
#define JHClickChannelNewUserClick @"channel_new_user_click" //点击新人红包
#define JHClickOrderEvaluateListHelpClick @"saleOrderEvaluateList_help_click" //点击有帮助
#define JHClickOrderEvaluateListNohelpClick @"saleOrderEvaluateList_nohelp_click" //点击没帮助
#define JHClickOrderEvaluateListProblemClick @"saleOrderEvaluateList_problem_click" //评估弹窗-点击问题
#define JHAnchorPageEnter @"anchor_enter" //主播详情页(介绍页？？)
#define JHIdentifyActivityChooseFrom @"identifyActivity_choose_from" //进入事件
#define JHIdentifyActivityChooseTabClick @"identifyActivity_choose_tab_click"
#define JHIdentifyActivityChooseApplyClick @"identifyActivity_choose_apply_click"
#define JHIdentifyActivityChooseRemindClick @"identifyActivity_choose_remind_click" //开播提醒点击
#define JHIdentifyActivityChooseStayTime @"identifyActivity_choose_stay_time"
#define JHIdentifyActivityStayClick @"identifyActivity_stay_click" //留下
#define JHIdentifyActivityLeaveClick @"identifyActivity_leave_click" //离开
#define JHIdentifyActivityReturnClick @"identifyActivity_return_click" //返回鉴定<直播间>
#define JHIdentifyActivityKnowClick @"identifyActivity_know_click" //知道了
#define JHIdentifyActivityDetailClick @"identifyActivity_detail_click" //查看详情
#define JHIdentifyActivityOrderClick @"identifyActivity_order_click" //查看订单
#define JHIdentifyActivityAppraiseldClick @"identifyActivity_appraiseld_click" //鉴定记录
#define JHIdentifyActivityOnlineClick @"identifyActivity_online_click" //连接
#define JHIdentifyActivityOnlickTimeClick @"identifyActivity_onlick_time" //连线鉴定弹窗-时长
#define JHChannelLocalldShopClick @"channelLocalld_shop_click" //点击购物橱窗
#define JHChannelLocalldAnchorClick @"channelLocalld_anchor_click" //点击直播间头像
#define JHChannelLocalldNoticeClick @"channelLocalld_notice_click" //点击公告图
#define JHChannelLocalldNoticeCloseClick @"channelLocalld_notice_close_click"  //点击公告图close
#define JHChannelLocalldShopConsultClick @"channelLocalld_shop_consult_click" //点击咨询主播
#define JHChannelLocalldShopBuyClick @"channelLocalld_shop_by_click" //点击购买

#define JHMarketSecondTabSwitch @"market_second_tab_switch" //直购-直播购物-二级tabbar点击
#define JHMarketThirdTabSwitch @"market_third_tab_switch" //直购-直播购物-三级tabbar点击
#define JHMarketTopBannerClick @"market_top_banner_click" //直购-推荐banner点击

#define JHLiveRoomMicBackMallClick @"shopping_mall" //点击底部弹层上的‘逛逛卖场’按钮
#define JHLiveRoomMicCloseClick @"pop_close" //点击页面弹层右上角到关闭按钮
#define JHLiveRoomMicRecommendClick @"pop_recommend" //点击推荐的直播间
#define JHLiveRoomMicCancleConfirmClick @"confirm_button" //二次确认取消连麦

#define JHtrackBusinessliveQuickSpeakClick @"businesslive_quick_speak_enter_click"   //点击快捷语入口
#define JHtrackBusinessliveQuickSpeakItemClick @"businesslive_quick_speak_item_click"    //选择快捷语
#define JHtrackBusinessliveExpressionClick @"businesslive_expression_enter_click"   //点击表情入口
#define JHtrackBusinessliveExpressionItemClick @"businesslive_expression_item_click"  //点击表情
//#define JHMarketTopBannerClick @"market_top_banner_click" //直购-运营位点击
#define JHMarketBottomBannerClick @"market_bottom_banner_click" //直购-列表中的运营位点击
#define JHMarketListItemClick @"market_list_item_click" //直购-列表直播间点击

#define JHNewuserGiftDialogOperate @"newuser_gift_dialog_operate" //新人红包-点击事件
#define JHNewuserGiftGetDialogOperate @"newuser_gift_get_dialog_operate" //新人红包-点击后弹窗点击事件

#define JHAppraiserSendGiftSuccess @"appraiser_send_gift_success" //发红包点击发送成事件
#define JHOpenAppraiserSendGiftClick @"open_appraiser_send_gift_click" //开红包点击
#define JHReceivedAppraiserSendGiftClick @"received_appraiser_send_gift_click" //红包结果点击

//直播间PK
#define JHtrackRanding_listClick @"randing_list" //榜单入口点击事件
#define JHtrackType_Click @"type_click" //标签点击事件
#define JHtrackRanding_recommendClick @"randing_recommend" //榜单列表直播间点击事件

#define JHtrackMarket_second_tab_switchClick @"market_second_tab_switch" //源头直购-直播购物


#pragma mark -
#pragma mark ---------------------------  340社区埋点  ---------------------------

///社区首页推荐页 点击导航加号
#define JHTrackSQPublishTabEnter @"write_enter"
///<热帖> # 点击帖子
#define JHTrackSQHotTwitterEnter @"hot_Twitter_enter"
///<热帖> # 点击前一天
#define JHTracSQkHotPreviousDayClick @"hot_previousday"
///<热帖> # 点击后一天
#define JHTrackSQHotNextDayClick @"hot_nextday"
///<热帖> # 点击返回今天
#define JHTrackSQHotTodayClick @"hot_today"


#pragma mark -----------------  板块埋点  ----------------------

///<板块> # 进入板块停留时长
#define JHTrackSQPlateBrowseTime @"channel_browse_time"
///<板块> # 进入板块主页
#define JHTrackSQPlateDetailEnter @"channel_detail_enter"
///<板块> # 点击板块版主头像
#define JHTrackSQPlateAdminIconEnter @"channel_admin_enter"
///<板块> # 点击板块版主简介
#define JHTrackSQPlateInfoClick @"channel_info_click"
///<板块> # 点击版块关联话题
#define JHTrackSQPlateTopicEnter @"channel_topic_enter"
///<板块> # 点击版块搜索
#define JHTrackSQPlateSearchEnter @"channel_search_enter"
///<板块> # 点击版块右上角更多
#define JHTrackSQPlateMoreClick @"channel_operation_click"
///<板块> # 点击板块分类内容
#define JHTrackSQPlateClassifyClick @"channel_classify_click"
///<板块> # 点击版块排序开关 最热
#define JHTrackSQPlateSortReplyClick @"channel_sort_reply_click"
///<板块> # 点击版块排序开关 最新
#define JHTrackSQPlateSortReleaseClick @"channel_sort_release_click"
///<板块> # 点击版块公告
#define JHTrackSQPlateNoticeClick @"channel_Notice_enter"
///<板块> # 点击版块置顶
#define JHTrackSQPlateTopClick @"channel_top_enter"
///<板块> # 点击版块长文章
#define JHTrackSQPlateArticleEnter @"channel_article_enter"
///<板块> # 点击版块动态图片
#define JHTrackSQPlateTwitterPicEnter @"channel_Twitter_pic_enter"
///<板块> # 点击版块动态全文
#define JHTrackSQPlateTwitterEnter @"channel_Twitter_enter"
///<板块> # 点击版块小视频
#define JHTrackSQPlateVideoEnter @"channel_video_enter"
///<板块> # 点击版块动态快捷评论
#define JHTrackSQPlateTwitterQuicklyCommentEnter @"channel_Twitter_comment_enter"
///<板块> # 点击版块列表用户头像
#define JHTrackSQPlateUserIconEnter @"channel_user_enter"
///<板块> # 点击版块列表点击右上角...
#define JHTrackSQPlateListMoreEnter @"channel_operation_enter"
///<板块> # 点击版块列表中版块
#define JHTrackSQPlateListChannelEnter @"channel_list_channel_enter"
///<板块> # 点击版块列表中评论
#define JHTrackSQPlateListCommentClick @"channel_list_comment_click"
///<板块> # 点击版块列表中分享
#define JHTrackSQPlateListShareClick @"channel_list_share_click"
///<板块> # 点击版块列表中点赞
#define JHTrackSQPlateListLikeClick @"channel_list_like_click"


#pragma mark -----------------  话题埋点  ----------------------
///<话题> # 进入话题停留时长
#define JHTrackSQTopicBrowseTime @"topic_browse_time"
///<话题> # 话题进入事件
#define JHTrackSQTopicDetailEnter @"topic_detail_enter"
///<话题> # 点击话题搜索
#define JHTrackSQTopicSearchEnter @"topic_search_enter"
///<话题> # 点击话题。。。更多
#define JHTrackSQTopicMoreClick @"topic_operation_click"
///<话题> # 点击话题内容分类
#define JHTrackSQTopicClassifyClick @"topic_classify_click"
///<话题> # 点击话题排序-最新回复
#define JHTrackSQTopicSortReplyClick @"topic_sort_reply_click"
///<话题> # 点击话题排序-最新发布
#define JHTrackSQTopicSortReleaseClick @"topic_sort_release_click"
///<话题> # 点击话题长文章
#define JHTrackSQTopicArticleEnter @"topic_article_enter"
///<话题> # 点击话题动态图片
#define JHTrackSQTopicTwitterPicEnter @"topic_Twitter_pic_enter"
///<话题> # 点击话题动态全文
#define JHTrackSQTopicTwitterEnter @"topic_Twitter_enter"
///<话题> # 点击话题小视频
#define JHTrackSQTopicVideoEnter @"topic_video_enter"
///<话题> # 点击话题快捷评论
#define JHTrackSQTopicTwitterQuicklyCommentEnter @"topic_Twitter_comment_enter"
///<话题> # 点击话题列表用户头像
#define JHTrackSQTopicUserIconEnter @"topic_user_enter"
///<话题> # 点击话题列表帖子右上角。。。更多
#define JHTrackSQTopicListMoreEnter @"topic_operation_enter"
///<话题> # 点击话题列表中话题
#define JHTrackSQTopicListTopicEnter @"topic_list_topic_enter"
///<话题> # 点击话题列表中评论
#define JHTrackSQTopicListCommentClick @"topic_list_comment_click"
///<话题> # 点击话题列表中分享
#define JHTrackSQTopicListShareClick @"topic_list_share_click"
///<话题> # 点击话题列表中点赞
#define JHTrackSQTopicListLikeClick @"topic_list_like_click"

#pragma mark -------- 长文章详情页 --------------
///<详情> # 长文章详情页停留时长
#define JHTrackSQArticleBrowseTime @"article_browse_time"
///<详情> # 长文章详情页进入事件
#define JHTrackSQArticleDetialEnter @"article_detail_enter"
///<详情> # 长文章详情页点击用户信息-- 头像
#define JHTrackSQArticleDetailUserEnter @"article_detail_user_enter"
///<详情> # 长文章详情页关注用户
#define JHTrackSQArticleDetialFollowClick @"article_detail_user_follow_click"
///<详情> # 长文章详情页点开大图
#define JHTrackSQArticleDetailPicEnter @"article_detail_pic_enter"
///<详情> # 长文章详情页点开视屏全屏
#define JHTrackSQArticleDetailVideoEnter @"article_detail_video_enter"
///<详情> # 长文章详情页点击版块
#define JHTrackSQArticleDetailPlateEnter @"article_detail_channel_enter"
///<详情> # 长文章详情页点击话题
#define JHTrackSQArticleDetailTopicEnter @"article_detail_topic_enter"
///<详情> # 长文章详情页点击店铺入口
#define JHTrackSQArticleDetailShopEnter @"article_detail_shop_enter"
///<详情> # 长文章详情页点击直播间入口
#define JHTrackSQArticleDetailLiveEnter @"article_detail_live_enter"

///<详情> # 长文章详情页写评论
#define JHTrackSQArticleDetailWriteCommentClick @"article_detail_write_comment_click"
///<详情> # 长文章详情页回复评论
#define JHTrackSQArticleDetailReplyCommentClick @"article_detail_reply_comment_click"
///<详情> # 长文章详情页展开一级评论
#define JHTrackSQArticleDetailOpenFirstCommentClick @"article_detail_open_first_comment_click"
///<详情> # 长文章详情页展开二级评论
#define JHTrackSQArticleDetailOpenSecondCommentClick @"article_detail_open_second_comment_click"
///<详情> # 长文章详情页一级评论点赞
#define JHTrackSQArticleDetailLikeFirstCommentClick @"article_detail_like_first_comment_click"
///<详情> # 长文章详情页二级评论点赞
#define JHTrackSQArticleDetailLikeSecondCommentClick @"article_detail_like_second_comment_click"
///<详情> # 长文章详情页互动区写评论
#define JHTrackSQArticleDetailInteractionWriteCommentClick @"article_detail_interaction_write_comment_click"
///<详情> # 长文章详情页互动区点击评论icon
#define JHTrackSQArticleDetailInteractionCommentClick @"article_detail_interaction_comment_click"
///<详情> # 长文章详情页互动区点击点赞icon
#define JHTrackSQArticleDetailInteractionLikeClick @"article_detail_interaction_like_click"
///<详情> # 长文章详情页互动区点击分享icon
#define JHTrackSQArticleDetailInteractionShareClick @"article_detail_interaction_share_click"

///<详情> # 动态/视频停留时长
#define JHTrackSQTwitterBrowseTime @"Twitter_browse_time"
///<详情> # 动态/视频进入事件
#define JHTrackSQTwitterDetailEnter @"Twitter_detail_enter"
///<详情> # 动态/视频点击用户信息
#define JHTrackSQTwitterDetailUserIconEnter @"Twitter_detail_user_enter"
///<详情> # 动态/视频点击关注用户
#define JHTrackSQTwitterDetailUserFollowEnter @"Twitter_detail_user_follow_click"
///<详情> # 动态/视频点开大图
#define JHTrackSQTwitterDetailPicEnter @"Twitter_detail_pic_enter"
///<详情> # 动态/视频点开视频（全屏）
#define JHTrackSQTwitterDetailVideoEnter @"Twitter_detail_video_enter"
///<详情> # 动态/视频点击版块
#define JHTrackSQTwitterDetailPlateEnter @"Twitter_detail_channel_enter"
///<详情> # 动态/视频点击话题
#define JHTrackSQTwitterDetailTopicEnter @"Twitter_detail_topic_enter"
///<详情> # 动态/视频点击店铺
#define JHTrackSQTwitterDetailShopEnter @"Twitter_detail_shop_enter"
///<详情> # 动态/视频点击直播间
#define JHTrackSQTwitterDetailLiveEnter @"Twitter_detail_live_enter"
///<详情> # 动态/视频写评论
#define JHTrackSQTwitterDetailWriteCommentClick @"Twitter_detail_write_comment_click"
///<详情> # 动态/视频回复评论
#define JHTrackSQTwitterDetailReplyCommentClick @"Twitter_detail_reply_comment_click"
///<详情> # 动态/视频展开父级评论
#define JHTrackSQTwitterDetailOpenFirstCommentClick @"Twitter_detail_open_first_comment_click"
///<详情> # 动态/视频展开子级评论
#define JHTrackSQTwitterDetailOpenSecondCommentClick @"Twitter_detail_open_second_comment_click"
///<详情> # 动态/视频点赞父级评论
#define JHTrackSQTwitterDetailLikeFirstCommentClick @"Twitter_detail_like_first_comment_click"
///<详情> # 动态/视频点赞子级评论
#define JHTrackSQTwitterDetailLikeSecondCommentClick @"Twitter_detail_like_second_comment_click"
///<详情> # 动态/视频互动区写评论
#define JHTrackSQTwitterDetailInteractionWriteCommentClick @"Twitter_detail_interaction_write_comment_click"
///<详情> # 动态/视频互动区点击评论icon
#define JHTrackSQTwitterDetailInteractionCommentClick @"Twitter_detail_interaction_comment_click"
///<详情> # 动态/视频互动区点击点赞icon
#define JHTrackSQTwitterDetailInteractionLikeClick @"Twitter_detail_interaction_like_click"
///<详情> # 动态/视频互动区点击点赞icon
#define JHTrackSQTwitterDetailInteractionShareClick @"Twitter_detail_interaction_share_click"



///小视频 竖屏显示时
///<详情> # 竖屏进入停留时长事件
#define JHTrackSQVideoDetailBrowseTime @"video_detail_browse_time"
///<详情> # 竖屏进入事件
#define JHTrackSQVideoDetailEnter @"video_detail_enter"
///<详情> # 竖屏点击用户头像
#define JHTrackSQVideoDetailUserIconEnter @"video_detail_user_enter"
///<详情> # 竖屏点击关注用户
#define JHTrackSQVideoDetailUserFollowClick @"video_detail_user_follow_click"
///<详情> # 竖屏互动区写评论
#define JHTrackSQVideoDetailWriteCommentClick @"video_detail_interaction_write_comment_click"
///<详情> # 竖屏互动区点击评论icon
#define JHTrackSQVideoDetailCommentClick @"video_detail_interaction_comment_click"
///<详情> # 竖屏互动区点击点赞icon
#define JHTrackSQVideoDetailLikeClick @"video_detail_interaction_like_click"
///<详情> # 竖屏互动区点击分享icon
#define JHTrackSQVideoDetailShareClick @"video_detail_interaction_share_click"

///<详情> # 评论发布成功
#define JHTrackSQCommentSuccess @"comment_success"


#pragma mark -------- 定制相关 --------------
//点击申请定制
#define JHTrackCustomizelive_sqdz_click @"sy_sqdz_click"
//点击电视机运营位
#define JHTrackCustomizelive_tv_banner_in @"dz_tv_banner_in"
//点击定制师
#define JHTrackCustomizelive_dz_works_in @"dz_works_in"
//电视机位置点击
#define JHTrackCustomizelive_tv_banner_click @"dz_tv_banner_click"
//运营位
#define JHTrackCustomizelive_top_banner_click @"dz_top_banner_click"
//切换定制师/作品
#define JHTrackCustomizelive_sy_type_in @"dz_sy_type_in"
//作品tab点击
#define JHTrackCustomizelive_tab_works_click @"dz_tab_works_click"
//直播间下方点击“连麦定制”按钮
#define JHTrackCustomizelive_lmdz_click @"live_lmdz_click"
//定制弹层显示
#define JHTrackCustomizelive_lmdz_show @"live_lmdz_show"
//定制协议弹层显示
#define JHTrackCustomizelive_lmdz_xieyi_show @"live_lmdz_xieyi_show"
//定制协议弹层点击申请定制
#define JHTrackCustomizelive_lmdz_xieyi_click @"live_lmdz_xieyi_click"
//定制弹层列表点击申请连麦
#define JHTrackCustomizelive_lmdz_tc_sqlm_click @"live_lmdz_tc_sqlm_click"
//定制弹层列表点击申请定制
#define JHTrackCustomizelive_lmdz_tc_sqdz_click @"live_lmdz_tc_sqdz_click"


//定制弹层点击拍照上传
#define JHTrackCustomizelive_lmdz_cam_click @"live_lmdz_cam_click"
//定制弹层点击已有订单
#define JHTrackCustomizelive_lmdz_ordercam_click @"live_lmdz_ordercam_click"
//点击拍照上传
#define JHTrackCustomizelive_lmdz_camshow_click @"live_lmdz_camshow_click"
//点击申请连麦
#define JHTrackCustomizelive_lmdz_sqlm_click @"live_lmdz_sqlm_click"
//排队弹层显示
#define JHTrackCustomizelive_lmdz_queue_click @"live_lmdz_queue_click"
//排队弹层点击取消排队
#define JHTrackCustomizelive_lmdz_canslequeue_click @"live_lmdz_canslequeue_click"
//排队弹层点击逛逛直播购物
#define JHTrackCustomizelive_lmdz_ggzg_click @"live_lmdz_ggzg_click"
//取消排队的二次确认弹层点击确认
#define JHTrackCustomizelive_lmdz_confirm_click @"live_lmdz_confirm_click"

//断开连麦(小窗口）    dz_dklm_click
#define JHTrackAudiencedz_dklm_click @"dz_dklm_click"
//断开连麦-弹层点击确认    dz_dklm_sure_click
#define JHTrackAudiencedz_dklm_sure_click @"dz_dklm_sure_click"
//断开连麦-弹层点击取消    dz_dklm_close_click
#define JHTrackAudiencedz_dklm_close_click @"dz_dklm_close_click"


//连麦邀请弹窗-显示
//#define JHTrackCustomizelive_chat_invite_show @"live_chat_invite_show"
//连麦邀请弹窗-拒绝点击
//#define JHTrackCustomizelive_chat_invite_jujue @"live_chat_invite_jujue"
//连麦邀请弹窗-同意点击
#define JHTrackCustomizelive_chat_invite_tongyi @"live_chat_invite_tongyi"
//直播间内部排队提示弹层显示
#define JHTrackCustomizelive_queue @"live_queue"
//点击留下
#define JHTrackCustomizedz_stay_click @"dz_stay_click"
//点击离开
#define JHTrackCustomizedz_leave_click @"dz_leave_click"
//直播间外部排队提示弹层显示
#define JHTrackCustomizelive_out_queue @"live_out_queue"
//点击返回鉴定直播间（其他room）
#define JHTrackCustomizedz_return_click @"dz_return_click"
//点击知道了
#define JHTrackCustomizedz_know_click @"dz_know_click"

#define JHTrackAudiencelive_pay_show @"live_pay_show"  //支付弹层显示
#define JHTrackOrderlive_pay_sure_click @"live_pay_sure_click"  //支付弹层点击确认支付
#define JHTrackOrderlive_pay_close_click @"live_pay_close_click"  //支付弹层点击关闭按钮
#define JHTrackCustomizeListdz_item_click @"dz_item_click"  //定制列表item点击
#define JHTrackCustomizeListdz_search_click @"dz_search_click" //定制搜索页点击搜索
#define JHTrackCustomizeListdz_search_item @"dz_search_item"//搜索结果列表页点击item
//个人中心订单
#define JHTrackUserSeller_center_allorder_click @"seller_center_allorder_click"  //我的订单
#define JHTrackUserSeller_center_waitorder_click @"seller_center_waitorder_click"  //待付款
#define JHTrackUserSeller_center_receiveorder_click @"seller_center_receiveorder_click"  //待收货
#define JHTrackUserSeller_center_evaluateorder_click @"seller_center_evaluateorder_click" //待评价
#define JHTrackUserSeller_center_refund_click @"seller_center_refund_click"//退款售后
//个人中心定制订单
#define JHTrackUserdz_center_allorder_click @"dz_center_allorder_click"  //点击全部订单
#define JHTrackUserdz_center_receiveorder_click @"dz_center_receiveorder_click"  //点击待收货
#define JHTrackUserdz_center_waitorder_click @"dz_center_waitorder_click"  //点击待付款
#define JHTrackUserdz_center_ingorder_click @"dz_center_ingorder_click" //点击进行中
#define JHTrackUserdz_center_comorder_click @"dz_center_comorder_click"//点击已完成
/** 鉴定师页面*/
///<鉴定师> #点击用户评价
#define JHTrackProfileEvaluateClick @"profile_evaluate_click"
///<鉴定师> # 切换鉴过
#define JHTrackProfileAppraisalClick @"profile_appraisal_click"


//搜索列表进入事件
#define JHLive_search_in @"live_search_in"
//搜索框点击事件
#define JHSearch_click @"search_click"

//进入定制师主页
#define JHdz_teacher_in @"dz_teacher_in"


#pragma mark - 在线鉴定埋点相关
///<直播购物> # 直播间分类tab标签
#define JHTrackMallLivingTabClick @"tab_click"
///<直播购物> # 推荐直播间列表-直播间
#define JHTrackMallLivingRecommendLiveRoomEnter  @"live_list_in"
///<直播购物> # 推荐直播间列表-运营位
#define JHTrackMallLivingOperateClick  @"live_list_market_area_click"




@interface TrackLiveBaseModel : NSObject
//{roomId和anchorId,"channelType":"","channelLocalId":"直播间id"}
@property(nonatomic, copy)NSString *roomId;
@property(nonatomic, copy)NSString *anchorId;
@property(nonatomic, copy)NSString *channelLocalId;
@property(nonatomic, copy)NSString *channelType;
@property(nonatomic, copy)NSString *currentRecordId;
///设备号
@property(nonatomic, copy)NSString *deviceId;


@end

@interface LiveExtendModel : TrackLiveBaseModel
@property(nonatomic, copy)NSString *from;
@property(nonatomic, copy)NSString *third_tab_from;
@property(nonatomic, copy)NSString *orderCode;
@property(nonatomic, copy)NSString *status;//shenqing quxiao
@property(nonatomic, copy)NSString *waitNum;
@property(nonatomic, copy)NSString *duration;
@property(nonatomic, copy)NSString *result;//true false
@property(nonatomic, copy)NSString *commentId;
@property(nonatomic, copy)NSString *userId;
@property(nonatomic, assign)NSTimeInterval time;
@property(nonatomic, copy)NSString *orderCategory;
@property(nonatomic, copy)NSString *channelCategory;
@property(nonatomic, copy)NSString *teachername; //定制师名字

@end

@interface TrackVideoBaseModel : NSObject
//{
//"recordId":"视频记录id",
//"originRecordId":"来源直播记录Id",
//"appraiserId":"鉴定师id",
//"appraiseId":"鉴定记录id"}

@property(nonatomic, copy)NSString *recordId;
@property(nonatomic, copy)NSString *originRecordId;
@property(nonatomic, copy)NSString *appraiserId;
@property(nonatomic, copy)NSString *appraiseId;
@property(nonatomic, copy)NSString *userId;
@property(nonatomic, assign)NSTimeInterval time;
///设备号
@property(nonatomic, copy)NSString *deviceId;
@end

@interface VideoExtendModel : TrackVideoBaseModel
@property(nonatomic, copy)NSString *from;
@property(nonatomic, copy)NSString *duration;
@property(nonatomic, copy)NSString *result;//true false
@property(nonatomic, copy)NSString *commentId;
@property(nonatomic, assign)bool playOver;
@property(nonatomic, copy)NSString *video_id;




@end


@interface OrderTrackModel : NSObject
@property(nonatomic, copy)NSString *orderCode;
@property(nonatomic, copy)NSString *payWay;//weixin|zhifubao|xianxiadakuan|multi
@property(nonatomic, copy)NSString *suc;//true false
@property(nonatomic, copy)NSString *errorWhenReq; //请求报错
@property(nonatomic, copy)NSString *userId;
@property(nonatomic, assign)NSTimeInterval time;
@property(nonatomic, copy)NSString *orderCategory;
@property(nonatomic, copy)NSString *result;
///设备号
@property(nonatomic, copy)NSString *deviceId;

@end

@interface JHGrowingIO : NSObject
+ (void)trackEventId:(NSString *)eventId;
+ (void)trackEventId:(NSString *)eventId variable:(NSString *)value;
+ (void)trackEventId:(NSString *)eventId variables:(NSDictionary *)value;
+ (void)trackEventId:(NSString *)eventId variables:(NSDictionary *)value number:(NSInteger)count;
+ (void)trackEventId:(NSString *)eventId number:(NSInteger)count;


/// 订单支付相关埋点
/// @param eventId 事件id
/// @param orderCode 订单号
/// @param payWay 支付方式 weixin|zhifubao|xianxiadakuan|multi
/// @param truefalse 支付是否成功 true false
+ (void)trackOrderEventId:(NSString *)eventId orderCode:(NSString *)orderCode payWay:(NSString *)payWay suc:(NSString *)truefalse;

+ (LiveExtendModel *)liveExtendModelChannel:(ChannelMode *)model;
+ (VideoExtendModel *)videoExtendModel:(AppraisalDetailMode *)appraise;
//记录来源专用
+ (void)trackEventId:(NSString *)eventId from:(NSString *)from;
//记录带公参的点
+ (void)trackPublicEventId:(NSString *)eventId;
+ (void)trackPublicEventId:(NSString *)eventId paramDict:(NSDictionary *)dict;
@end

