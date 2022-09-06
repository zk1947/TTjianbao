//
//  GrowingManager.h
//  TTjianbao
//
//  Created by wuyd on 2019/10/24.
//  Copyright © 2019 Netease. All rights reserved.
//  Growing埋点上报
//

#import <Foundation/Foundation.h>
#import "JHGrowingIO.h"

//文章页 - 浏览时长通知
static NSString * _Nullable const JHGrowingNotify_ArgicleBrowse = @"JHGrowingNotifyArgicleBrowse";
//文章页 - 退出页面通知
static NSString * _Nullable const JHGrowingNotify_ArgicleDetailOut = @"JHGrowingNotifyArgicleDetailOut";

///所有页面 - 浏览时长统计通知
static NSString * _Nullable const JHGrowingNotify_AllPageBrowseDuration = @"JHGrowingNotifyAllPageBrowseDuration";


NS_ASSUME_NONNULL_BEGIN

@class JHDiscoverChannelModel;

@interface GrowingManager : NSObject

+ (NSString *)getDeviceId;

#pragma mark -
#pragma mark - 文章页统计

///文章页 - 进入
+ (void)articleDetailEnter:(NSDictionary *)params;
///文章页 - 浏览时长
+ (void)articleBrowseDuration:(NSDictionary *)params;
///文章页 - 退出
+ (void)articleDetailOut:(NSDictionary *)params;
///文章页 - 点赞
+ (void)articleDetailLike:(NSDictionary *)params;
///文章页 - 取消点赞
+ (void)articleDetailUnLike:(NSDictionary *)params;
///文章页 - 双击点赞
+ (void)articleDetailDoubleLike:(NSDictionary *)params;
///文章页 - 关注发布者
+ (void)articleDetailFollowPublisher:(NSDictionary *)params;
///文章页 - 取消关注发布者
+ (void)articleDetailUnFollowPublisher:(NSDictionary *)params;
///文章页 - 点击咨询购买
+ (void)articleDetailCommodityAsk:(NSDictionary *)params;
///文章页 - 立即购买（热卖）
+ (void)articleDetailCommodityBuy:(NSDictionary *)params;
///文章页 - 弹出评论弹框(点击输入框弹出)
+ (void)articleDetailCommentPanel:(NSDictionary *)params;
///文章页 - 发布评论
+ (void)articleDetailCommentPost:(NSDictionary *)params;
///文章页 - 弹出分享弹框
+ (void)articleDetailSharePanel:(NSDictionary *)params;
///文章页 - 分享完成
+ (void)articleDetailShareComplete:(NSDictionary *)params;
///文章页 - 点击举报（点击分享框中的举报）
+ (void)articleDetailShareReportClicked:(NSDictionary *)params;
///文章页 - 点击删除（点击分享框中的删除）
+ (void)articleDetailShareDeleteClicked:(NSDictionary *)params;
///文章页 - 评论区 弹出回复弹框（评论区选择回复）
+ (void)articleDetailCommentShowReply:(NSDictionary *)params;
///文章页 - 评论区 发布回复
+ (void)articleDetailCommentReplyPost:(NSDictionary *)params;
///文章页 - 评论区 点击复制
+ (void)articleDetailCommentCopyClicked:(NSDictionary *)params;
///文章页 - 评论区 点赞
+ (void)articleDetailCommentLike:(NSDictionary *)params;
///文章页 - 评论区 取消点赞
+ (void)articleDetailCommentUnLike:(NSDictionary *)params;
///文章页 - 评论区 点击举报
+ (void)articleDetailCommentReportClicked:(NSDictionary *)params;
///文章页 - 评论区 点击删除
+ (void)articleDetailCommentDeleteClicked:(NSDictionary *)params;


#pragma mark -
#pragma mark - 社区首页统计

