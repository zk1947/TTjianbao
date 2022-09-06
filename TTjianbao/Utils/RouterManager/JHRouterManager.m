//
//  JHRouterManager.m
//  TTjianbao
//
//  Created by apple on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHGemmologistViewController.h"
#import "JHUserInfoViewController.h"
#import "JHRouterManager.h"
#import "ChannelMode.h"
#import "NTESLivePlayerViewController.h"
#import "JHStoneDetailViewController.h"
#import "JHAllowanceViewController.h"
#import "JHWebViewController.h"
#import "JHFoucsListRootController.h"
#import "JHMyCouponViewController.h"
#import "JHMuteListViewController.h"
#import "JHCoinRecordViewController.h"
#import "JHSetLiveCoverViewController.h"
#import "JHAppraiseOrderViewController.h"
#import "JHLiveRecordViewController.h"
#import "JHDiscoverAppraiseReplyViewController.h"
#import "JHClaimOrderListViewController.h"
#import "JHSelectContractViewController.h"
#import "JHIdentyPublicAccountViewController.h"
#import "JHStonePersonReSellPublishController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHTopicDetailController.h"
#import "JHPlateDetailController.h"
#import "JHCustomerInfoController.h"
#import "JHRecycleInfoViewController.h"
#import "JHPostDetailViewController.h"
#import "JHDynamicViewController.h"
#import "JHDraftBoxController.h"
#import "JHOnlineVideoDetailController.h"
#import "JHActivityWebAlertView.h"
#import "JHActivityWebAlertView.h"

@implementation JHRouterManager

+ (UIViewController *)jh_getViewController {
    UIViewController *vc = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    vc = window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    return vc;
}

+ (BOOL)getLoginStatus {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:JHRootController complete:^(BOOL result) {}];
        return  NO;
    }
    return  YES;
}

#pragma mark ---------------跳转页面 ---------------
/// 原石回血详情跳转
+ (void)pushStoneDetailWithStoneId:(NSString *)stoneId
                          complete:(nullable void (^)(id data))complete {
    [JHRouterManager pushStoneDetailWithStoneId:stoneId channelCategory:JHRoomTypeNameRestoreStone complete:complete];
}

