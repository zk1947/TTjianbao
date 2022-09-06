//
//  JHRouterManager.h
//  TTjianbao
//
//  Created by apple on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRouters.h"
#import "JHPostCellHeader.h"
#import "TTjianbaoMarcoEnum.h"
#import "JHSQModel.h"

//区分品类:原石/回血/其他物件/代购/加工服务
#define JHRoomTypeNameNormal @"normal" //常规直播间:玉器、手镯等
#define JHRoomTypeNameRoughStone @"roughOrder" //原石直播间
#define JHRoomTypeNameRestoreStone @"restoreStone" //回血直播间
#define JHRoomTypeNameCustomized @"customized" //定制直播间
#define JHRoomTypeNameRecycle @"recycle" //回收直播间
/*服务端字段,客户端暂时未用*/
#define JHRoomTypeNameProcessingOrder @"processingOrder" //加工服务直播间
#define JHRoomTypeNameDaiGouOrder @"daiGouOrder" //代购直播间

/// 判断登录状态（未登录直接弹出来登录页面）
#define IS_LOGIN [JHRouterManager getLoginStatus]

NS_ASSUME_NONNULL_BEGIN

/// 跳转工具类
@interface JHRouterManager : NSObject

/// 获取控制器
+ (UIViewController *)jh_getViewController;

/// 判断登录状态（未登录直接弹出来登录页面）
+ (BOOL)getLoginStatus;

+ (NSString *)getPageFrom:(JHPageType)type;

//新的路由跳转入口
+(void)deepLinkRouter:(JHRouterModel *)router;

/// 原石回血详情跳转
+ (void)pushStoneDetailWithStoneId:(NSString *)stoneId
                         complete:(nullable void (^)(id data))complete;

/// 原石回血详情跳转
+ (void)pushStoneDetailWithStoneId:(NSString *)stoneId
                  channelCategory:(nullable NSString *)channelCategory
                         complete:(nullable void(^)(id data))complete;

/// 津贴
+ (void)pushAllowanceWithController:(UIViewController *)sender;

/// wkwebViewController
+ (void)pushWebViewWithUrl:(NSString *)url title:(NSString *)title;

/// wkwebViewController
+ (void)pushWebViewWithUrl:(NSString *)url title:(NSString *)title controller:(UIViewController *)controller;
/// pop  webview
+(void)popWebViewWithUrl : (NSString *)url;
/// 1关注，     2粉丝
+ (void)pushUserFriendWithController:(UIViewController *)viewController
                               type:(NSInteger)type
                             userId:(NSInteger)userId
                               name:(NSString *)name;

/// 我的红包
+ (void)pushMyCouponViewController;

/// 禁言列表
+ (void)pushMuteViewController;

/// 打赏
+ (void)pushRewardViewController;

/// 设置封面
+ (void)pushSetCoverViewController;

/// 鉴定订单
+ (void)pushOrderAppraiseViewController;

/// 鉴定记录
+ (void)pushAppraiseRecoreViewController;

/// 认领交易鉴定
+ (void)pushGetAppraseListViewController;

/// 鉴定回复
+ (void)pushAppraisalReplyViewController;

/// 去签约
+ (void)pushSelectContractViewController;

///进入个人主页
+ (void)pushMyUserInfoController;

///进入对公账户认证界面
+ (void)pushPublicAccountController;

/// 个人原石头详情
+ (void)pushPersonReSellDetailWithStoneResaleId:(NSString *)stoneResaleId;

/// 个人原石发布
/// @param sourceOrderId 源订单id(转售)
/// @param sourceOrderCode 源订单code(转售)
/// @param flag 转售原石来源：0-原石（从已完成订单过来的）、1-回血（从买入原石列表过来的），默认1
+ (void)pushPersonReSellPublishWithSourceOrderId:(NSString *)sourceOrderId sourceOrderCode:(NSString *)sourceOrderCode flag:(NSInteger)flag editSuccessBlock:(dispatch_block_t)editSuccessBlock;

/// 个人原石编辑
/// @param stoneResaleId 只有编辑需要传
+ (void)pushPersonReSellPublishWithStoneResaleId:(NSString *)stoneResaleId editSuccessBlock:(dispatch_block_t)editSuccessBlock;

///进入话题详情
+ (void)pushTopicDetailWithTopicId:(NSString *)topicId pageType:(JHPageType)pageType;

///进入版块详情页
+ (void)pushPlateDetailWithPlateId:(NSString *)plateId pageType:(JHPageType)pageType;


/// 进入个人主页  JHRoleType
+ (void)pushDefaultUserInfoPageWithUserId:(NSString *)userId
                                     from:(NSString *)fromSource
                                   roomId:(NSString *)roomId;

+ (void)pushUserInfoPageWithUserId:(NSString *)userId
                         publisher:(JHPublisher *)publisher
                              from:(NSString *)fromSource
                            roomId:(NSString *)roomId;

+ (void)pushUserInfoPageWithUserId:(NSString *)userId
                         publisher:(JHPublisher *)publisher
                              from:(NSString *)fromSource
                            roomId:(NSString *)roomId
                     completeBlock:(void(^)(NSString *userId, BOOL isFollow))block;

///进入帖子详情web页
/// @param itemType 帖子类型
/// @param itemId 帖子ID
/// @param scrollComment 0-不做处理   1-滚动到评论  2-滚动到评论+弹起评论框
/// @param pageFrom 页面来源
+ (void)pushPostDetailWithItemType:(JHPostItemType)itemType
                            itemId:(NSString *)itemId
                          pageFrom:(NSString *)pageFrom
                     scrollComment:(NSInteger)scrollComment;

/// 草稿箱
+ (void)pushDraft;

@end

NS_ASSUME_NONNULL_END
