//
//  JHRootViewController+Notification.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRootViewController+Notification.h"
#import "JHRootViewController+TransitPage.h"
#import "JHRootNotification.h"
#import "JHPlateDetailController.h"
#import "JHOrderDetailViewController.h"
#import "JHSessionViewController.h"
#import "JHHomePageAllViewController.h"
#import "JHPostDetailViewController.h"
#import "JHActivityWebAlertView.h"
@implementation JHRootViewController (Notification)

- (void)gotoPagesFromMessageDeepLink:(id)keyValues from:(NSString *)from
{
    JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:keyValues];
    if([from isEqualToString:JHLiveFrompush])
    {//必须放这里 web设计到改值
        [self growingIOWithRouter:router];
    }
    
    [JHRouterManager deepLinkRouter:router];
}

- (void)onReceivreNotify:(NSNotification*)notify
{
    UNNotification *notification=[notify object];
    NSDictionary * useInfo=notification.request.content.userInfo;
    
    //网易云信--- 和七鱼的判断先后顺序不可变更
    if([[useInfo allKeys] containsObject:@"nimCusType"])
    {
        NSString *account = [useInfo objectForKey:@"sessionId"];
        
        if ([[useInfo objectForKey:@"nimCusType"] integerValue] == 1 && account.length > 0)
        {
            JHSessionViewController *vc = [[JHSessionViewController alloc] init];
            vc.receiveAccount = account;
            [JHRootController.navigationController pushViewController:vc animated:true];
        }
    }
    //七鱼
    else if([[useInfo allKeys] containsObject:@"nim"])
    {
        if ([[useInfo objectForKey:@"nim"] integerValue]==1)
        {
            [[JHQYChatManage shareInstance] showChatWithViewcontroller:self.tabBarController];
        }
    }
    //极光推送
    else if([[useInfo allKeys] containsObject:@"jpushAction"])
    {
        id paramsObj = [[useInfo objectForKey:@"jpushAction"]mj_JSONObject];
        [self handleMessageModel:paramsObj from:JHLiveFrompush]; //from这个来源沿用过去？？
    }
}

- (void)handleMessageModel:(id)keyValues from:(NSString *)from
{
    JHMessageTargetModel* messageModel = [JHMessageTargetModel mj_objectWithKeyValues:keyValues];
    if (messageModel.componentType == JHMessagePageTypePushMsg || messageModel.componentType == JHMessagePageTypeNormal)
    {//透传拦截
        [self gotoPagesFromMessageDeepLink:keyValues from:from];
    }
    else if (messageModel.action_type==XGPushMessageTypeDefault)
    {
        NSLog(@"do nothing???XGPushMessageTypeDefault");
    }
    else
    {
        [self messageToNativeVC:messageModel from:from];
    }
}

