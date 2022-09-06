//
//  TTjianbaoMarcoEnum.h
//  TTjianbao
//  Description:enum、typedef等 ~头文件
//  Created by Jesse on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#ifndef TTjianbaoMarcoEnum_h
#define TTjianbaoMarcoEnum_h

typedef NS_ENUM(NSInteger, JHLoginType)
{
    JHLoginTypePhoneNumber = 1,    //手机号登录
    JHLoginTypeQQ  = 2,    //QQ
    JHLoginTypeWeiChat  = 3,
};

typedef NS_ENUM(NSInteger, JHOrderButtonType)
{
    JHOrderButtonTypeCommit = 0,
    JHOrderButtonTypePay ,
    JHOrderButtonTypeCancle  ,
    JHOrderButtonTypeContact ,
    JHOrderButtonTypeLogistics ,
    JHOrderButtonTypeDetail ,
    JHOrderButtonTypeReceive,
    JHOrderButtonTypeSend,
    JHOrderButtonTypeComment,
    JHOrderButtonTypeLookComment,
    JHOrderButtonTypeBindCard,
    JHOrderButtonTypeReturnGood,
    JHOrderButtonTypeQuestionDetail,
    JHOrderButtonTypeOrderDetail,
    JHOrderButtonTypeAlterAddress,
    JHOrderButtonTypeReturnDetail,
    JHOrderButtonTypeAppraiseIssue,
    JHOrderButtonTypeAddNote,
    JHOrderButtonTypeApplyReturn,
    JHOrderButtonTypePrintCard,
    JHOrderButtonTypeCompleteInfo,
    JHOrderButtonTypeAccountDetail,
    JHOrderButtonTyperRemindSend,
     JHOrderButtonTyperStoneResell,//转售
     JHOrderButtonTyperStoneReselling,//转售中
    JHOrderButtonTyperDelete,//删除
    JHOrderButtonTyperApplyCustomize,//申请定制
};

typedef NS_ENUM(NSInteger, JHMediaType)
{
    JHMediaTypeLiveStream = 0,
    JHMediaTypeVideoStream
};

typedef NS_ENUM(NSInteger, JHPayType)
{
    JHPayTypeWxPay = 1,
    JHPayTypeAliPay=3,
    JHPayTypeBank=5,
    JHPayTypeAgentPay=9
};

typedef NS_ENUM(NSInteger, JHItemType) {
    
    JHItemType_Article = 1, // 文章
    JHItemType_Commodity,//商品
    JHItemType_Comment,//评论
    JHItemType_Reply,//回复
    JHItemType_Friend,//宝友
};

typedef NS_ENUM(NSInteger, JHStoneMainListType) {
    
    JHStoneMainListTypeStoneLive = 1, // 回血直播间
    JHStoneMainListTypeStoneSale= 2,//寄售原石列表（寄售）
    JHStoneMainListTypeStoneSold= 3,//寄售原石列表（已售）
    JHStoneMainListTypeStoneResell= 4,//个人转售
};

typedef NS_ENUM(NSInteger, JHOrderStatus) {
    JHOrderStatusWaitack= 1,//待确认
    JHOrderStatusWaitpay,//待付款
    JHOrderStatusWaitsellersend,//待发货
    JHOrderStatusSellersent,//卖家已发货（待平台收货)
    JHOrderStatusWaitportalappraise,//待鉴定（平台已收货）
    JHOrderStatusWaitportalsend,//平台已鉴定（待发货)
    JHOrderStatusPortalsent,//待收货
    JHOrderStatusbuyerreceived,//已完成
    JHOrderStatusCancel ,//已取消
    JHOrderStatusCustomize ,//定制中
};

typedef NS_ENUM(NSInteger, JHOrderCategory) {
    JHOrderCategoryNormal = 1, //("常规订单")
    JHOrderCategoryProcessing,//加工
    JHOrderCategoryProcessingGoods,//加工服务单
    JHOrderCategoryRough,//原石单
    JHOrderCategoryGift,//福利单
    JHOrderCategoryDaiGou,//代购单
    JHOrderCategoryLimitedTime,//限时特卖订单
    JHOrderCategoryLimitedShop,//店铺特卖订单
    JHOrderCategoryTopic,//话题特卖订单
    JHOrderCategoryRestore,//原石回血订单
    JHOrderCategoryRestoreIntention,//原石回血意向金订单
    JHOrderCategoryRestoreProcessing,//回血加工服务订单
    JHOrderCategoryRestoreZero,//回血0元订单   ** 暂时未用
//   JHOrderCategoryExpress,//运费单  ** 暂时未用
    JHOrderCategoryResaleOrder,//个人转售订单
    JHOrderCategoryResaleIntentionOrder,//个人转售意向金订单
    JHOrderCategoryCustomizedOrder,//定制服务单
    JHOrderCategoryCustomizedIntentionOrder,//定制服务意向金订单
    JHOrderCategoryPersonalCustomizeOrder,//新定制类型订单
    JHOrderCategoryPersonalCustomizePackageOrder,//新增 定制套餐捆绑订单 **本地用的，不是服务器返的
    JHOrderCategoryMallOrder,//精品改版商城
    JHOrderCategoryMarketsell,
};

