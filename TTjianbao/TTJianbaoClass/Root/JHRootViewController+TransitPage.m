//
//  JHRootViewController+TransitPage.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRootViewController+TransitPage.h"
#import "JHRootViewController+Notification.h"
#import "JHNimNotificationManager.h"
#import <NIMSDK/NIMSDK.h>
#import "WXApi.h"
#import "BYTimer.h"
#import "DBManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "NSString+Common.h"
#import "NTESLoginManager.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHGuestLoginNIMSDKManage.h"
#import "UserInfoRequestManager.h"
#import "LoginViewController.h"
#import "JHTopicDetailController.h"
#import "JHSelectMerchantViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHGemmologistViewController.h"
#import "JHUserInfoViewController.h"
#import "JHCustomerInfoController.h"
#import "BaseNavViewController.h"


@implementation JHRootViewController (PageTransit)

- (void)exitApp {
#ifdef DEBUG
#else
    [self exit];
#endif
}

-(void)exit{
    BYTimer *timer;
    if (timer) {
        [timer stopGCDTimer];
        timer=nil;
    }
    timer=[[BYTimer alloc]init];
    [timer createTimerWithTimeout:3 handlerBlock:^(int presentTime) {
        [[UIApplication sharedApplication].keyWindow makeToast:[NSString stringWithFormat:@"    %d    ",presentTime] duration:1.0 position:CSToastPositionCenter];
    } finish:^{
        exit(0);
    }];
}

#pragma mark - Login & Logout
-(BOOL)isLogin{

    NSString* status=[[NSUserDefaults standardUserDefaults] objectForKey:LOGINSTATUS];
    if (![status isEqualToString:ONLINE]) {
        return NO;
    }
    return YES;
}

-(void)loginIM:(NSString*)Account token:(NSString*)Token completion:(NIMLoginHandler)completion{
    
    if ([[NIMSDK sharedSDK] loginManager].isLogined) {
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                [self loginIMAccount:Account token:Token completion:completion];
            });
        }];
    } else {
        [self loginIMAccount:Account token:Token completion:completion];
    }
}

- (void)loginIMAccount:(NSString *)Account token:(NSString *)Token completion:(NIMLoginHandler)completion {
    [[[NIMSDK sharedSDK] loginManager] login:Account
                                          token:Token
                                     completion:^(NSError *error) {
           [SVProgressHUD dismiss];
           if (error == nil)
           {
               DDLogInfo(@"login success accid: %@",Account);
               NTESLoginData *sdkData = [[NTESLoginData alloc] init];
               sdkData.account   = Account;
               sdkData.token     = Token;
               [[NTESLoginManager sharedManager] setCurrentNTESLoginData:sdkData];
               
               // [[NTESServiceManager sharedManager] start];
               [[JHGuestLoginNIMSDKManage sharedInstance]addObserveNIMBroad];
           }
           else
           {
               DDLogInfo(@"login failed accid: %@ code: %zd",Account,error.code);
               NSString *toast = [NSString stringWithFormat:@"IM登录失败 code: %zd",error.code];
               
               [[UIApplication sharedApplication].keyWindow makeToast:toast duration:2.0 position:CSToastPositionCenter];
           }
           completion(error);
       }];
}

-(void)logoutAccountData{
    [self logoutAccountDataIsShowLogin:true];
}
-(void)logoutAccountDataIsShowLogin : (BOOL)isShow{
    [Growing clearUserId];
    [[UserInfoRequestManager sharedInstance]unBindDeviceToken:nil];
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[DBManager getInstance] del_userTableInfo];
        [UserInfoRequestManager sharedInstance].user=nil;
        [UserInfoRequestManager sharedInstance].levelModel=nil;
        
        [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
        [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IDTOKEN ];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [JHNimNotificationManager sharedManager].micWaitMode=nil;
        //
        [[JHGuestLoginNIMSDKManage sharedInstance] requestGuestNimInfo];
        
        if (![self isLogin] && isShow) {
            [self presentLoginVC:^(BOOL result) {
                if (result) {
                    [self bindWxWithSource:@"2" block:^{
                                            
                    }];
                }
            }];
        }
        [self postLogoutSucessNotification];
    }];
    
}
-(void)presentLoginVC{
    LoginViewController * loginVc=[[LoginViewController alloc]init];
    BaseNavViewController *loginNav=[[BaseNavViewController alloc]initWithRootViewController:loginVc];
    [loginNav setNavigationBarHidden:YES];
    [self.homeTabController presentViewController:loginNav animated:YES completion:^{
        
    }];
}

