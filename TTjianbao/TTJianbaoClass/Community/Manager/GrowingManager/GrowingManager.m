//
//  GrowingManager.m
//  TTjianbao
//
//  Created by wuyd on 2019/10/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "GrowingManager.h"
#import "JHDiscoverChannelModel.h"
#import "TTjianbaoHeader.h"


///记录app退到后台时的时间
#define kAppEnterBackgroundTimeIdentifer  @"kAppEnterBackgroundTimeIdentifer"

@implementation GrowingManager

///获取设备号
+ (NSString *)getDeviceId {
    return [Growing getDeviceId];
}

+ (void)load {
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:JHGrowingNotify_ArgicleBrowse object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        NSDictionary *params = notification.userInfo[@"params"];
        [self articleBrowseDuration:params];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:JHGrowingNotify_ArgicleDetailOut object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        NSDictionary *params = notification.userInfo[@"params"];
        [self articleDetailOut:params];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:JHGrowingNotify_AllPageBrowseDuration object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        NSDictionary *params = notification.userInfo; //直接接收字典
        [self appViewPageBrowse:params];
    }];
    
}

#pragma mark -
#pragma mark - 文章页统计

//文章页 - 进入
+ (void)articleDetailEnter:(NSDictionary *)params {
    [Growing track:@"article_detail_in" withVariable:params];
}

//文章页 - 浏览时长
+ (void)articleBrowseDuration:(NSDictionary *)params {
    [Growing track:@"article_detail_browse" withVariable:params];
}

//文章页 - 退出
+ (void)articleDetailOut:(NSDictionary *)params {
    [Growing track:@"article_detail_out" withVariable:params];
}

//文章页 - 点赞
+ (void)articleDetailLike:(NSDictionary *)params {
    [Growing track:@"article_detail_like" withVariable:params];
}

//文章页 - 取消点赞
+ (void)articleDetailUnLike:(NSDictionary *)params {
    [Growing track:@"article_detail_unlike" withVariable:params];
}

//文章页 - 双击点赞
+ (void)articleDetailDoubleLike:(NSDictionary *)params {
    [Growing track:@"article_detail_double_like" withVariable:params];
}

//文章页 - 关注发布者
+ (void)articleDetailFollowPublisher:(NSDictionary *)params {
    [Growing track:@"article_detail_publisher_follow" withVariable:params];
}

//文章页 - 取消关注发布者
+ (void)articleDetailUnFollowPublisher:(NSDictionary *)params {
    [Growing track:@"article_detail_publisher_unfollow" withVariable:params];
}

//文章页 - 点击咨询购买
+ (void)articleDetailCommodityAsk:(NSDictionary *)params {
    [Growing track:@"article_detail_commodity_ask" withVariable:params];
}

//文章页 - 立即购买（热卖）
+ (void)articleDetailCommodityBuy:(NSDictionary *)params {
    [Growing track:@"article_detail_commodity_buy" withVariable:params];
}

//文章页 - 评论弹框 弹出评论弹框(点击输入框弹出)
+ (void)articleDetailCommentPanel:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_dialog" withVariable:params];
}

//文章页 - 发布评论
+ (void)articleDetailCommentPost:(NSDictionary *)params {
    [Growing track:@"article_detail_comment" withVariable:params];
}

//文章页 - 弹出分享弹框
+ (void)articleDetailSharePanel:(NSDictionary *)params {
    [Growing track:@"article_detail_share_dialog" withVariable:params];
}

//文章页 - 分享完成
+ (void)articleDetailShareComplete:(NSDictionary *)params {
    [Growing track:@"article_detail_share" withVariable:params];
}

//文章页 - 点击举报（点击分享框中的举报）
+ (void)articleDetailShareReportClicked:(NSDictionary *)params {
    [Growing track:@"article_detail_report_click" withVariable:params];
}

//文章页 - 点击删除（点击分享框中的删除）
+ (void)articleDetailShareDeleteClicked:(NSDictionary *)params {
    [Growing track:@"article_detail_delete_click" withVariable:params];
}

//文章页 - 评论区 弹出回复弹框（评论区选择回复）
+ (void)articleDetailCommentShowReply:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_reply_dialog" withVariable:params];
}

//文章页 - 评论区 发布回复
+ (void)articleDetailCommentReplyPost:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_reply" withVariable:params];
}

//文章页 - 评论区 点击复制
+ (void)articleDetailCommentCopyClicked:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_copy" withVariable:params];
}

//文章页 - 评论区 点赞
+ (void)articleDetailCommentLike:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_like" withVariable:params];
}