typedef NS_ENUM(NSInteger, JHOrderType) {
    JHOrderTypeLive = 0, //直播
    JHOrderTypecommunity= 1,//社区
    JHOrderTypeRestore= 3,//回血
    JHOrderTypeMall= 4,//商城
    JHOrderTypeStoneResell= 5,//个人转售
    JHOrderTypeshopWindow= 6,//橱窗
    JHOrderTypeCustomize= 7,//定制单
    JHOrderTypeNewStore= 9,//新商城,
    JHOrderTypeMarketsell = 11, //C2C集市订单

};
///网络请求状态码
typedef NS_ENUM(NSInteger, JHDataCode) {
    JHDataCodeSuccess = 1000,           ///成功
    JHDataCodeFailure = 1002,           ///失败
    JHDataCodeIsSpecialSale = 40005,    ///是否为特卖商家
};

/// 签约状态
typedef NS_ENUM(NSInteger, JHUnionSignStatus)
{
    /// 未签约
    JHUnionSignStatusUnSign = 0,
    /// 审核中
    JHUnionSignStatusReviewing,
    /// 签约完成
    JHUnionSignStatusComplete,
    /// 签约失败
    JHUnionSignStatusFail,
    /// 签约中
    JHUnionSignStatusSigning,
    /// 对公账户等待验证
    JHUnionSignStatusWaitAuth,
};

//社区帖：layout
typedef NS_ENUM(NSInteger, JHSQLayoutType) {
    JHSQLayoutTypeImageText = 1,//1社区内容天贴-图文详情
    JHSQLayoutTypeVideo = 2,//2社区视频
    JHSQLayoutTypeAppraisalVideo = 3,//3鉴定视频
    JHSQLayoutTypeAD = 4,//4运营广告
    JHSQLayoutTypeLiveStore = 5,//5直播卖场
    JHSQLayoutTypeTopic = 6, //话题样式 - 2.1.0新增 - 背景图+文字+描述
    JHSQLayoutTypeStoreGoods = 7, //商城商品【没用到】
};

//社区贴：item_type（老版本 3.3.0之前）
typedef NS_ENUM(NSInteger, JHSQItemType) {
    JHSQItemTypeArticle = 1,//PGC、UGC发布的帖子文章
    JHSQItemTypeGoods = 2,//2可售贴 商品？
    JHSQItemTypeAD = 6, //广告位和卖场直播（卖场直播间在帖子列表作为广告存在）
    JHSQItemTypeTopic = 7, //话题
    JHSQItemTypeVote = 8, //投票帖
    JHSQItemTypeStoreGoods = 9, //商城商品【没用到】
    JHSQItemTypeGuess = 10, //猜价贴
    
    /**动态*/
    JHSQItemTypeDynamic = 20,
    /**帖子<图文贴：图片+视频+长文本>*/
    JHSQItemTypePost = 30,
    /**短视频*/
    JHSQItemTypeVideo = 40,
};


#pragma mark - 3.3.0 2020.06

//社区贴item_type（3.3.0改版后）
typedef NS_ENUM(NSInteger, JHPostItemType) {
    /**鉴定视频*/
    JHPostItemTypeAppraisalVideo = 1,
    /**广告*/
    JHPostItemTypeAD = 6,
    /**话题*/
    JHPostItemTypeTopic = 7,
    /**动态*/
    JHPostItemTypeDynamic = 20,
    /**帖子<图文贴：图片+视频+长文本>*/
    JHPostItemTypePost = 30,
    /**短视频*/
    JHPostItemTypeVideo = 40,
    /**直播间*/
    JHPostItemTypeLiveRoom = 61,
    /**随机版块集合位置*/
    JHPostItemTypeRandomPlate = 1000,
    /**本地刚刚发布的帖子*/
    JHPostItemTypeLocalPost = 1001,
    /**随机话题集合位置*/
    JHPostItemTypeRandomTopic = 1002,
};

//用户类型role（3.3.0改版后）
//typedef NS_ENUM(NSInteger, JHRoleType) {
//    /**普通用户*/
//    JHRoleTypeNone = 0,
//    /**鉴定主播*/
//    JHRoleTypeAppraiserAnchor = 1,
//    /**卖货主播*/
//    JHRoleTypeSellerAnchor = 2,
//    /**主播助理*/
//    JHRoleTypeAnchorAsst = 3,
//    /**社区商户*/
//    JHRoleTypeSQMerchant = 4,
//    /**马甲号*/
//    JHRoleTypeMaJia = 5,
//    /**既是社区主播又是卖货主播*/
//    JHRoleTypeCommonAnchor = 6,
//    /**回血主播*/
//    JHRoleTypeRestoreAnchor = 7,
//    /**回血主播助理*/
//    JHRoleTypeRestoreAnchorAsst = 8,
//
//    JHRoleTypeRoleCustomize = 9,            //定制师
//    JHRoleTypeRoleCustomizeAssistant = 10,         //定制师助理
//
//    JHRoleTypeRoleNew = 11,                  // 新类型
//    JHRoleTypeRoleRecycle = 1001,            // 回收主播
//    JHRoleTypeRoleRecycleAssistant = 1002    // 回收助理(待定)
//};