- (void)presentSignViewController {
    JHSelectMerchantViewController *signVC = [[JHSelectMerchantViewController alloc] init];
    [self.homeTabController.navigationController pushViewController:signVC animated:YES];
}

-(void)presentLoginVC:(void (^)(BOOL result)) loginResult{
    
    LoginViewController * loginVc=[[LoginViewController alloc]init];
//    [loginVc setLoginResult:loginResult];
    @weakify(self)
    loginVc.loginResult = ^(BOOL result) {
        @strongify(self)
        if (result) {
            [self postLoginSucessNotification];
        }
        if (loginResult) {
            loginResult(result);
        }
    };
    
    BaseNavViewController *loginNav=[[BaseNavViewController alloc]initWithRootViewController:loginVc];
    [loginNav setNavigationBarHidden:YES];
    [self.homeTabController presentViewController:loginNav animated:YES completion:^{
        
    }];
}

- (void)presentLoginVCWithTarget:(UIViewController *)vc complete:(void (^)(BOOL result))loginResult {
    
    LoginViewController * loginVc=[[LoginViewController alloc]init];
//    [loginVc setLoginResult:loginResult];
    @weakify(self)
    loginVc.loginResult = ^(BOOL result) {
        @strongify(self)
        if (result) {
            [self postLoginSucessNotification];
        }
        if (loginResult) {
            loginResult(result);
        }
    };
    BaseNavViewController *loginNav=[[BaseNavViewController alloc]initWithRootViewController:loginVc];
    [loginNav setNavigationBarHidden:YES];
    [vc presentViewController:loginNav animated:YES completion:^{
        
    }];
}
- (void)presentLoginVCWithTarget:(UIViewController *)vc params : (NSDictionary *)params complete:(void (^)(BOOL result))loginResult {
    
    LoginViewController * loginVc=[[LoginViewController alloc]init];
    loginVc.params = params;
    
//    [loginVc setLoginResult:loginResult];
    @weakify(self)
    loginVc.loginResult = ^(BOOL result) {
        @strongify(self)
        if (result) {
            [self postLoginSucessNotification];
        }
        if (loginResult) {
            loginResult(result);
        }
    };
    BaseNavViewController *loginNav=[[BaseNavViewController alloc]initWithRootViewController:loginVc];
    [loginNav setNavigationBarHidden:YES];
    [vc presentViewController:loginNav animated:YES completion:^{
        
    }];
}
- (void)postLoginSucessNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUSSNotifaction object:nil];
}
- (void)postLogoutSucessNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTSUSSNotifaction object:nil];
}
- (void)checkLoginWithTarget:(UIViewController *)vc complete:(void (^)(BOOL result))loginResult{
    if ([self isLogin]) {
        loginResult(YES);
    }else{
        [self presentLoginVCWithTarget:vc complete:loginResult];
    }
}