//文章页 - 评论区 取消点赞
+ (void)articleDetailCommentUnLike:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_unlike" withVariable:params];
}

//文章页 - 评论区 点击举报
+ (void)articleDetailCommentReportClicked:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_report_click" withVariable:params];
}

//文章页 - 评论区 点击删除
+ (void)articleDetailCommentDeleteClicked:(NSDictionary *)params {
    [Growing track:@"article_detail_comment_delete_click" withVariable:params];
}


#pragma mark -
#pragma mark - 社区首页统计

///社区首页 - 切换Tab
+ (void)homeSwitchTab:(NSDictionary *)params {
    [Growing track:@"home_switch_tab" withVariable:params];
}

///点击发布加号
+ (void)homePublishBtnClick:(NSDictionary *)params {
    [Growing track:@"home_publish_click" withVariable:params];
}

///选择了频道
+ (void)homeSelectedChannel:(NSArray<JHDiscoverChannelModel *> *)channelList {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    [params setObject:userId ? userId : @"" forKey:@"userId"];
    [params setObject:@([[YDHelper get13TimeStamp] longLongValue]) forKey:@"time"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        for (JHDiscoverChannelModel *model in channelList) {
            if (model.channel_id != -1 && model.channel_id != -2) {
                NSString *keyStr = [NSString stringWithFormat:@"id_%ld", (long)model.channel_id];
                [params setValue:model.channel_name forKey:keyStr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Growing track:@"channel_select_submit" withVariable:params];
        });
    });
}

///社区首页 - 切换频道
+ (void)homeChannelSwitch:(NSDictionary *)params {
    /**
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    [params setObject:userId ? userId : @"" forKey:@"userId"];
    [params setObject:@([[YDHelper get13TimeStamp] longLongValue]) forKey:@"time"];
    */
    [Growing track:JHTrackSQClickChannelCate withVariable:params];
}

///社区首页 - 文章item - 点赞
+ (void)homeArticleItemLike:(NSDictionary *)params {
    [Growing track:@"home_social_article_item_like" withVariable:params];
}

///社区首页 - 文章item - 取消点赞
+ (void)homeArticleItemUnLike:(NSDictionary *)params {
    [Growing track:@"home_social_article_item_unlike" withVariable:params];
}

///社区首页 - 文章item - 点击普通广告
+ (void)homeArticleItemAdClicked:(NSDictionary *)params {
    [Growing track:@"home_social_article_item_ad_click" withVariable:params];
}

///点击发布 - 发布帖子
+ (void)homePublishArticle:(NSDictionary *)params {
    [Growing track:@"publish_submit" withVariable:params];
}

///点击首页顶部搜索
+ (void)homeSearchBarClicked:(NSDictionary *)params {
    [Growing track:JHTrackSQHomeClickSearchBar withVariable:params];
}

//app从前台到后台再到前台的时间差埋点
+ (void)appEnterForeround:(NSDictionary *)params {
    [Growing track:@"page_browse" withVariable:params];
}

//app从前台到后台再到前台的时间差埋点
+ (void)appEnterForeround {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
       NSString *quitTimeStr = [user objectForKey:kAppEnterBackgroundTimeIdentifer];
       if (!quitTimeStr) {
           return;
       }
       NSTimeInterval timeInterval = fabs([CommHelp dateRemaining:quitTimeStr]);
       
       NSString *currentVCName = NSStringFromClass([[JHRootController currentViewController] class]);
       /// 前台 -- 后台 -- 前台 埋点
       NSDictionary *params = @{
           @"duration" : @(timeInterval),
           @"page_name" : currentVCName,
           @"page_full_name" : @""
       };
    if(params)
        [Growing track:@"page_browse" withVariable:params];
}

///app进入前台记录时间
+ (void)appEnterForeroundRecordTime
{
    NSString *quitTimeStr = [NSDate stringFromDate:[CommHelp getCurrentTrueDate] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:quitTimeStr forKey:kAppEnterBackgroundTimeIdentifer];
    [user synchronize];
}

///页面被创建
+ (void)appViewControllerCreate:(NSDictionary *)params {
    [Growing track:@"page_create" withVariable:params];
}

///页面被关闭统计
+ (void)appViewControllerClose:(NSDictionary *)params {
    [Growing track:@"page_destroy" withVariable:params];
}

///页面被展示
+ (void)appViewWillAppear:(NSDictionary *)params {
    [Growing track:@"page_enable" withVariable:params];
}