typedef NS_ENUM(NSInteger, JHPageFromType) {
    /**未知*/
    JHPageFromTypeUnKnown = 0,
    /**直播间*/
    JHPageFromTypeLiveRoom = 1,
    /**鉴定报告弹窗*/
    JHPageFromAppraiseReport = 2,
    /**鉴定视频详情*/
    JHPageFromTypeAppraiseVideoDetail = 3,
    /**订单鉴定报告*/
    JHPageFromTypeOrderAppraiseReport = 4,
    /**社区文章详情页*/
    JHPageFromTypeSQPostDetail = 5,
    /**社区宝友主页*/
    JHPageFromTypeSQFriendHome = 6,
    /**H5页*/
    JHPageFromTypeWebH5 = 7,
    /**订单评价成功页面*/
    JHPageFromTypeOrderEvaluateSuccess = 8,
    /**特卖商城*/
    JHPageFromTypeMallSale = 9,
    /**社区话题主页*/
    JHPageFromTypeSQTopicHomeList = 10,
    /**社区版块主页*/
    JHPageFromTypeSQPlateHomeList = 11,
    /**社区首页文章列表Item*/
    JHPageFromTypeSQHomePostList = 1001,
    /**社区搜索页文章列表Item列表*/
    JHPageFromTypeSQSearchPostList = 1005,
    /**社区收藏文章列表Item列表*/
    JHPageFromTypeSQFavoritePostList = 1006,
    
#pragma mark - 340 新增 为了区分
    /**社区文章详情页右上角更多*/
    JHPageFromTypeSQPostDetailMore = 51,
    /**社区文章详情页底部快捷操作栏*/
    JHPageFromTypeSQPostDetailFastOperate = 52,
    ///101-社区话题主页文章列表Item右上角更多
    JHPageFromTypeSQTopicHomeListMore = 101,
    ///102-社区话题主页文章列表Item底部快捷操作栏
    JHPageFromTypeSQTopicHomeListFastOperate = 102,
    ///111-社区版块主页文章列表Item右上角更多
    JHPageFromTypeSQPlateHomeListMore = 111,
    ///112-社区版块主页文章列表Item底部快捷操作栏
    JHPageFromTypeSQPlateHomeListFastOperate = 112,
    ///10011-社区首页文章列表Item右上角更多
    JHPageFromTypeSQHomeListMore = 10011,
    ///10012-社区首页文章列表Item底部快捷操作栏
    JHPageFromTypeSQHomeListFastOperate = 10012,
    ///10051-社区搜索页文章列表Item右上角更多
    JHPageFromTypeSQSearchListMore = 10051,
    ///10052-社区搜索页文章列表Item底部快捷操作栏
    JHPageFromTypeSQSearchListFastOperate = 10052,
    ///10061-社区收藏页文章列表Item右上角更多
    JHPageFromTypeSQFavoriteListMore = 10061,
    ///10062-社区收藏页文章列表Item底部快捷操作栏
    JHPageFromTypeSQFavoriteListFastOperate = 10062,
    ///10071-在线鉴定视频详情页更多分享
    JHPageFromTypeOnlineAppraiseVideoDetailMore = 10071,
    ///10072-在线鉴定视频详情页右侧分享
    JHPageFromTypeOnlineAppraiseVideoDetailOperate = 10072,
};

typedef enum : NSUInteger {
    JHLinkTypeChannel = 1,  //频道
    JHLinkTypeLivingRoom =2,      //直播间
    JHLinkTypeCommunity = 3,      //社区帖子
    JHLinkTypeHTML5 = 4,      //H5页面
    JHLinkTypeTopic = 5,      //话题
    JHLinkTypeSpecial = 6,      //专题
    JHLinkTypeDiscount = 7,      //限时特卖
    JHLinkTypeCustomize = 8,      //定制
    JHLinkTypeStore = 9,      //店铺
    JHLinkTypePlate = 10,      //板块
    JHLinkTypeMallSpecial = 14,   //商城专场详情
} LinkType;


typedef NS_ENUM(NSInteger, JHBannerAdType) {
    
    JHBannerAdTypeNone = 0,
    /// 社区信息流
    JHBannerAdTypeCommunity,
    
    /// 源头直播
    JHBannerAdTypeSaleMall,
    
    /// 鉴定
    JHBannerAdTypeAppraise,
    
    /// 个人中心
    JHBannerAdTypePersonal,
    
    /// 启动页
    JHBannerAdTypeLaunchApp,
    
    /// 特卖商城
    JHBannerAdTypeShop,
    
    /// 回收类型选择
    JHBannerAdTypeRecycle,

};

#endif /* TTjianbaoMarcoEnum_h */