///社区首页 - 切换Tab
+ (void)homeSwitchTab:(NSDictionary *)params;
///点击发布加号
+ (void)homePublishBtnClick:(NSDictionary *)params;
///社区首页 - 选择了频道
+ (void)homeSelectedChannel:(NSArray<JHDiscoverChannelModel *> *)channelList;
///社区首页 - 切换频道
+ (void)homeChannelSwitch:(NSDictionary *)params;
///社区首页 - 文章item - 点赞
+ (void)homeArticleItemLike:(NSDictionary *)params;
///社区首页 - 文章item - 取消点赞
+ (void)homeArticleItemUnLike:(NSDictionary *)params;
///社区首页 - 文章item - 点击普通广告
+ (void)homeArticleItemAdClicked:(NSDictionary *)params;
///发布帖子
+ (void)homePublishArticle:(NSDictionary *)params;
///点击首页顶部搜索
+ (void)homeSearchBarClicked:(NSDictionary *)params;
//app从前台到后台再到前台的时间差埋点
+ (void)appEnterForeround;
///app进入前台记录时间
+ (void)appEnterForeroundRecordTime;
///页面被创建
+ (void)appViewControllerCreate:(NSDictionary *)params;
///页面被关闭
+ (void)appViewControllerClose:(NSDictionary *)params;
///页面被展示
+ (void)appViewWillAppear:(NSDictionary *)params;
///页面浏览时长
+ (void)appViewPageBrowse:(NSDictionary *)params;


#pragma mark -
#pragma mark - 商城埋点

///点击首页橱窗列表商品
+ (void)clickStoreHomeShopWindowGoods:(NSDictionary *)params;
///点击首页专题列表项
+ (void)clickedStoreHomeList:(NSDictionary *)params;
///点击商城首页下面分类tab
+ (void)clickStoreHomeListCategory:(NSDictionary *)params;
///点击商城首页下面分类tab下面商品
+ (void)clickedStoreHomeListCategoryGoods:(NSDictionary *)params;
///进入店铺：无论从哪里进都要统计
+ (void)enterShopHomePage:(NSDictionary *)params;
///进入店铺：点击商城首页橱窗(专题)进入商品详情，再从详情进入店铺
+ (void)enterShopHomeFromWindowList:(NSDictionary *)params;
///商品分类筛选页一级分类点击
+ (void)clickCateOnLevelOne:(NSDictionary *)params;
///商品分类筛选页三级分类点击
+ (void)clickCateOnLevelThree:(NSDictionary *)params;

///搜索页搜索按钮点击
+ (void)clickSearchButton:(NSDictionary *)params;

///搜索结果页商品点击
+ (void)clickSearchResultGoods:(NSDictionary *)params;

#pragma mark -
#pragma mark - 分流引导页
///进入分流引导页次数
+ (void)showGuidePage:(NSDictionary *)params;
///点击进入免费鉴定
+ (void)authenticateClick:(NSDictionary *)params;
///点击进入源头直购
+ (void)storePageClick:(NSDictionary *)params;
///点击和宝友聊聊
+ (void)chatWithCowryClick:(NSDictionary *)params;
///显示红包弹窗用户数
+ (void)showRedbagPage:(NSDictionary *)params;
///点击领取红包
+ (void)grawRedbagClick:(NSDictionary *)params;
///点击取消红包
+ (void)cancelRedbagClick:(NSDictionary *)params;
///显示礼物界面
+ (void)showGiftPage:(NSDictionary *)params;
///点击收下礼物
+ (void)furlGiftBtnClick:(NSDictionary *)params;
///点击取消礼物
+ (void)cancelGiftClick:(NSDictionary *)params;
///商品详情页 - 进入客服页
+ (void)goodsDetailClickedService:(NSDictionary *)params;

///2.5新增埋点
///商品详情页推荐列表商品点击事件
+ (void)recommendCommoditiesGoodsClick:(NSDictionary*)params;

///进入直播间埋点
+ (void)enterLiveArchorClick:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
