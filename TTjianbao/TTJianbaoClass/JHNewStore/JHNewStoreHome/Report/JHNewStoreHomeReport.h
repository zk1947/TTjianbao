//
//  JHNewStoreHomeReport.h
//  TTjianbao
//
//  Created by user on 2021/3/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreHomeReport : NSObject
@property (nonatomic, copy) NSString *tabName;

+ (JHNewStoreHomeReport *)shared;


/// 商城首页 - 搜索框点击事件上报
+ (void)jhNewStoreSearchViewClickReport;


/// 顶部导航教育信息点击事件
+ (void)jhNewStoreHomeGoToEducationClick;

/// 商城首页 - 金刚位点击上报
+ (void)jhNewStoreHomeKingKongClickReport:(NSString *)jgw_name
                            position_sort:(NSString *)position_sort;

/// 商城首页 - 轮播图点击上报
+ (void)jhNewStoreHomeBannerClickReport:(NSString *)page_position
                          position_sort:(NSInteger)position_sort
                            content_url:(NSString *)content_url
                               ad_title:(NSString *)ad_title;

/// 商城首页 - 横幅广告点击
+ (void)jhNewStoreHomeAdClickReport:(NSString *)ad_id
                           ad_title:(NSString *)ad_title
                      position_sort:(NSInteger)position_sort;

/// 商城首页 - 新人活动点击
+ (void)jhNewStoreHomeNewPeopleClickReport:(NSString *)store_from;

/// 商城首页 - Tab点击
+ (void)jhNewStoreHomeTabClickReport:(NSString *)tab_Name;

/// 商城首页 - 专场分享点击
+ (void)jhNewStoreHomeBoutiqueShareClickReport:(NSString *)zc_name
                                       zc_type:(NSInteger)zc_type /*01.预告，02.热卖，03.已结束*/
                                         zc_id:(NSString *)zc_id;

/// 商城首页 - 专场开售提醒点击
+ (void)jhNewStoreHomeBoutiqueWillActiveClickReport:(NSString *)zc_name
                                              zc_id:(NSString *)zc_id;

/// 商城首页 - 推荐商品筛选标签点击
+ (void)jhNewStoreHomeGoodsTabClickReport:(NSString *)tab_name;


///// 商城首页 - 专场点击
//+ (void)jhNewStoreHomeBoutiqueClickReport:(NSString *)zc_name
//                                  zc_type:(NSInteger)zc_type /*01.预告，02.热卖，03.已结束*/
//                                    zc_id:(NSString *)zc_id
//                               store_from:(NSString *)store_from;

/// 商城首页 - TabBar item 点击
+ (void)jhNewStoreHomeTabBarItemClickReport:(NSString *)tab_attribute;

/// 商城首页 - 天天商城浏览
+ (void)jhNewStoreHomeShowReport;

/// 商城首页 - 收藏点击
+ (void)jhNewStoreHomeCollectionBtnClick:(NSString *)zc_name
                                   zc_id:(NSString *)zc_id
                              store_from:(NSString *)store_from;

/// 商城首页 - 推荐商品列表
+ (void)jhNewStoreHomeGoodsShowListReportWithTag_name:(NSString *)tag_name
                                           goodsIdArr:(NSArray *)goodsIdArr;

/// 商城首页 - 推荐商品点击
+ (void)jhNewStoreHomeGoodsShowListClick:(NSString *)goodId
                         commodity_label:(NSString *)commodity_label
                          commodity_name:(NSString *)commodity_name
                         andCurrentTitle:(NSString *)curTitle;
@end

NS_ASSUME_NONNULL_END