-(void)messageToPageModel:(JHMessageTargetModel*)model from:(NSString *)from
{
    if (model.action_type==XGPushMessageTypeWeb) {
        NSString *url = model.paramTargetModel.url;
        
        /// 统计push跳进H5页面 begin
        if([url containsString:@"?"])
        {
            url = [NSString stringWithFormat:@"%@&from=%@",url,JHLiveFrompush];
        }
        else
        {
            url = [NSString stringWithFormat:@"%@?from=%@",url,JHLiveFrompush];
        }
        /// 统计push跳进H5页面 end
        
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.urlString = url;
        [self.homeTabController.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (model.componentType==JHMessagePageTypeLiveRoom) {
        [self EnterLiveRoom:model.paramTargetModel.roomId fromString:from];
        return;
    }
    if ([model.vc isKindOfClass:[UITabBarController class]]) {
        
        BOOL inLiveRoom=NO;
        NSArray *vcArr=[JHRootController navViewControllers];
        for ( UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                inLiveRoom=YES;
                NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
                liveVC.fromString = from;
                liveVC.closeBlock = ^{
                    [JHRootController.homeTabController.navigationController popToRootViewControllerAnimated:YES];
                };
                liveVC.isExitVc = YES;
                [liveVC onCloseRoom];
                break;
            }
        }
        if (!inLiveRoom) {
            [JHRootController.homeTabController.navigationController popToRootViewControllerAnimated:YES];
        }
        
        NSInteger selectedIndex = [model.params[@"selectedIndex"] integerValue];
        if (selectedIndex == 1) { //源头直购
            self.homeTabController.selectedIndex = selectedIndex;
            if ([model.params.allKeys containsObject:@"item_type"]) {
                [self changeStoreHomePage:model.params];
            }
            /// 统计push跳进原生
            [JHGrowingIO trackEventId:@"page_jump" variables:@{@"from" : @"push",@"page_name":@"JHStoreHomePageController"}];
            
        } else if (selectedIndex == 2) { //点击【+】号
            [self.homeTabController clickPublishButton];
            self.homeTabController.selectedIndex = 0; //切换到社区首页
            
        }else if (selectedIndex == 3) { // 鉴定服务
            self.homeTabController.selectedIndex = selectedIndex;
            if ([model.params.allKeys containsObject:@"item_type"]) {
                [self changeHomePage : model.params];
            }
        }
        else {
            if(selectedIndex == 0){
                if ([model.params.allKeys containsObject:@"item_type"]) {
                    [self changeHomePageAll: model.params];
                }
            }
            
            self.homeTabController.selectedIndex = selectedIndex;
        }
        
        return;
    }
    if (!self.isLogin) {
        [self presentLoginVC:nil];
        return;
    }
    switch (model.componentType) {
        case JHMessagePageTypeCopon:
        {
            JHMyCouponViewController * copon=[[JHMyCouponViewController alloc]init];
            copon.currentIndex=model.paramTargetModel.targetIndex;
            [self.homeTabController.navigationController pushViewController:copon animated:YES];
            /// 统计push跳进原生
            [JHGrowingIO trackEventId:@"page_jump" variables:@{@"from" : @"push",@"page_name":@"JHMyCouponViewController"}];
            
        }
            break;
        case JHMessagePageTypeMallCopon:
        {
            JHMallCouponViewController * mallCopon=[[JHMallCouponViewController alloc]init];
            mallCopon.currentIndex=model.paramTargetModel.targetIndex;
            [self.homeTabController.navigationController pushViewController:mallCopon animated:YES];
            /// 统计push跳进原生
            [JHGrowingIO trackEventId:@"page_jump" variables:@{@"from" : @"push",@"page_name":@"JHMallCouponViewController"}];
            
        }
            break;
            
        case JHMessagePageTypeOrderDetail:
        {
            JHOrderDetailViewController * order=[[JHOrderDetailViewController alloc]init];
            order.isSeller = model.paramTargetModel.isSeller;
            order.orderId = model.paramTargetModel.orderId;
            [self.homeTabController.navigationController pushViewController:order animated:YES];
        }
            break;
            
        case JHMessagePageTypeOrderSure:
        {
            JHOrderConfirmViewController  * order=[[JHOrderConfirmViewController alloc]init];
            order.orderId=model.paramTargetModel.orderId;
            [self.homeTabController.navigationController pushViewController:order animated:YES];
        }
            
            break;
        case JHMessagePageTypeReport: {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), model.paramTargetModel.ID];
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        }
            break;
        case JHMessagePageTypeCoverDetail:
        {
            @weakify(self);
            //校验内容有效性
            NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/content/detailBridge/%@/%@"),
                             @(model.paramTargetModel.item_type), (model.paramTargetModel.item_id ? : @"")];
            
            [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
                CBridgeData *data = [CBridgeData modelWithJSON:respondObject.data];
                if ([JHSQManager isValid:data]) {
                    @strongify(self);
                    
                    if (data.layout == JHSQLayoutTypeImageText) {//图片
                        [JHRouterManager pushPostDetailWithItemType:JHPostItemTypePost itemId:model.paramTargetModel.item_id pageFrom:JHLiveFrompush scrollComment:0];
                    } else if(data.layout == JHSQLayoutTypeVideo) {//视频
                        [JHRouterManager pushPostDetailWithItemType:JHPostItemTypeVideo itemId:model.paramTargetModel.item_id pageFrom:JHLiveFrompush scrollComment:0];
                    } else if (data.layout==JHSQLayoutTypeAppraisalVideo){//鉴定剪辑视频
                        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
                        vc.cateId = [NSString stringWithFormat:@"%@",respondObject.data[@"item_type"]];
                        vc.appraiseId = respondObject.data[@"item_id"];
                        vc.commentId=model.paramTargetModel.comment_id;
                        vc.from = JHLiveFromInteractMessage;
                        [self.homeTabController.navigationController pushViewController:vc animated:YES];
                    }
                    
                } else {
                    [UITipView showTipStr:@"帖子不存在或已删除"];
                }
                
            } failureBlock:^(RequestModel *respondObject) {
                [UITipView showTipStr:@"帖子不存在或已删除"];
            }];
        }
            break;
        case JHMessagePageTypeUserMainPage:
        {
            [JHRouterManager pushDefaultUserInfoPageWithUserId:model.paramTargetModel.user_id from:@"push" roomId:model.paramTargetModel.roomId];
        }
            break;
            
        case JHMessagePageTypeHistoryMessageList:
        {
            JHMessageSubListController *vc = [[JHMessageSubListController alloc] initWithTitle:@"社区互动" pageType:kMsgSublistTypeForum];
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeOrderList:
        {
            JHOrderListViewController *vc = [JHOrderListViewController new];
            vc.isSeller = model.paramTargetModel.isSeller;
            vc.currentIndex= model.paramTargetModel.targetIndex;
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeTopic:
        {
            //进入话题详情
            JHTopicDetailController *vc = [JHTopicDetailController new];
            vc.topicId = model.paramTargetModel.item_id;
            vc.pageFrom = JHLiveFrompush;
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
            //埋点 - 进入话题详情埋点
            [self buryPointWithTopicId:model.paramTargetModel.item_id];
            ///340埋点 - 话题进入事件
            [JHGrowingIO trackEventId:JHTrackSQTopicDetailEnter variables:@{@"page_from":JHLiveFromh5,
                                                                            @"topic_id":model.paramTargetModel.item_id}];
        }
            break;
        case JHMessagePageTypeUserCenterResale:
        {//买家寄售原石页面
            JHUserCenterResaleViewController *vc = [JHUserCenterResaleViewController new];
            vc.selectedIndex=model.paramTargetModel.targetIndex;
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeStonePinMoney:
        {//卖家结算页面
            JHStonePinMoneyViewController *vc = [JHStonePinMoneyViewController new];
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case JHMessagePageTypeStoneMyPrice:
        {//待出价
            JHMyPriceViewController *vc = [JHMyPriceViewController new];
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeStoneMyWillSale:
        {//待上架原石
            JHMainLiveRoomWillSalePageViewController *vc = [JHMainLiveRoomWillSalePageViewController new];
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeRedPacket:
        {//红包
            JHRedPacketDetailController *vc=[[JHRedPacketDetailController alloc]init];
            vc.redPacketId=model.paramTargetModel.redPacketId;
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeAllowance:
        {//津贴
            JHAllowanceViewController *vc=[[JHAllowanceViewController alloc]init];
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
            /// 统计push跳进原生
            [JHGrowingIO trackEventId:@"page_jump" variables:@{@"from" : @"push",@"page_name":@"JHAllowanceViewController"}];
            
        }
            break;
        case JHMessagePageTypeSeckillPageList:
        {
            JHSeckillPageViewController *vc = [[JHSeckillPageViewController alloc] init];
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypePersonCenter:
        {
            [self.homeTabController.navigationController popToRootViewControllerAnimated:YES];
            [JHRootController setTabBarSelectedIndex:4];
        }
            break;
            
        case JHMessagePageTypePersonalInfo:
        {
            JHPersonalViewController *vc = [[JHPersonalViewController alloc] init];
            [self.homeTabController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
#if DEBUG
        {
            [UITipView showTipStr:[NSString stringWithFormat: @"落地页没有匹配类型:%zd", model.componentType]];
        }
#endif
            break;
    }
}

- (void)gotoPagesFromMessageRouter:(id)keyValues
{
    //    [JHRouters gotoPageByDiction:routerParm];
    JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:keyValues];
    if([router.vc isEqualToString:@"UITabBarController"])
    {
        NSString* indexStr = [router.params objectForKey:@"selectedIndex"];
        NSInteger selectedIndex = [indexStr integerValue];
        [self.homeTabController.navigationController popToRootViewControllerAnimated:YES];
        self.homeTabController.selectedIndex = selectedIndex;
        
        if (selectedIndex == 1)
        { //源头直购
            if ([router.params.allKeys containsObject:@"item_type"])
            {
                [self changeStoreHomePage:router.params];
            }
        }else if (selectedIndex == 3) {
            if ([router.params.allKeys containsObject:@"item_type"])
            {
                [self changeStoreHomePage:router.params];
                [self changeHomePage : router.params];
            }
        }
    }
    else
    {// 动态解析跳转既定页面
        [JHRouters gotoPageByModel:router];
    }
}

#pragma mark - from web??
- (void)webToPage:(NSString *)className withParam:(NSDictionary *)paraDic from:(NSString *)from
{
    NSDictionary *dic = paraDic;
    if ([className isEqualToString:@"WebDialog"]) {
        JHWebView *webview = [[JHWebView alloc] init];
        webview.frame = [UIScreen mainScreen].bounds;
        
        [webview jh_loadWebURL:dic[@"urlString"]];
        [[UIApplication sharedApplication].keyWindow addSubview:webview];
        return;
    }
    UIViewController *controller = [[NSClassFromString(className) alloc] init];
    if ([controller isKindOfClass:[UIViewController class]]) {
        if ([className isEqualToString:@"NTESAudienceLiveViewController"]) {
            if (dic[@"roomId"]) {
                //  [self EnterLiveRoom:dic[@"roomId"] fromString:from];
                NSArray *array = [NSArray array];
                if ([dic containsObjectForKey:@"roomList"]) {
                    array = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:dic[@"roomList"]];
                }
                
                if ([dic containsObjectForKey:@"countDown"]) {
                    NSUInteger countdown = [dic[@"countDown"] integerValue];
                    [JHLiveActivityManager startCountDown:countdown];
                }
                [self webToLiveRoom:dic[@"roomId"] roomList:array fromString:from];
                
            }else {
                [SVProgressHUD showErrorWithStatus:@"参数错误"];
            }
            
        }
        else if ([controller isKindOfClass:[UITabBarController class]]) {
            
            //处理点击运营位跳转VC后tabBar不切换问题
            if ([dic.allKeys containsObject:@"selectedIndex"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_JHHOMETABCONTROLLER" object:dic];
            }
            
            BOOL inLiveRoom=NO;
            NSArray *vcArr=[JHRootController navViewControllers];
            for ( UIViewController *vc in vcArr) {
                if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                    inLiveRoom=YES;
                    NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
                    liveVC.fromString = from;
                    liveVC.closeBlock = ^{
                        [JHRootController.homeTabController.navigationController popToRootViewControllerAnimated:YES];
                    };
                    liveVC.isExitVc = YES;
                    [liveVC onCloseRoom];
                    break;
                }
            }
            if (!inLiveRoom) {
                [JHRootController.homeTabController.navigationController popToRootViewControllerAnimated:YES];
            }
            
            NSInteger selectedIndex = [dic[@"selectedIndex"] integerValue];
            if (selectedIndex == 1) { //源头直购
                self.homeTabController.selectedIndex = selectedIndex;
                if ([dic.allKeys containsObject:@"item_type"]) {
                    [self changeStoreHomePage:dic];
                }
                
            }else if (selectedIndex == 3) { // 鉴定服务
                self.homeTabController.selectedIndex = selectedIndex;
                if ([dic.allKeys containsObject:@"item_type"]) {
                    [self changeHomePage:dic];
                }
            }
            else {
                if(selectedIndex == 0){
                    if ([dic.allKeys containsObject:@"item_type"]) {
                        [self changeHomePageAll: dic];
                    }
                }
                
                self.homeTabController.selectedIndex = selectedIndex;
            }
            
        } else if ([controller isKindOfClass:[LoginViewController class]]) {
            
            if (![self isLogin]) {
                if ([dic.allKeys containsObject:@"inviteCode"]) {
                    [self presentLoginVCWithTarget:self.homeTabController params:dic complete:^(BOOL result) {
                        if (result){
                            if (dic[@"isRoom"]) {
                                if ([dic[@"isRoom"] integerValue] == 1) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveLoginFinishNotifaction" object:nil];
                                }
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameWebViewHandler object:nil];
                        }
                    }];
                }else {
                    [self presentLoginVCWithTarget:self.homeTabController complete:^(BOOL result) {
                        if (result){
                            if (dic[@"isRoom"]) {
                                if ([dic[@"isRoom"] integerValue] == 1) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveLoginFinishNotifaction" object:nil];
                                }
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRefreshWebView object:nil];
                        }
                    }];
                }
            } else {
                [[UIApplication sharedApplication].keyWindow makeToast:@"已经登录"];
            }
            
        }
        else if ([controller isKindOfClass:[JHTopicDetailController class]]) {
            [self enterTopicDetailVC:dic]; //进入话题页
            
        }
        else if ([controller isKindOfClass:[JHShopWindowPageController class]]) {
            [self enterShopWindowVC:dic from:from]; //进入橱窗页
            
        }
        ///之前是有JHDiscoverDetailsVC这个类 后面整理文件把这个类删除了
        //        else if ([controller isKindOfClass:NSClassFromString(@"JHDiscoverDetailsVC")]) {
        //            [self enterPostDetailVC:dic]; //进入社区帖详情
        //        }
        else if ([controller isKindOfClass:[JHPlateDetailController class]]) {///版块
            [JHRouterManager pushPlateDetailWithPlateId:dic[@"plateId"] pageType:JHPageTypeWeb5];
        }
        else if ([controller isKindOfClass:[JHOrderDetailViewController class]]) {
            [self enterOrderDetailVC:dic from:from]; //进入订单详情页面
        }
        else if ([controller isKindOfClass:[JHPostDetailViewController class]]) {
            [self enterPostDetailVC:dic]; //进入社区帖详情
        }
        else if ([controller isKindOfClass:[JHActivityWebAlertView class]]) {
            [JHRouterManager popWebViewWithUrl:dic[@"urlString"]];
        }
        else {
            for (NSString *key in dic.allKeys) {
                if ([self getVariableWithClass:NSClassFromString(className) varName:key]) {
                    [controller setValue:dic[key] forKey:key];
                }
            }
            
            if ([self.homeTabController presentedViewController]) {
                [[self currentViewController].navigationController pushViewController:controller animated:YES];
                
            } else {
                [self.homeTabController.navigationController pushViewController:controller animated:YES];
            }
        }
    }
    else {
        //        if ([controller isKindOfClass:NSClassFromString(@"JHDiscoverDetailsVC")]) {
        if ([className isEqualToString:@"JHDiscoverDetailsVC"]) {
            
            [self enterPostDetailVC:dic]; //进入社区帖详情
        }
    }
}
///进入订单详情界面
- (void)enterOrderDetailVC:(NSDictionary *)dic from:(NSString *)from{
    if (IS_LOGIN) {
        JHOrderDetailViewController *vc = [[JHOrderDetailViewController alloc] init];
        for (NSString *key in dic.allKeys) {
            if ([self getVariableWithClass:[JHOrderDetailViewController class] varName:key]) {
                [vc setValue:dic[key] forKey:key];
            }
        }
        [self.homeTabController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)changeStoreHomePage:(NSDictionary*)params {
    [JHNotificationCenter postNotificationName:JHStoreHomePageIndexChangedNotification object:params];
}
- (void)changeHomePage : (NSDictionary *)params {
    [JHDispatch after:0.2f execute:^{
        [JHNotificationCenter postNotificationName:JHHomePageIndexChangedNotification object:params];
    }];
}
- (void)changeHomePageAll:(NSDictionary*)params {
    [JHNotificationCenter postNotificationName:JHHomePageAllViewControllerNotification object:params];
}

//进入商城橱窗页
- (void)enterShopWindowVC:(NSDictionary *)dic from:(NSString *)from {
    ///判断如果keywindow上有红包界面 需要移除
    //    [JHMaskingManager dismissPopWindow];
    NSString *ccId = dic[@"sc_id"];
    JHShopWindowPageController *vc = [JHShopWindowPageController new];
    vc.showcaseId = ccId.integerValue;
    vc.fromSource = from;
    [self.homeTabController.navigationController pushViewController:vc animated:YES];
}

//进入话题页
- (void)enterTopicDetailVC:(NSDictionary *)dic {
    ///判断如果keywindow上有红包界面 需要移除
    //    [JHMaskingManager dismissPopWindow];
    NSString *itemId = dic[@"item_id"];
    
    [JHRouterManager pushTopicDetailWithTopicId:itemId pageType:JHPageTypeWeb5];
    
    //埋点 - 进入话题详情埋点
    [self buryPointWithTopicId:itemId];
}

- (void)enterPostDetailVC:(NSDictionary *)dic {
    if ([dic.allKeys containsObject:@"item_type"]) {
        JHPostItemType itemType = [dic[@"item_type"] integerValue];
        NSString *itemId = dic[@"item_id"];
        [JHRouterManager pushPostDetailWithItemType:itemType itemId:itemId pageFrom:JHLiveFrompush scrollComment:0];
    }
}

- (BOOL)getVariableWithClass:(Class) myClass varName:(NSString *)name{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        
        if ([keyName isEqualToString:[NSString stringWithFormat:@"_%@",name]]) {
            return YES;
        }
    }
    return NO;
}

///为了埋点而添加的方法
-(void)growingIOWithRouter:(JHRouterModel *)router{
    
    if (router && router.vc)
    {
        [JHGrowingIO trackEventId:@"page_jump" variables:@{@"from" : @"push",@"page_name":router.vc}];
        
        
        if([router.vc isEqualToString:@"JHWebViewController"])
        {
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:router.params];
            if(param && [param valueForKey:@"urlString"])
            {
                NSString *url = [param valueForKey:@"urlString"];
                if([url containsString:@"?"])
                {
                    url = [NSString stringWithFormat:@"%@&from=%@",url,JHLiveFrompush];
                }
                else
                {
                    url = [NSString stringWithFormat:@"%@?from=%@",url,JHLiveFrompush];
                }
                [param setValue:url forKey:@"urlString"];
                router.params = param;
            }
        }
    }
}

@end