#pragma mark - enter some page
-(void)EnterLiveRoom:(NSString*) roomId fromString:(NSString *)from
{
    [self EnterLiveRoom:roomId fromString:from isStoneDetail:NO isApplyConnectMic:NO ];
}
-(void)EnterLiveRoom:(NSString*) roomId fromString:(NSString *)from isStoneDetail:(BOOL)isStoneDetail isApplyConnectMic:(BOOL)applyConnectMic{
    
    if (isEmpty(roomId)){
    [JHKeyWindow makeToast:@"加载失败，请稍后重试～" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    BOOL inLiveRoom=NO;
    for ( UIViewController *vc in self.navViewControllers) {
        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
            inLiveRoom=YES;
            NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
            liveVC.fromString = from;
            JH_WEAK(self)
            liveVC.closeBlock = ^{
                JH_STRONG(self)
                [self getLiveDetail:roomId roomList:@[]  isInLiveRoom:YES isStoneDetail:isStoneDetail from:from isApplyConnectMic:applyConnectMic];
            };
            liveVC.isExitVc = YES;
            [liveVC onCloseRoom];
            
            break;
        }
    }
    if (!inLiveRoom) {
        [self getLiveDetail:roomId roomList:@[]  isInLiveRoom:inLiveRoom isStoneDetail:isStoneDetail from:from isApplyConnectMic:applyConnectMic];
    }
}


- (void)webToLiveRoom:(NSString*)roomId roomList:(NSArray*)list fromString:(NSString *)from {
    if (isEmpty(roomId)){
    [JHKeyWindow makeToast:@"加载失败，请稍后重试～" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    BOOL inLiveRoom=NO;
    for ( UIViewController *vc in self.navViewControllers) {
        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
            inLiveRoom=YES;
            NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
            liveVC.fromString = from;
            @weakify(self);
            liveVC.closeBlock = ^{
                 @strongify(self);
            [self getLiveDetail:roomId roomList:list  isInLiveRoom:inLiveRoom isStoneDetail:NO from:from isApplyConnectMic:NO];
            };
            liveVC.isExitVc = YES;
            [liveVC onCloseRoom];
            break;
        }
    }
    if (!inLiveRoom) {
        [self getLiveDetail:roomId roomList:list  isInLiveRoom:inLiveRoom isStoneDetail:NO from:from isApplyConnectMic:NO];
    }
}
- (void)getLiveDetail:(NSString*)roomId roomList:(NSArray*)list isInLiveRoom:(BOOL)inLiveRoom isStoneDetail:(BOOL)isStoneDetail from:(NSString *)from  isApplyConnectMic:(BOOL)applyConnectMic{
    
    roomId= [NSString stringWithFormat:@"%@",roomId];
    //crash判空处理,目前逻辑,如果异常可以return
    if([NSString isEmpty:roomId])
        return;
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:roomId ? :@""] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:JHKeyWindow animated:YES];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        if ([JHLiveRoomStatus isLiveRoomType:JHLiveRoomTypeSell channelType:channel.channelType]) {
            
            if ([channel.status integerValue] == 2)
            {
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
                vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
                vc.channel=channel;
                vc.coverUrl = channel.coverImg;
                vc.fromString = from;
                vc.applyApprassal=applyConnectMic;
                
              __block  NSInteger currentSelectIndex=0;
                NSMutableArray * channelArr=[list mutableCopy];
                for (JHLiveRoomMode * mode in list) {
                    if ([mode.status integerValue]!=2) {
                        [channelArr removeObject:mode];
                    }
                }
                [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.ID isEqual:channel.channelLocalId]) {
                        currentSelectIndex=idx;
                        * stop=YES;
                    }
                }];
                vc.currentSelectIndex=currentSelectIndex;
                vc.channeArr=channelArr;
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
                
            }
            else if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
                
                NSString *string = nil;
                if (channel.status.integerValue == 1) {
                    string = channel.lastVideoUrl;
                }
                
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
                vc.channel = channel;
                vc.coverUrl = channel.coverImg;
                vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
                vc.fromString = from;
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            }
        }else {
            if ([channel.status integerValue]==2)
            {
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
                vc.channel=channel;
                vc.applyApprassal=applyConnectMic;
                vc.audienceUserRoleType = JHAudienceUserRoleTypeAppraise;
                vc.coverUrl = channel.coverImg;
                vc.fromString = from;
                
                __block  NSInteger currentSelectIndex=0;
                NSMutableArray * channelArr=[list mutableCopy];
                for (JHLiveRoomMode * mode in list) {
                    if ([mode.status integerValue]!=2) {
                        [channelArr removeObject:mode];
                    }
                }
                [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.ID isEqual:channel.channelLocalId]) {
                        currentSelectIndex=idx;
                        * stop=YES;
                    }
                }];
                vc.currentSelectIndex=currentSelectIndex;
                vc.channeArr=channelArr;
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            }
            else  {
                
                JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
                vc.anchorId=channel.anchorId;
                @weakify(self)
                vc.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
                    if ([from isEqualToString:JHFromSQHomePageFollow]) {
                        @strongify(self)
                        if (self.serviceCenter.finishFollow) {
                            self.serviceCenter.finishFollow(anchorId, isFollow);
                        }
                    }
                };
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            }
        }
        if (inLiveRoom) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(isStoneDetail){
                    NSMutableArray *vcArray = [NSMutableArray new];
                    for ( UIViewController *vc in self.navViewControllers) {
                        
                        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                            [vcArray addObject:self.navViewControllers.lastObject];
                            self.homeTabController.navigationController.viewControllers = vcArray;
                            break;
                        }
                        [vcArray addObject:vc];
                    }
                }
                else
                {
                    NSMutableArray *arr=self.navViewControllers;
                    for ( UIViewController *vc in arr) {
                        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                            [arr removeObject:vc];
                            self.homeTabController.navigationController.viewControllers=arr;
                            break;
                        }
                    }
                }
                
            });
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:JHKeyWindow animated:YES];
    }];
    [MBProgressHUD showHUDAddedTo:JHKeyWindow animated:YES];
}