///页面浏览时长
+ (void)appViewPageBrowse:(NSDictionary *)params {
    NSLog(@"page_browse:%@", params);
    [Growing track:@"page_browse" withVariable:params];
}


#pragma mark -
#pragma mark - 商城埋点

///点击橱窗列表项
+ (void)clickStoreHomeShopWindowGoods:(NSDictionary *)params {
    [Growing track:@"market_sale_showcase_item_click" withVariable:params];
}

///点击专题列表项
+ (void)clickedStoreHomeList:(NSDictionary *)params {
    [Growing track:@"market_sale_special_topic_item_click" withVariable:params];
}

///商品详情页 - 进入客服页
+ (void)goodsDetailClickedService:(NSDictionary *)params {
    [Growing track:@"market_sale_commodity_detail_ask" withVariable:params];
}

///商城首页下面分类tab点击事件
+ (void)clickStoreHomeListCategory:(NSDictionary *)params {
    [Growing track:@"limitstore_home_cate_tab_click" withVariable:params];
}

///商城首页下面分类tab下面商品点击事件
+ (void)clickedStoreHomeListCategoryGoods:(NSDictionary *)params {
    [Growing track:@"limitstore_home_cate_tab_goods_click" withVariable:params];
}

///进入店铺
+ (void)enterShopHomePage:(NSDictionary *)params {
    [Growing track:@"enter_storeshop_event" withVariable:params];
}

///进入店铺：点击商城首页橱窗(专题)进入商品详情，再从详情进入店铺
+ (void)enterShopHomeFromWindowList:(NSDictionary *)params {
    [Growing track:@"enter_storeshop_fromtopic_event" withVariable:params];
}

///商品分类筛选页一级分类点击
+ (void)clickCateOnLevelOne:(NSDictionary *)params {
    [Growing track:@"limitstore_cate_page_firstcate_click" withVariable:params];
}
///商品分类筛选页三级分类点击
+ (void)clickCateOnLevelThree:(NSDictionary *)params {
    [Growing track:@"limitstore_cate_page_thirdcate_click" withVariable:params];
}

///搜索页搜索按钮点击
+ (void)clickSearchButton:(NSDictionary *)params {
    NSLog(@"搜索页搜索按钮点击params:-%@", params);
    [Growing track:@"limitstore_search_btn_click" withVariable:params];
}

///搜索结果页商品点击
+ (void)clickSearchResultGoods:(NSDictionary *)params {
    [Growing track:@"limitstore_search_resultpage_goods_click" withVariable:params];
}


#pragma mark -
#pragma mark - 分流引导页埋点
///进入分流引导页次数
+ (void)showGuidePage:(NSDictionary *)params {
    [Growing track:@"guide_enter_times" withVariable:params];
}

///点击进入免费鉴定
+ (void)authenticateClick:(NSDictionary *)params {
    [Growing track:@"guide_free_authenticate_click" withVariable:params];
}

///点击进入源头直购
+ (void)storePageClick:(NSDictionary *)params {
    [Growing track:@"guide_store_page_click" withVariable:params];
}

///点击和宝友聊聊
+ (void)chatWithCowryClick:(NSDictionary *)params {
    [Growing track:@"guide_chat_with_cowry_click" withVariable:params];
}

///显示红包弹窗用户数
+ (void)showRedbagPage:(NSDictionary *)params {
    [Growing track:@"store_show_redbag_times" withVariable:params];
}

///点击领取红包
+ (void)grawRedbagClick:(NSDictionary *)params {
    [Growing track:@"store_draw_redbag_btn_click" withVariable:params];
}

///点击取消红包
+ (void)cancelRedbagClick:(NSDictionary *)params {
    [Growing track:@"store_cancel_redbag_btn_click" withVariable:params];
}

///显示礼物界面
+ (void)showGiftPage:(NSDictionary *)params {
    [Growing track:@"auth_show_gift_page_times" withVariable:params];
}

///点击收下礼物
+ (void)furlGiftBtnClick:(NSDictionary *)params {
    [Growing track:@"auth_furl_gift_btn_click" withVariable:params];
}

///点击取消礼物
+ (void)cancelGiftClick:(NSDictionary *)params {
    [Growing track:@"auth_cancel_gift_btn_click" withVariable:params];
}

///商品详情页推荐列表商品点击事件
+ (void)recommendCommoditiesGoodsClick:(NSDictionary*)params {
    [Growing track:@"recommendCommodities_goods_click" withVariable:params];
}

///进入直播间
+ (void)enterLiveArchorClick:(NSDictionary *)params {
    [Growing track:@"mv_live_in" withVariable:params];
}


@end
