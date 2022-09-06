//
//  JHLinkClickAction.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLinkClickAction.h"
#import "JHWebViewController.h"
#import "BaseTabBarController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHShopWindowController.h"
#import "JHTopicDetailController.h"
#import "JHShopHomeController.h"
#import "JHPlateDetailController.h"
#import "JHShopWindowPageController.h"
#import "JHSQApiManager.h"
#import "JHPostDetailModel.h"
#import "JHSQManager.h"
#import "JHUserInfoViewController.h"
#import "JHUserInfoViewController.h"
#import "JHGemmologistViewController.h"
#import "JHCustomerInfoController.h"
#import "JHUserInfoBlankController.h"
#import "JHNewStoreSpecialDetailViewController.h"

@implementation JHLinkClickAction

+ (void)linkClickActionWithType:(NSInteger)linkType andUrl:(NSString *)urlString{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentViewController = [self getCurrentViewControllerWithRootViewController:rootViewController];
    switch (linkType) {
        case JHLinkTypeChannel:   //频道 ,tab
        {
            if (urlString.integerValue < 5) {
                [currentViewController.navigationController popToRootViewControllerAnimated:NO];
                if (urlString.integerValue == 2) {  //2是那个发布按钮
                    JHRootController.homeTabController.selectedIndex = 3;
                }else{
                    JHRootController.homeTabController.selectedIndex = urlString.integerValue;
                }
            }
        }
            break;
        case JHLinkTypeLivingRoom://直播间
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JHRootController EnterLiveRoom:urlString fromString:@""];
            });
        }
            break;
        case JHLinkTypeCommunity: //社区  ?
        {
            [self enterCommunityWithId:urlString];

        }
            break;
        case JHLinkTypeHTML5:     //网页
        {
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.urlString = urlString;
            [currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHLinkTypeTopic:     //话题
        {
            JHTopicDetailController *vc = [[JHTopicDetailController alloc] init];
            vc.topicId = urlString;
            [currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHLinkTypeSpecial:   //专题  ?
        {
            JHShopWindowPageController *listVC = [[JHShopWindowPageController alloc] init];
            listVC.showcaseId = urlString.integerValue;
            [currentViewController.navigationController pushViewController:listVC animated:YES];
        }
            break;
        case JHLinkTypeDiscount:  //特价
        {
            [currentViewController.navigationController popToRootViewControllerAnimated:YES];
            JHRootController.homeTabController.selectedIndex = 1;
            [JHNotificationCenter postNotificationName:@"JHStoreHomePageIndexChangedNotification" object:@{@"selectedIndex" : @"1", @"item_type" : @"2"}];
        }
            break;
        case JHLinkTypeCustomize:     //定制
        {
            [currentViewController.navigationController popToRootViewControllerAnimated:YES];
            JHRootController.homeTabController.selectedIndex = 1;
            [JHNotificationCenter postNotificationName:@"JHStoreHomePageIndexChangedNotification" object:@{@"selectedIndex" : @"1", @"item_type" : @"1"}];
        }
            break;
        case JHLinkTypeStore:     //商店
        {
            JHShopHomeController *storeVc = [[JHShopHomeController alloc] init];
            storeVc.sellerId = urlString.integerValue;
            [currentViewController.navigationController pushViewController:storeVc animated:YES];
        }
            break;
        case JHLinkTypePlate:     //板块
        {
            JHPlateDetailController *vc = [JHPlateDetailController new];
            vc.plateId = urlString;
            [currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHLinkTypeMallSpecial: //商城专场详情
        {
            JHNewStoreSpecialDetailViewController *specialVC = [[JHNewStoreSpecialDetailViewController alloc] init];
            specialVC.showId = urlString;
            specialVC.fromPage = @"社区帖子";
            [currentViewController.navigationController pushViewController:specialVC animated:YES];
        }
            break;
        case -1: //网页
        {
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.urlString = urlString;
            [currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
/** 进入到社区*/
+ (void)enterCommunityWithId:(NSString *)itemId{
    [SVProgressHUD show];
    [JHSQApiManager getPostDetailInfo:@"0" itemId:itemId block:^(JHPostDetailModel *detailModel, BOOL hasError) {
        [SVProgressHUD dismiss];
        if (!hasError) {
            [JHRouterManager pushPostDetailWithItemType:detailModel.item_type itemId:detailModel.item_id pageFrom:@"lianjie"scrollComment:0];
        }
    }];
}

/** 进入到用户详情页*/
+ (void)linkClickActionWithUserName:(NSString *)userName {
    userName = [userName stringByReplacingOccurrencesOfString:@"@" withString:@""];
    //先根据username请求到userID;
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"names"] = @[userName];
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/user/usersInfo") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = respondObject.data;
        if (array.count > 0) {
            NSString *customerId = [NSString stringWithFormat:@"%@", array.firstObject[@"customer_id"]];
            NSString *channelLocalId = [NSString stringWithFormat:@"%@", array.firstObject[@"channel_local_id"]];
            NSString *type = [NSString stringWithFormat:@"%@", array.firstObject[@"type"]];
            if (type.integerValue == 9) {
                [JHLinkClickAction skipToUserViewController:channelLocalId type:type];
            } else {
                [JHLinkClickAction skipToUserViewController:customerId type:type];
            }
        }else{
            [JHLinkClickAction skipToUserViewController:@"" type:@""];
        }
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}

+ (void)skipToUserViewController:(NSString *)customId type:(NSString *)type {
    //0普通用户，1鉴定主播，2直播卖货主播，3:助理 4:社区商户，6:社区商户+直播卖货主播 7:回血商家，8回血助理，9定制师，10定制师助理
    if (customId.integerValue <= 0) { //找不到用户
        JHUserInfoBlankController *blankView = [[JHUserInfoBlankController alloc] init];
        [JHRootController.currentViewController.navigationController pushViewController:blankView animated:YES];
        return;
    }
    switch (type.integerValue) {
        case 0:
        {
            JHUserInfoViewController *vc = [JHUserInfoViewController new];
            vc.userId = customId;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
            vc.anchorId = customId;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.channelLocalId = customId;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {
            JHUserInfoViewController *vc = [JHUserInfoViewController new];
            vc.userId = customId;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

/** 获取当前控制器*/
+ (UIViewController *)getCurrentViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self getCurrentViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self getCurrentViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self getCurrentViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