//新增进入话题页埋点
- (void)buryPointWithTopicId:(NSString *)topicId {
    JHBuryPointEnterTopicDetailModel *pointModel = [JHBuryPointEnterTopicDetailModel new];
    pointModel.entry_type = 0;
    pointModel.entry_id = @"0";
    pointModel.topic_id = topicId;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    pointModel.time = timeSp;
    [[JHBuryPointOperator shareInstance] enterTopicDetailWithModel:pointModel];
}

-(void)messageToNativeVC:(JHMessageTargetModel*)model from:(NSString *)from
{
    [self messageToPageModel:model from:from];
}

- (void)toNativeVC:(NSString *)className withParam:(NSDictionary *)paraDic from:(NSString *)from
{
    [self webToPage:className withParam:paraDic from:from];
}

//h5页面跳转
- (void)webToNativeVCName:(NSString *)vc param:(NSString *)string
{
    NSDictionary *dic = [string mj_JSONObject];
    [self webToPage:vc withParam:dic from:JHLiveFromh5];
    
    //hutao-add
    NSArray *arrKeys = [dic allKeys];

    if ([vc isEqualToString:@"BaseTabBarController"])
    {
        if ([arrKeys containsObject:@"selectedIndex"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_JHHOMETABCONTROLLER" object:dic];
        }
    }
}

#pragma mark - Bind
- (void)WXBind:(NSNotification*)notify
{
    NSString * code=[notify object];
    NSDictionary *param = @{
        @"code":code,
        @"source" : self.bindWxSource ?: @"",
    };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/bindWx") Parameters:param requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:@"绑定成功" duration:2.0 position:CSToastPositionCenter];
        self.bindWxBlock();
    }
    failureBlock:^(RequestModel *respondObject) {
        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:2.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD show];
}

-(void)bindWxWithSource : (NSString *)source block:(JHFinishBlock)block {
    if ([UserInfoRequestManager sharedInstance].user.bindThird!=1 ) {

        self.bindWxBlock=block;
        self.bindWxSource = source;

        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"绑定微信登录" message:@"绑定微信并进行便捷登录" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.serviceCenter checkStartLiveButton];  ///隐藏或显示直播浮窗
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.serviceCenter checkStartLiveButton];  ///隐藏或显示直播浮窗
            [self sendAuthRequest];
        }]];
        [self.homeTabController presentViewController:alertVc animated:YES completion:nil];
    }
}
-(void)bindWxWithWebSource : (NSString *)source block:(JHFinishBlock)block {
    self.bindWxBlock=block;
    self.bindWxSource = source;

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"绑定微信登录" message:@"绑定微信并进行便捷登录" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.serviceCenter checkStartLiveButton];  ///隐藏或显示直播浮窗
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.serviceCenter checkStartLiveButton];  ///隐藏或显示直播浮窗
        [self sendAuthRequest];
    }]];
    [self.homeTabController presentViewController:alertVc animated:YES completion:nil];
}
-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"bindwx";
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

///进入个人主页界面

- (void)enterUserInfoPage:(NSString *)userId
                     from:(NSString *)fromSource {
    JHUserInfoViewController *vc = [JHUserInfoViewController new];
    vc.userId = userId;
    [self.homeTabController.navigationController pushViewController:vc animated:YES];
}

- (void)enterUserInfoPage:(NSString *)userId
                     user:(User*)user
                     from:(NSString *)fromSource {
    if (user.blRole_appraiseAnchor || user.blRole_imageAppraise) {
        ///鉴定主播
        JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
        vc.anchorId = userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //暂时都跳社区首页，不区分定制师角色
//    else if (roleType == JHUserTypeRoleCustomize) { // 定制师主页
//        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
//        vc.channelLocalId = userId;
//        vc.fromSource = @"businessliveplay";
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else {
        JHUserInfoViewController *vc = [JHUserInfoViewController new];
        vc.userId = userId;
        [self.homeTabController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)enterUserInfoPage:(NSString *)userId
                     from:(NSString *)fromSource
              resultBlock:(UserFollowStatusChangedBlock)block {
    
    JHUserInfoViewController *vc = [JHUserInfoViewController new];
    vc.userId = userId;
    vc.followStatusChangedBlock = ^(NSString * _Nonnull userId, BOOL isFollow) {
        if (block) {
            block(userId, isFollow);
        }
    };
    [self.homeTabController.navigationController pushViewController:vc animated:YES];
}

@end

