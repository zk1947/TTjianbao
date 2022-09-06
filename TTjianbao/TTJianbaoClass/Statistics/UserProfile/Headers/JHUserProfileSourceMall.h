//
//  JHUserProfileSourceMall.h
//  TTjianbao
//  Description:源头直购
//  Created by Jesse on 2020/9/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHUserProfileSourceMall_h
#define JHUserProfileSourceMall_h

//MARK: # 直播购物
#define kUPEventTypeLiveShopHomeBrowse @"live_shophome_browse" //<直播购物>首页停留时长
#define kUPEventTypeLiveShopGroupBrowse @"live_shopgroup_browse" //直播购物分组停留时长
#define kUPEventTypeLiveRoomDetailBrowse @"live_room_detail_browse" //卖场直播间详情页停留时长
#define kUPEventTypeLiveHomeTabEntrance @"live_home_tab_entrance" //直播购物首页进入事件
#define kUPEventTypeLiveLabelTabClick @"live_label_tab_click" //卖场直播间导航分组标签(一级)点击事件
#define kUPEventTypeLiveLabelTab2Click @"live_label_2tab_click" //卖场直播间导航分组标签(二级)点击事件
#define kUPEventTypeShopLiveRoomEntrance @"shopping_live_room_entrance" //卖场直播间进入事件

//MARK: # 特卖商城
#define kUPEventTypeLiveMallHomeBrowse @"mall_home_browse" //<特卖商城>首页停留时长

/** 商品详情页停留时长 */
#define kUPEventTypeMallDetailCommidtityBrowse @"mall_commodity_detail_browse"

/** 商城banner活动页停留时长 */
#define kUPEventTypeMallBannerBrowse @"mall_banner_browse"

/** 新人专项位停留时长 */
#define kUPEventTypeMallNewUserBannerBrowse @"mall_new_user_banner_browse"

/** 秒杀列表页停留时长 */
#define kUPEventTypeMallFlashSaleListBrowse @"mall_flashsale_list_browse"

/** 活动为列表页停留时长 : 活动位（新店、高货、捡漏）停留时长（秒杀下方三个专题位）*/
#define kUPEventTypeMallActivityListBrowse @"mall_avtivity_list_browse"

/** 资源位列表停留时长 */
#define kUPEventTypeMallCategoryListDefaultBrowse @"mall_category_list_default_browse"

/** 商城首页导航分组停留时长 */
#define kUPEventTypeMallCategoryListBrowse @"mall_category_list_browse"

/** 店铺首页停留时长 */
#define kUPEventTypeMallShopHomeBrowse @"mall_shop_home_browse"

/** 选择分类页停留时长 */
#define kUPEventTypeMallCategoryHomeBrowse @"mall_category_home_browse"

/** 分类列表页停留时长 */
#define kUPEventTypeMallCategoryTabBrowse @"mall_category_tab_browse"

/** 特卖商城首页进入事件 */
#define kUPEventTypeMallHomeEntrance @"mall_home_entrance"
/** 商品详情页进入事件 ： 获取该商品所属分类（一级>二级） */
#define kUPEventTypeMallCommodityDetailEntrance @"mall_commodity_detail_entrance"




//MARK: # 原石回血
#define kUPEventTypeLivePayBackHomeBrowse @"payback_home_browse" //<原石回血>首页停留时长
#pragma mark -------- 原石回血 begin --------

///原石回血首页停留时长
#define kUPEventTypeLivePayBackHomeBrowse @"payback_home_browse"

///原石回血首页停留时长
#define kUPEventTypeResaleStoneDetailBrowse @"consign_stone_detail_browse"

///个人转售详情停留时长
#define kUPEventTypeStoneDetailBrowse @"resale_stone_detail_browse"

///已售原石详情停留时长
#define kUPEventTypeSoldStoneDetailBrowse @"sold_stone_detail_browse"

///浏览原石回血页签
#define kUPEventTypePaybackHomeEntrance @"payback_home_entrance"

#pragma mark -------- 原石回血 end --------





#pragma mark -------- 订单 begin --------

///确认订单
#define kUPEventTypeOrderConfirmed @"pay_confirmed"

#pragma mark -------- 订单 end --------

#endif /* JHUserProfileSourceMall_h */
