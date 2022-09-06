//
//  TTjianbaoMarcoKeyword.h
//  TTjianbao
//  Description:keyword、string等 ~头文件
//  Created by Jesse on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#ifndef TTjianbaoMarcoKeyword_h
#define TTjianbaoMarcoKeyword_h

/**电子签约认证信息加/解密的key*/
#define SIGN_AES_KEY        @"#uDanplD#Zv9%wlM"
#define SIGN_AES_IV_KEY     @"0x8vIDvzBrZAF472"

/** 登录 */
#define LOGINSTATUS          @"Loginstatus"
#define ONLINE               @"online"
#define OFFLINE               @"offline"
#define IDTOKEN         @"idToken"
#define Gen_Session_Id         @"Gen_Session_Id"

#define FirstNet         @"firstNet"
#define FirstNetNotifaction         @"FirstNetNotifaction"

#define SHOWFREEAPPRAISELASTTIME         @"showFreeAppraiseLastTime"
#define LASTDATE         @"lastDate"
#define LiveLASTDATE         @"LivelastDate"
#define AppraiseIssueLastDate         @"AppraiseIssueLastDate"
#define AlipayScheme       @"Ali.com.yiding.jianhuo"

#define MallBannerData       @"MallBannerData"
#define MallLivesData       @"MallLivesData"
#define AppraisalLivesData      @"AppraisalLivesData"
#define AppraisalRecordData       @"AppraisalRecordData"
///鉴定记录本地草稿信息
#define kAppraisalRecordRemarkData       @"kAppraisalRecordRemarkData"
#define CateData       @"CateData"
#define MallCateData       @"MallCateData"
#define LiveSDK @"LiveSDK"

///发布帖子传递参数>>>
#define sendUploadDatasIdentifer        @"sendUploadDatasIdentifer"
#define cancelUploadArticleIdnetifer    @"cancelUploadArticleIdnetifer"

//@import TXLiteAVSDK_UGC;？？？？？？

#define kAttentionStampTime @"kAttentionStampTime"
#define kAppearRedHotKey @"kAppearRedHotKey"

#define ChannelDeviceFileData @"ChannelFiledData"
#define ChannelUserFileData @"ChannelUserFileData"

///首页是否为社区
#define kShowSQ    @"showSQ"

//是否关闭浮窗直播
#define kFloatWindowLiveClose    @"kFloatWindowLiveClose"

///是否关闭个性推荐
#define NSUserDefaultsServerRecommendCloseSwitch    @"NSUserDefaultsServerRecommendCloseSwitch"

///个性推荐状态
#define IS_OPEN_RECOMMEND (![[NSUserDefaults standardUserDefaults] boolForKey:NSUserDefaultsServerRecommendCloseSwitch])

///签到有礼key
#define kNewUserCheckIn  @"kNewUserCheckInKey"

///新用户今天是否第一次展示红包/礼物界面
#define kNewUserFirstRedbagKey  @"kNewUserFirstRedbagKey"
#define kNewUserFirstGiftKey    @"kNewUserFirstGiftKey"

///新用户是否领取礼物
#define kWetherGrantGiftKey     @"kWetherGrantGiftKey"
#define kWetherGrantRedbagKey   @"kWetherGrantRedbagKey"

#define kLoginedFirstRedbagKey   @"kLoginedFirstRedbagKey"
#define kLoginedFirstGiftKey   @"kLoginedFirstGiftKey"

#define kMallWatchTrackKey    @"kMallWatchTrackKey"

#define PRICE_FLOAT_TO_STRING(price) [NSString stringWithFormat:@"%.2f",price]

#define NUMBRR_TO_STRING(NUM) [NSString stringWithFormat:@"%@",NUM]

///每隔4小时请求一次  对公认证发起交易
#define kSignContractFourHourKey   @"kSignContractFourHourKey"

///暂时不用  --- lh  后期可能会用到 目前为了增减用户互动次数 改成每次进入视频帖都提醒 后期会加上限制
//#define kDiscoverVideoDetailBubbleKey  @"kDiscoverVideoDetailBubbleKey"

///直播间新手引导  323新增
///申请鉴定引导
#define kGuideRoomAppraise   @"GuideRoomAppraise"
///与主播询价引导
#define kGuideRoomSellSayWhat   @"GuideRoomSellSayWhat"

///99包邮 每次进入app展示一次 后面不展示 杀死app 每次重新进入app时都需要弹
#define k99FreeEnterForeGroundShow  @"99FreeEnterForeGroundShow"
#define kShowAdversePage  @"kShowAdversePage"

///第一次进入直播间的新手引导
#define kFirstEnterLiveRoomKey   @"isFirstTimeInNTESAudienceLiveRoom"

#define kUnionPayForeverTimeKey  @"9999-12-31"

#endif /* TTjianbaoMarcoKeyword_h */