/// 原石回血详情跳转
+ (void)pushStoneDetailWithStoneId:(NSString *)stoneId
                   channelCategory:(nullable NSString *)channelCategory
                          complete:(nullable void (^)(id data))complete {
    //从直播间跳转 关闭直播间拉流 add-jiang
    for ( UIViewController *vc in JHRootController.navViewControllers) {
        if ([vc isKindOfClass:[NTESLivePlayerViewController class]]) {
            NTESLivePlayerViewController * live=(NTESLivePlayerViewController*)vc;
            live.needShutDown=YES;
            break;
        }
    }
    JHStoneDetailViewController *vc = [JHStoneDetailViewController new];
    vc.stoneId                      = stoneId;
    vc.channelCategory              = channelCategory ? JHRoomTypeNameRestoreStone : nil;
    vc.complete                     = complete;
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

/// 津贴
+ (void)pushAllowanceWithController:(UIViewController *)sender
{
    JHAllowanceViewController *vc = [JHAllowanceViewController new];
    vc.isNative = YES;
    [sender.navigationController pushViewController:vc animated:YES];
    
}

/// wkwebViewController
+ (void)pushWebViewWithUrl:(NSString *)url title:(NSString *)title {
    [self pushWebViewWithUrl:url title:title controller:[self jh_getViewController]];
}

/// wkwebViewController
+(void)pushWebViewWithUrl:(NSString *)url title:(NSString *)title controller:(UIViewController *)controller {
    JHWebViewController *vc = [JHWebViewController new];
    vc.titleString = title;
    vc.urlString = url;
    [controller.navigationController pushViewController:vc animated:YES];
}
+(void)popWebViewWithUrl : (NSString *)url {
    [JHActivityWebAlertView showWithUrl:url];
}
/// 1关注，     2粉丝
+ (void)pushUserFriendWithController:(UIViewController *)viewController
                                type:(NSInteger)type
                              userId:(NSInteger)userId
                                name:(NSString *)name {
    if(type == 1) {
        JHFoucsListRootController *vc = [JHFoucsListRootController new];
        vc.title = name;
        vc.userId = userId;
        [viewController.navigationController pushViewController:vc animated:YES];
    }
    else {
        JHUserFriendListController *vc = [JHUserFriendListController new];
        vc.type = 2;
        vc.name = name;
        vc.user_id = userId;
        [viewController.navigationController pushViewController:vc animated:YES];
    }
}

/// 我的红包
+ (void)pushMyCouponViewController {
    UIViewController *viewController = [self jh_getViewController];
    JHMyCouponViewController *vc=[[JHMyCouponViewController alloc]init];
    [viewController.navigationController pushViewController:vc animated:YES];
}

/// 禁言列表
+ (void)pushMuteViewController {
    
    [[self jh_getViewController].navigationController pushViewController:[JHMuteListViewController new] animated:YES];
}

/// 打赏
+ (void)pushRewardViewController {
    
    JHCoinRecordViewController *vc = [JHCoinRecordViewController new];
    vc.type = 2;
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

/// 设置封面
+ (void)pushSetCoverViewController {
    [[self jh_getViewController].navigationController pushViewController:[JHSetLiveCoverViewController new] animated:YES];
}

/// 鉴定订单
+ (void)pushOrderAppraiseViewController {
    [[self jh_getViewController].navigationController pushViewController:[JHAppraiseOrderViewController new] animated:YES];
}

/// 鉴定记录
+ (void)pushAppraiseRecoreViewController {
    JHLiveRecordViewController *vc = [JHLiveRecordViewController new];
    vc.roleType = 1;
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

/// 认领交易鉴定
+ (void)pushGetAppraseListViewController {
    [[self jh_getViewController].navigationController pushViewController:[JHClaimOrderListViewController new] animated:YES];
}

/// 鉴定回复
+ (void)pushAppraisalReplyViewController {
    [[self jh_getViewController].navigationController pushViewController:[JHDiscoverAppraiseReplyViewController new] animated:YES];
}

/// 去签约
+ (void)pushSelectContractViewController {
    [[self jh_getViewController].navigationController pushViewController:[JHSelectContractViewController new] animated:YES];
}

///进入个人主页
+ (void)pushMyUserInfoController {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    ///跳转到个人主页界面
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    [JHRootController enterUserInfoPage:userId user:[UserInfoRequestManager sharedInstance].user from:JHFromHomePersonal];
}

///进入对公账户认证界面
+ (void)pushPublicAccountController {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    JHIdentyPublicAccountViewController *vc = [JHIdentyPublicAccountViewController new];
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

/// 个人原石发布
/// @param sourceOrderId 源订单id(转售)
/// @param sourceOrderCode 源订单code(转售)
/// @param flag 转售原石来源：0-原石（从已完成订单过来的）、1-回血（从买入原石列表过来的），默认1
+ (void)pushPersonReSellPublishWithSourceOrderId:(NSString *)sourceOrderId sourceOrderCode:(NSString *)sourceOrderCode flag:(NSInteger)flag {
    JHStonePersonReSellPublishController *vc = [JHStonePersonReSellPublishController new];
    vc.sourceOrderId = sourceOrderId;
    vc.sourceOrderCode = sourceOrderCode;
    vc.sourceTypeFlag = @(flag).stringValue;
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

/// 个人原石发布
/// @param sourceOrderId 源订单id(转售)
/// @param sourceOrderCode 源订单code(转售)
/// @param flag 转售原石来源：0-原石（从已完成订单过来的）、1-回血（从买入原石列表过来的），默认1
///
+ (void)pushPersonReSellPublishWithSourceOrderId:(NSString *)sourceOrderId sourceOrderCode:(NSString *)sourceOrderCode flag:(NSInteger)flag editSuccessBlock:(dispatch_block_t)editSuccessBlock {
    JHStonePersonReSellPublishController *vc = [JHStonePersonReSellPublishController new];
    vc.sourceOrderId = sourceOrderId;
    vc.sourceOrderCode = sourceOrderCode;
    vc.sourceTypeFlag = @(flag).stringValue;
    vc.editSuccessBlock = editSuccessBlock;
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

/// 个人原石编辑
/// @param stoneResaleId 只有编辑需要传
+ (void)pushPersonReSellPublishWithStoneResaleId:(NSString *)stoneResaleId editSuccessBlock:(dispatch_block_t)editSuccessBlock {
    JHStonePersonReSellPublishController *vc = [JHStonePersonReSellPublishController new];
    vc.stoneResaleId = stoneResaleId;
    vc.editSuccessBlock = editSuccessBlock;
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

/// 个人原石头详情
+ (void)pushPersonReSellDetailWithStoneResaleId:(NSString *)stoneResaleId {
    JHStoneDetailViewController *vc = [JHStoneDetailViewController new];
    vc.stoneId = stoneResaleId;
    vc.type = 1;
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

+ (void)deepLinkRouter:(JHRouterModel *)router{
    if (router && router.vc) {
        if([router.vc isEqualToString:@"JHHomeTabController"]||[router.vc isEqualToString:@"UITabBarController"]) {
            NSString* indexStr = [router.params objectForKey:@"selectedIndex"];
            NSInteger selectedIndex = [indexStr integerValue];
            [JHRootController.homeTabController.navigationController popToRootViewControllerAnimated:YES];
            JHRootController.homeTabController.selectedIndex = selectedIndex;
            if ([router.params.allKeys containsObject:@"selectedIndex"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_JHHOMETABCONTROLLER" object:router.params];
            }
            if (selectedIndex == 1)
            { //源头直购
                if ([router.params.allKeys containsObject:@"item_type"]) {
                    [JHNotificationCenter postNotificationName:@"JHStoreHomePageIndexChangedNotification" object:router.params];
                }
            }
        }
        else if([router.vc isEqualToString:@"JHMessageViewController"] ||
                [router.vc isEqualToString:@"JHAllowanceViewController"] ||
                [router.vc isEqualToString:@"JHMyCouponViewController"] ||
                [router.vc isEqualToString:@"JHMallCouponViewController"]||
                [router.vc isEqualToString:@"JHMessageSubListController"]||
                [router.vc isEqualToString:@"JHUserFriendListController"]
                ){
            //需要登录的  后期可以找H5传参进行优化
            if (![JHRootController isLogin]) {
                [JHRootController presentLoginVCWithTarget:JHRootController complete:^(BOOL result) {
                    [JHRouters gotoPageByModel:router];
                }];
            }else{
                [JHRouters gotoPageByModel:router];
            }
        }
        else if([router.vc isEqualToString:@"NTESAudienceLiveViewController"] ){
            if(!router.params){
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JHRootController EnterLiveRoom:router.params[@"roomId"]?:@"" fromString:@""];
            });
            
        }else if ([router.vc isEqualToString:@"JHActivityWebAlertView"]) {
            [JHRouterManager popWebViewWithUrl:router.params[@"urlString"]];
        }
        else
        {// 动态解析跳转既定页面
            [JHRouters gotoPageByModel:router];
        }
    }
}

///进入话题详情页
+ (void)pushTopicDetailWithTopicId:(NSString *)topicId pageType:(JHPageType)pageType {
    if(topicId) {
        ///340埋点 - 话题进入事件
        NSString *pageFrom = [JHRouterManager getPageFrom:pageType];
        [JHGrowingIO trackEventId:JHTrackSQTopicDetailEnter variables:@{@"page_from":pageFrom,
                                                                        @"topic_id":topicId}];
        JHTopicDetailController *vc = [JHTopicDetailController new];
        vc.topicId = topicId;
        vc.pageFrom = pageFrom;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
}

///进入版块详情页
+ (void)pushPlateDetailWithPlateId:(NSString *)plateId pageType:(JHPageType)pageType {
    ///340埋点 - 进入板块事件 跳转地方较多 统一这个地方埋点
    NSString *pageFrom = [JHRouterManager getPageFrom:pageType];
    JHPlateDetailController *vc = [JHPlateDetailController new];
    vc.plateId = plateId;
    vc.pageFrom = pageFrom; ///帖子详情页
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}


+ (NSString *)getPageFrom:(JHPageType)type {
    switch (type) {
        case JHPageTypeSQHome: ///社区首页
            return JHFromSQHomeFeedList;
            break;
        case JHPageTypeUserInfoLikeTab: ///宝友主页
        case JHPageTypeUserInfoPublishTab:
            return JHFromUserInfo;
            break;
        case JHPageTypeCollect:///收藏
            return JHFromCollectList;
            break;
        case JHPageTypePostSearch:
        case JHPageTypeSQHomePostSearch:///社区首页搜索
            return JHFromSQSearchResult;
            break;
        case JHPageTypeSQTopicList:
            return JHFromSQTopicDetail;
            break;
        case JHPageTypeSQPlateList:
            return JHFromSQPlateDetail;
            break;
        case JHPageTypeWeb5:
            return JHLiveFromh5;
            break;
        default:
            return JHFromUndefined;
            break;
    }
}

+ (void)pushDefaultUserInfoPageWithUserId:(NSString *)userId
                                     from:(NSString *)fromSource
                                   roomId:(NSString *)roomId {
    JHPublisher *publisher = [[JHPublisher alloc] init];
    publisher.blRole_default = YES;
    [JHRouterManager pushUserInfoPageWithUserId:userId publisher:publisher from:fromSource roomId:roomId completeBlock:^(NSString * _Nonnull userId, BOOL isFollow) {}];
}

+ (void)pushUserInfoPageWithUserId:(NSString *)userId
                         publisher:(JHPublisher *)publisher
                              from:(NSString *)fromSource
                            roomId:(NSString *)roomId {
    [JHRouterManager pushUserInfoPageWithUserId:userId publisher:publisher from:fromSource roomId:roomId completeBlock:^(NSString * _Nonnull userId, BOOL isFollow) {}];
}

+ (void)pushUserInfoPageWithUserId:(NSString *)userId
                         publisher:(JHPublisher *)publisher
                              from:(NSString *)fromSource
                            roomId:(NSString *)roomId
                     completeBlock:(void(^)(NSString *userId, BOOL isFollow))block {
    if (publisher.blRole_appraiseAnchor) {
        ///鉴定主播
        JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
        vc.anchorId = userId;
        [[JHRouterManager jh_getViewController].navigationController pushViewController:vc animated:YES];
    } else if (publisher.blRole_customize) {
        // 定制师主页
        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
        vc.channelLocalId = roomId;
        vc.fromSource = @"businessliveplay";
        [[JHRouterManager jh_getViewController].navigationController pushViewController:vc animated:YES];
    }  else if (publisher.blRole_recycle) {
        // 回收师主页
        JHRecycleInfoViewController *vc = [[JHRecycleInfoViewController alloc] init];
        vc.channelLocalId = roomId;
        vc.fromSource = @"businessliveplay";
        [[JHRouterManager jh_getViewController].navigationController pushViewController:vc animated:YES];
    }
    else {
        JHUserInfoViewController *vc = [JHUserInfoViewController new];
        vc.userId = userId;
        vc.followStatusChangedBlock = block;
        [[JHRouterManager jh_getViewController].navigationController pushViewController:vc animated:YES];
    }
}

///进入帖子详情web页
/// @param itemType 帖子类型
/// @param itemId 帖子ID
/// @param scrollComment 0-不做处理   1-滚动到评论  2-滚动到评论+弹起评论框
/// @param pageFrom 页面来源
+ (void)pushPostDetailWithItemType:(JHPostItemType)itemType
                            itemId:(NSString *)itemId
                          pageFrom:(NSString *)pageFrom
                     scrollComment:(NSInteger)scrollComment {
    
    if (itemType == JHPostItemTypePost) {
        JHPostDetailViewController *vc = [[JHPostDetailViewController alloc] init];
        vc.itemType = itemType;
        vc.itemId = itemId;
        vc.pageFrom = pageFrom;
        vc.scrollComment = scrollComment;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
    else if (itemType == JHPostItemTypeDynamic || itemType == JHPostItemTypeVideo) {
        JHDynamicViewController *vc = [[JHDynamicViewController alloc] init];
        vc.itemType = itemType;
        vc.itemId = itemId;
        vc.pageFrom = pageFrom;
        vc.scrollComment = scrollComment;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
}

///进入帖子详情web页
/// @param itemType 帖子类型
/// @param itemId 帖子ID
/// @param scrollComment 0-不做处理   1-滚动到评论  2-滚动到评论+弹起评论框
/// @param pageFrom 页面来源
//+ (void)pushPostDetailWithItemType:(JHPostItemType)itemType
//                            itemId:(NSString *)itemId
//                          pageFrom:(NSString *)pageFrom
//                     scrollComment:(NSInteger)scrollComment
//                  supportMoreVideo:(BOOL)supportMoreVideo
//                        videoArray:(NSArray *)videoArray
//                     completeBlock:(void(^)(NSArray *postArray))block
//{
//
//    if (itemType == JHPostItemTypePost) {
//        JHPostDetailViewController *vc = [[JHPostDetailViewController alloc] init];
//        vc.itemType = itemType;
//        vc.itemId = itemId;
//        vc.pageFrom = pageFrom;
//        vc.scrollComment = scrollComment;
//        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
//    }
//    else if (itemType == JHPostItemTypeDynamic || itemType == JHPostItemTypeVideo) {
//        if (supportMoreVideo && itemType == JHPostItemTypeVideo) {
//            ///需要进入支持上下滑动的视频页面
//            JHOnlineVideoDetailController *vc = [[JHOnlineVideoDetailController alloc] init];
//            vc.delegate = self;
//            vc.currentPageIndex = self.viewModel.reqModel.page;
//            vc.currentIndex = indexPath.row;
//            NSArray *dictArray = [JHPostData mj_keyValuesArrayWithObjectArray:self.viewModel.dataArray.copy];
//            NSArray *postArray = [JHPostDetailModel mj_objectArrayWithKeyValuesArray:dictArray];
//            NSMutableArray *videoArray = [NSMutableArray array];
//            for (JHPostDetailModel *model in postArray) {
//                if (model.item_type == JHPostItemTypeVideo) {
//                    [videoArray addObject:model];
//                }
//            }
//            vc.postArray = videoArray.copy;
//            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
//        }
//        else {
//            JHDynamicViewController *vc = [[JHDynamicViewController alloc] init];
//            vc.itemType = itemType;
//            vc.itemId = itemId;
//            vc.pageFrom = pageFrom;
//            vc.scrollComment = scrollComment;
//            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
//        }
//    }
//}


/// 草稿箱
+ (void)pushDraft {
    JHDraftBoxController *vc = [JHDraftBoxController new];
    [[self jh_getViewController].navigationController pushViewController:vc animated:YES];
}

@end
