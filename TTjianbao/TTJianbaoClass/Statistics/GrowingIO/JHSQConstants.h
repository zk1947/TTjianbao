//
//  JHSQConstants.h
//  TTjianbao
//
//  Created by wuyd on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  GrowingIO埋点 - 社区相关
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///入口类型 EntryType：
typedef NS_ENUM(NSInteger, JHEntryType) {
    ///0.未定义
    JHEntryType_None = 0,
    ///1.社区首页（3.1.6新版为关注页、发现页）
    JHEntryType_SQ_Home = 1,
    ///2.个人中心列表
    JHEntryType_Person_Center = 2,
    ///3.社区关键词搜索结果页
    JHEntryType_SQ_Search_Result = 3,
    ///4.文章详情页推荐列表
    JHEntryType_SQ_Detail_Rcmd_List = 4,
    ///5.话题详情页推荐列表（热门、最新）
    JHEntryType_Topic_Detail_List = 5,
    ///6.从话题首页特卖列表进入（话题页热卖列表）
    JHEntryType_Topic_Home_Sale_List = 6,
    ///7.从全部特卖列表进入
    JHEntryType_All_Sale_List = 7,
    ///8-社区搜索页的推荐话题
    JHEntryType_SQ_Search_Topic_List = 8,
    ///9.商家店铺列表
    JHEntryType_Stop_Home_List = 9,
    ///10-社区首页 - 推荐话题列表
    JHEntryType_SQ_Home_Topic_List = 10,
    ///11-全部话题列表页（旧）
    JHEntryType_All_Topic_List = 11,
    ///12-鉴定师回帖列表（旧）
    JHEntryType_Appraiser_Reply_List = 12
};


#pragma mark -
#pragma mark - 埋点事件id

//static NSString * _Nullable const JHString = @"";

//社区316
static NSString *const JHTrackSQHomeSwitchTab = @"social_switch_tab"; //tab切换（关注/发现标签）
static NSString *const JHTrackSQHomeClickSearchBar = @"home_social_search_click"; //点击搜索按钮
static NSString *const JHTrackSQIntoSearchResult = @"home_social_result_in"; //进⼊搜索结果⻚事件
static NSString *const JHTrackSQIntoGoodsDetail = @"saleWareDetailViewStart"; //社区搜索结果 > 进入商品详情事件
static NSString *const JHTrackSQClickChannelCate = @"home_social_channel_switch"; //分类点击  >>>homeChannelSwitch
static NSString *const JHTrackSQIntoPublish = @"social_publish_in"; //进⼊发帖⻚⾯
static NSString *const JHTrackSQIntoCommentDialog = @"social_detail_comment_dialog"; //进⼊评论⻚事件(评论弹框列表)
static NSString *const JHTrackSQCommentSendClick = @"social_detail_comment_send"; //社区关注⻚评论框发送按钮点击
static NSString *const JHTrackSQShareDialog = @"share_dialog"; //显示分享弹框
static NSString *const JHTrackSQShareSuccess = @"share_success"; //第三⽅分享成功
static NSString *const JHTrackSQArticleLike = @"social_article_like"; //社区⽂章点赞
static NSString *const JHTrackSQArticleUnlike = @"social_article_unlike"; //社区⽂章取消点赞
static NSString *const JHTrackSQArticleDoubleLike = @"social_article_double_like"; //社区⽂章双击点赞
static NSString *const JHTrackSQIntoUserHomePage = @"social_friend_centre_in"; //进⼊宝友主⻚
static NSString *const JHTrackSQIntoAppraiserHomePage = @"assayerprofile"; //进⼊鉴定师主⻚<JHEventAssayerprofile>
static NSString *const JHTrackSQIntoTopicPage = @"sqTopicPage"; //话题页进入事件


#pragma mark -
#pragma mark - 来源

//----------------首页4个tab主页----------------
/*!社区主页*/
static NSString *const JHFromHomeCommunity = @"homeCommunity";
/*!v3.3.0新增社区首页推荐列表*/
static NSString *const JHFromSQHomeFeedList = @"communityFeedList";
/*!源头直购主页*/
static NSString *const JHFromHomeSourceBuy = @"homeSourceBuy";
/*!在线鉴定主页*/
static NSString *const JHFromHomeIdentity = @"homeIdentify";
/*!个人中心主页*/
static NSString *const JHFromHomePersonal = @"homePersonal";

/*!社区首页关注列表*/
static NSString *const JHFromSQHomePageFollow = @"communityHomeFollow";
/*!tabBar加号按钮*/
static NSString *const JHFromSQHomePublish = @"communityHomePlusDialog";
/*!社区用户主页*/
static NSString *const JHFromUserInfo = @"socialClerkCenter";
/*!社区图文详情*/
static NSString *const JHFromSQPicDetail = @"socialArticleImgDetail";
/*!社区视频详情*/
static NSString *const JHFromSQVideoDetail = @"socialArticleVideoDetail";
/*!社区长文章详情*/
static NSString *const JHFromSQPostDetail = @"socialArticlePostDetail";
/*!社区首页搜索框 */
static NSString *const JHFromSQSearchBar = @"socialSearchInputBox";
/*!社区搜索结果页 */
static NSString *const JHFromSQSearchResult = @"socialSearchResult";
/*!社区话题详情*/
static NSString *const JHFromSQTopicDetail = @"communityTopicDetail";

///340埋点
/*!板块首页*/
static NSString *const JHFromSQPlateList = @"communityPlateList";
/*!板块详情页*/
static NSString *const JHFromSQPlateDetail = @"communityPlateDetail";

/*!收藏列表页*/
static NSString *const JHFromCollectList = @"collectList";

/*!热帖列表页*/
static NSString *const JHFromHotArticleList = @"hotArticleList";

/*!未定义*/
static NSString *const JHFromUndefined = @"undefined";



@interface JHSQConstants : NSObject

@end

NS_ASSUME_NONNULL_END
