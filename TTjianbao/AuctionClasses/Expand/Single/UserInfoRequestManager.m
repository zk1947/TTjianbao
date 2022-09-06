//
//  UserInfoManager.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/12.
//  Copyright © 2018 Netease. All rights reserved.
//
#import "JHGuestLoginNIMSDKManage.h"
#import "JHActivityAlertView.h"
#import "JHAppAlertViewManger.h"
#import "JHAnniversaryBagView.h"
#import "UserInfoRequestManager.h"
#import "NTESLiveManager.h"
#import "JHWebViewController.h"
#import "JHOrderDetailViewController.h"
#import "ReceiveCoponView.h"
#import "JHWebView.h"
#import "ChannelMode.h"
#import "DBManager.h"
#import "FileUtils.h"
#import "CommAlertView.h"
#import "TTjianbaoBussiness.h"
#import "JHMessageCenterData.h"
#import "JHUnionSignView.h"
#import "JHNimNotificationManager.h"
#import "JHOrderStatusInterface.h"
#import "JHPasteboardManager.h"
@implementation ChannelInfoConfigDict
@end
@implementation OrderStatusTipModel

- (void)setChangeDesCondition:(JHChangeDesCondition)changeDesCondition {
    
    _changeDesCondition = changeDesCondition;
    NSString *changeDidDes = self.desc;
    switch (self.changeDesCondition) {
        case JHChangeDesCondition_Buyers_WaitReceiving_SH:
            changeDidDes = @"";
            break;
        case JHChangeDesCondition_Buyers_WaitPay_SH:
            changeDidDes = @"您所购买的商品由商家直发，源头好物，极速发货，假一赔三，售后无忧。";
            break;
            
        default:
            break;
    }
    self.desc = changeDidDes;
}

@end

@implementation AppInitDataModel
@end
@implementation DictsConfigMode
@end
@implementation UserInfoRequestManager
static UserInfoRequestManager *instance;

+ (instancetype)sharedInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoRequestManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.iswyPhotoServe=YES;
        self.nickRandomNumber=[CommHelp getRandomNumber];
        self.versionSwitch = [[NSUserDefaults standardUserDefaults] objectForKey:@"versionSwitch"]?:@"1";
        self.enableUnion = NO;
        self.isDeepLinkInto = NO;
        self.isFindLandingTarget = NO;
    }
    
    return self;
}

+ (void)destroyInstance{
    
    instance=nil;
}
- (void)netWorkReachable{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                self.netWorkStatus = JHNetWorkUnKnown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                self.netWorkStatus = JHNetWorkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                self.netWorkStatus = JHNetWorkWiFi;
                if (!self.isFindLandingTarget) {
                    [self findLandingTarget];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"4G");
                self.netWorkStatus = JHNetWorkWWAN;
            {
                if (![[NSUserDefaults standardUserDefaults] boolForKey:FirstNet]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:FirstNetNotifaction object:nil];//
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FirstNet];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }else{
                    if ([[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id].length == 0) {
                        [self getGen_session_id];
                    }
                }
                if (!self.isFindLandingTarget) {
                    [self findLandingTarget];
                }
                
            }
                break;
            default:
                break;
        }
        /** 发送网络变化通知*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_NET_STATUS_CHANGE" object:nil];
    }];
    
    
}
-(void)getUserInfo{
    /**
     /auth/customer 新增字段
     authType 认证类型(0未认证、1个人、2企业、3个体户)；
     qualificationState 是否资质审核 （-1:未上传资质 0:审核中 1:审核通过 2:审核未通过）
     */
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/customer/") Parameters:nil successBlock:^(RequestModel *respondObject) {
        User *user = [User mj_objectWithKeyValues:respondObject.data];
        self.user = user;
        [[DBManager getInstance] insert_userTable:user];
        [Growing setUserId:user.customerId];
        
        [[UserInfoRequestManager sharedInstance] getUserLeveIlnfoCompletion:^(JHUserLevelInfoMode *mode, NSError *error) {
        }];
        
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)getApplyMicInfoComplete:(JHFinishBlock)complete{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/connectMic/whichRoom") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHApplyMicRoomMode * mode = [JHApplyMicRoomMode mj_objectWithKeyValues:respondObject.data];
        [JHNimNotificationManager sharedManager].micWaitMode.isWait = mode.isWait;
        [JHNimNotificationManager sharedManager].micWaitMode.singleWaitSecond = mode.singleWaitSecond;
        [JHNimNotificationManager sharedManager].micWaitMode.waitCount = mode.waitCount;
        [JHNimNotificationManager sharedManager].micWaitMode.waitRoomId = mode.roomId;
        [JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId = mode.channelLocalId;
        [JHNimNotificationManager sharedManager].micWaitMode.waitAppraiseId = mode.appraiseId;
        if (complete) {
            complete();
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        if (complete) {
            complete();
        }
        //        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message?:@"" duration:1.0 position:CSToastPositionBottom];
    }];
}
-(void)getApplyCustomizeInfo:(NSString *)currentRoomId finishComplete:(JHFinishBlock)complete{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/whichRoom") Parameters:@{@"currentRoomId":currentRoomId} successBlock:^(RequestModel *respondObject) {
        JHApplyMicRoomMode * mode = [JHApplyMicRoomMode mj_objectWithKeyValues:respondObject.data];
        [JHNimNotificationManager sharedManager].customizeWaitMode.isWait = mode.isWait;
        [JHNimNotificationManager sharedManager].customizeWaitMode.singleWaitSecond = mode.singleWaitSecond;
        [JHNimNotificationManager sharedManager].customizeWaitMode.waitCount = mode.waitCount;
        [JHNimNotificationManager sharedManager].customizeWaitMode.waitRoomId = mode.roomId;
        [JHNimNotificationManager sharedManager].customizeWaitMode.waitChannelLocalId = mode.channelLocalId;
        [JHNimNotificationManager sharedManager].customizeWaitMode.customizeId = mode.customizeId;
        if (complete) {
            complete();
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        if (complete) {
            complete();
        }
        //    [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message?:@"" duration:1.0 position:CSToastPositionBottom];
    }];
}
-(void)getApplyRecycleInfo:(NSString *)currentRoomId finishComplete:(JHFinishBlock)complete{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/recycle/connectMic/whichRoom") Parameters:@{@"currentRoomId":currentRoomId} successBlock:^(RequestModel *respondObject) {
        
        DDLogInfo(@"数据====%@",respondObject.data);
        JHApplyMicRoomMode * mode = [JHApplyMicRoomMode mj_objectWithKeyValues:respondObject.data];
        [JHNimNotificationManager sharedManager].recycleWaitMode.isWait = mode.isWait;
        [JHNimNotificationManager sharedManager].recycleWaitMode.singleWaitSecond = mode.singleWaitSecond;
        [JHNimNotificationManager sharedManager].recycleWaitMode.waitCount = mode.waitCount;
        [JHNimNotificationManager sharedManager].recycleWaitMode.waitRoomId = mode.roomId;
        [JHNimNotificationManager sharedManager].recycleWaitMode.waitChannelLocalId = mode.channelLocalId;
        [JHNimNotificationManager sharedManager].recycleWaitMode.applyId = mode.applyId;
        if (complete) {
            complete();
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        if (complete) {
            complete();
        }
        //    [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message?:@"" duration:1.0 position:CSToastPositionBottom];
    }];
}
- (void)getUserInfoSuccess:(succeedBlock)success{
    [self getUserInfoSuccess:success failure:nil];
}

- (void)getUserInfoSuccess:(succeedBlock)success failure:(failureBlock)failure{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/customer/") Parameters:nil successBlock:^(RequestModel *respondObject) {
        User *user = [User mj_objectWithKeyValues:respondObject.data];
        self.user = user;
        [[DBManager getInstance] insert_userTable:user];
        [Growing setUserId:user.customerId];
        NSLog(@"tiantianjiaobao>login>customerId:%@ ~~~~~~~\n", user.customerId);
        [[UserInfoRequestManager sharedInstance] getUserLeveIlnfoCompletion:^(JHUserLevelInfoMode *mode, NSError *error) {
            if (success) {
                success(respondObject);
            }
        }];
        
    } failureBlock:^(RequestModel *respondObject) {
        if(failure)
        {
            failure(respondObject);
        }
    }];
}
- (void)findLandingTarget{
    self.isFindLandingTarget = YES;//
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"2" forKey:@"appType"];
    [params setValue:[CommHelp deviceIDFA] forKey:@"imid"];
    /// 宋诗超 让传的固定值
    [params setValue:@"364" forKey:@"versionNum"];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/anon/operation/findLandingTarget") Parameters:params requestSerializerType:RequestSerializerTypeJson
                    successBlock:^(RequestModel *respondObject) {
        if ([respondObject.data isKindOfClass:[NSDictionary class]]) {
            JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:respondObject.data];
            if (router && router.vc) {
                [UserInfoRequestManager sharedInstance].isDeepLinkInto = YES;
            }
            [JHRouterManager deepLinkRouter:router];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)findLandingTargetWithProductId:(NSString *)productId {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"2" forKey:@"appType"];
    [params setValue:[CommHelp deviceIDFA] forKey:@"imid"];
    [params setValue:@"364" forKey:@"versionNum"];
    [params setValue:productId forKey:@"productId"];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/anon/operation/findLandingTarget") Parameters:params requestSerializerType:RequestSerializerTypeJson
                    successBlock:^(RequestModel *respondObject) {
        if ([respondObject.data isKindOfClass:[NSDictionary class]]) {
            JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:respondObject.data];
            [JHRouterManager deepLinkRouter:router];
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"failureBlock");
    }];
}

- (void)getGen_session_id{
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/gen-session-id") Parameters:@{@"sessionId":[CommHelp getKeyChainUUID]} requestSerializerType:RequestSerializerTypeJson
                    successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        if ([respondObject.data isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:respondObject.data[@"securitySessionId"] forKey:Gen_Session_Id ];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        [[JHGuestLoginNIMSDKManage sharedInstance] requestGuestNimInfo];
        [self getisFirstDay];
    } failureBlock:^(RequestModel *respondObject) {
        [[JHGuestLoginNIMSDKManage sharedInstance] requestGuestNimInfo];
    }];
}
- (void)refreshToken{
    
    if ([JHRootController isLogin]) {
        [JHTracking loginedUserID:[UserInfoRequestManager sharedInstance].user.customerId];
    }
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/refreshTk") Parameters:nil requestSerializerType:RequestSerializerTypeHttp
                    successBlock:^(RequestModel *respondObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:respondObject.data forKey:IDTOKEN ];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //加载个人数据
        if ([JHRootController isLogin]) {
            [[UserInfoRequestManager sharedInstance] getUserInfo];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        if (respondObject.code != 401) return;
        [JHRootController logoutAccountDataIsShowLogin:false];
    }];
    
}
- (void)getLoginWay{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/ios/loginWay") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        self.loginway=[[NSString stringWithFormat:@"%@",respondObject.data] intValue];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
    
}
- (void)getVideoCate:(succeedBlock)success{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/cate/videoCate") Parameters:nil successBlock:^(RequestModel *respondObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if ([FileUtils writeDataToFile:CateData data:[NSJSONSerialization dataWithJSONObject:respondObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                NSLog(@"写入成功");
            }
        });
        if (success) {
            success(respondObject);
        }
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
    
}
- (void)syncServeTime{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/syncTime") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[respondObject.data doubleValue]/1000];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[ [CommHelp getNowTimeTimestamp] doubleValue]/1000];
        NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
        NSLog(@"时间date%@", respondObject.data);
        NSLog(@"时间date%@",  [CommHelp getNowTimeTimestamp]);
        NSLog(@"时间date相隔：%f", seconds);
        self.timeDifference=seconds;
        
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)setDataWithModel:(AppInitDataModel *)model {
    
    if (model) {
        self.loginway = [model.loginway intValue];
        self.oneTouchImgUrl = model.oneTouchImgUrl;
        if ([model.showActivityFlag isEqualToString:@"1"]) {
            self.showActivityFlag = YES;
        }else{
            self.showActivityFlag = NO;
        }
        self.activityIcon = model.activityIcon;
        
        if([model.hiddenHomeSaleTips isEqualToString:@"1"])
            self.hiddenHomeSaleTips = YES;
        else
            self.hiddenHomeSaleTips = NO;
        
        if (model.orderConfigDict && [model.orderConfigDict isKindOfClass:[NSDictionary class]]) {
            self.customizedIntentionPriceMax = model.orderConfigDict[@"customizedIntentionPriceMax"]?model.orderConfigDict[@"customizedIntentionPriceMax"]:@"1";
        }
        
        self.iswyPhotoServe = [model.imgServer boolValue];
        
        if (model.roomReportShow) {
            self.roomReportShow = [model.roomReportShow boolValue];
        }
        self.temporaryMuteTimes = model.temporaryMuteTimes;
        self.infoConfigDict = [ChannelInfoConfigDict mj_objectWithKeyValues:model.infoConfigDict];
        self.orderCategoryIcons = model.orderCategoryIcons;
        [self downloadOrderCategoryImages];
        
        if (model.versionSwitch&&![self.versionSwitch isEqualToString:model.versionSwitch] ) {
            self.versionSwitch = model.versionSwitch;
            [[NSUserDefaults standardUserDefaults] setObject:model.versionSwitch forKey:@"versionSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:MallSwitchNotifaction object:nil];
        }
        // self.enableUnion = model.enableUnion;
        
    }
    //    self.loginway=[[NSString stringWithFormat:@"%@",respondObject.data[@"loginWay"]] intValue];
    //    self.iswyPhotoServe=[respondObject.data[@"imgServer"] boolValue];
    //
    //    self.temporaryMuteTimes = respondObject.data[@"temporaryMuteTimes"];
    //    if (respondObject.data[@"roomReportShow"]) {
    //        self.roomReportShow = [respondObject.data[@"roomReportShow"] boolValue];
    //    }
    //
    //    self.infoConfigDict = [ChannelInfoConfigDict mj_objectWithKeyValues:respondObject.data[@"infoConfigDict"]];
    //    self.orderCategoryIcons=respondObject.data[@"orderCategoryIcons"];
}
- (void)getisFirstDay{
    NSDictionary * dic = [JHTracking presetProperties];
    NSString * isfirstDay = dic[@"$is_first_day"];
    NSDictionary * dict = @{@"isFirstDay":[isfirstDay boolValue]?@"1":@"0"};
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/uploadNewUser") Parameters:dict successBlock:^(RequestModel *respondObject) {
    } failureBlock:^(RequestModel *respondObject) {
    }];
}
- (void)getAppInitData:(JHFinishBlock)complete{
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"appInitData"];
    if (data) {
        AppInitDataModel *model = [AppInitDataModel mj_objectWithKeyValues:[data mj_JSONObject]];
        [self setDataWithModel:model];
    }
    
    NSDictionary * dic = [JHTracking presetProperties];
    NSString * isfirstDay = dic[@"$is_first_day"];
    NSDictionary * dict = @{@"isFirstDay":[isfirstDay boolValue]?@"1":@"0"};
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/appInitData") Parameters:dict successBlock:^(RequestModel *respondObject) {
        AppInitDataModel *model = [AppInitDataModel mj_objectWithKeyValues:respondObject.data];
        
        [self setDataWithModel:model];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[model mj_keyValues] mj_JSONString] forKey:@"appInitData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [JHPasteboardManager pasteboardParse];
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
- (void)getOrderStatusTip{
    
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderStatusTip"];
    if (data) {
        self.orderStatusTipArr = [OrderStatusTipModel mj_objectArrayWithKeyValuesArray:[data mj_JSONObject]];
    }
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/orderStatusTips") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.orderStatusTipArr = [OrderStatusTipModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [[NSUserDefaults standardUserDefaults] setObject:[respondObject.data mj_JSONString] forKey:@"OrderStatusTip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
- (void)getCateAllWithType:(NSInteger)type successBlock:(succeedBlock) success failureBlock:(failureBlock)failure {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/cate/all") Parameters:@{@"type":@(type)} successBlock:^(RequestModel *respondObject) {
        self.pickerDataArray = respondObject.data;
        if (success) {
            success(respondObject);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (failure) {
            failure(respondObject);
        }
    }];
}

/*
 * v3.8.8 飞单修改品类信息
 */
- (void)getNewFlyOrder_successBlock:(succeedBlock)success failureBlock:(failureBlock)failure {
    /// v3.8.8 新版本飞单使用
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/shop-lines-contract/contractCategory") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.feidanPickerDataArray = respondObject.data;
        if (success) {
            success(respondObject);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (failure) {
            failure(respondObject);
        }
    }];
}

- (void)bindDeviceToken:(succeedBlock)success{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/addPushAccount") Parameters:@{@"portalEnum":@"jios_push",@"account":self.registrationID?:@""} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
        if (success) {
            success(respondObject);
        }
    }
                    failureBlock:^(RequestModel *respondObject) {
        
    }];
}
- (void)unBindDeviceToken:(succeedBlock)success{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/delPushAccount") Parameters:@{@"account":self.registrationID?:@""} requestSerializerType:RequestSerializerTypeHttp
                    successBlock:^(RequestModel *respondObject) {
        
        if (success) {
            success(respondObject);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
- (void)getUserLeveIlnfoCompletion:(JHUserLevelInfoHandler)completion{
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    [HttpRequestTool getWithURL: COMMUNITY_FILE_BASE_STRING(@"/user/homePageNew") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        [subject1 sendNext:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(nil,error);
        }
    }];
    
    // 3.7.0新增获取店铺关注数
    NSString *url = FILE_BASE_STRING(@"/auth/mall/follow/info");
    
    [HttpRequestTool postWithURL:url Parameters:@{} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if(IS_DICTIONARY(respondObject.data))
        {
            [subject2 sendNext:respondObject.data];
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [subject2 sendNext:nil];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(nil,error);
        }
    }];
    
    RACSignal *combin = [subject1 combineLatestWith:subject2];
    
    [combin subscribeNext:^(id  _Nullable x) {
        if (x == nil) { return; }
        JHUserLevelInfoMode * mode;
        if (x[0] != nil) {
            mode= [JHUserLevelInfoMode mj_objectWithKeyValues: x[0]];
            self.levelModel = mode;
        }
        if (x[1] != nil && mode != nil) {
            NSDictionary *shopDic = (NSDictionary *)x[1];
            mode.follow_num += (int)[shopDic integerValueForKey:@"shopNum" default:0];
        }
        
        NSError *error=nil;
        if (completion) {
            completion(mode,error);
        }
    }];
    
}
- (void)getAppraiseIssuelnfoCompletion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/order/problemOrder") Parameters:nil successBlock:^(RequestModel *respondObject) {
        OrderMode * mode= [OrderMode mj_objectWithKeyValues:respondObject.data];
        if (!mode.orderId) {
            return ;
        }
        if ([CommHelp checkTheDate:[[NSUserDefaults standardUserDefaults] objectForKey:[AppraiseIssueLastDate stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]]]) {
            return ;
        }
        
        JHAppAlertModel *m = [JHAppAlertModel new];
        m.type = JHAppAlertTypeAppraiseProblem;
        m.localType = JHAppAlertLocalTypeHome;
        m.typeName = AppAlertAppraiseProblem;
        m.body = mode.orderId;
        [JHAppAlertViewManger addModelArray:@[m]];
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}
- (void)getDictsConfig:(JHApiRequestHandler)completion{
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/index/getDictsByGroupCodes") Parameters:@{@"groupCodes":@"AppOrderCategory,StoneRestoretransitionState,orderCateType"} successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        self.dictConfigMode=[DictsConfigMode mj_objectWithKeyValues:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

- (void)getHomePageActivitylnfoCompletion:(JHApiRequestHandler)completion{
    // [JHMessageCenterData requestSyncMessage];//启动时调用,同步聚合消息
    
    /// 活动
    [JHActivityAlertView getActivityAlertViewWithLocation:2];
    
    /// 签约状态查询
    [JHUnionSignView getUnionSignStatusWithCustomerId:nil statusBlock:nil];
    
    [[UserInfoRequestManager sharedInstance] getRecommendSwitch];
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/activity/getUserActivityInformation") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.homeActivityMode = [JHHomeActivityMode mj_objectWithKeyValues:respondObject.data];
        
        self.anniversaryType = (self.homeActivityMode.isZhouNianBegin == 1)? 2 : 1;
        ///周年庆
        if(self.homeActivityMode.zhouNianTip == 1)
        {
            self.anniversaryViewShow = YES;
        }
        
        /// 周年庆红包 未登录  下个版本可以删除
        if (![JHRootController isLogin]) {
            if ((self.homeActivityMode.isZhouNianBegin == 1)&&[CommHelp isFirstTodayForName:@"activity_anniversary"]) {
                self.anniversaryViewShow = YES;
            }
        }
        
        
        if ([self.homeActivityMode.padageComerId length]>0) {
            if ([CommHelp checkTheDate:[[NSUserDefaults standardUserDefaults ] objectForKey:[LiveLASTDATE stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]]]) {
                return ;
            }
            ReceiveCoponView * copon=[[ReceiveCoponView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH)];
            [[UIApplication sharedApplication].keyWindow addSubview:copon];
            copon.block = ^{
                if (![JHRootController isLogin]) {
                    [JHRootController presentLoginVC];
                }
            };
        }
        
        if ([self.homeActivityMode.homeActivityIcon.imgUrl length]>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HomePageActivityABtnNotifaction object:nil];
        }
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
    
}

- (User *)user {
    if (!_user) {
        if ([JHRootController isLogin]) {
//            NSString *userStr = [[NSUserDefaults standardUserDefaults] stringForKey:@""];
//            User *user = [User mj_JSONObject];
            _user =  [[DBManager getInstance] select_userTable_info];
        }
    }
    return _user;
}

- (BOOL)sameUser:(NSString*)customId
{
    if([customId length] > 0 && [_user.customerId isEqualToString:customId])
        return YES;
    return NO;
}
//普通用户=0,即观众
- (BOOL)commonUser
{
    if([UserInfoRequestManager sharedInstance].user.blRole_default)
        return YES;
    return NO;
}
- (NSMutableDictionary *)getEnterChatRoomExtWithChannel:(ChannelMode *)channel {
    
    User *user = self.user;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"customerId"] = user?user.customerId:@"";
    dic[@"bought"] = @(channel.bought);
    dic[@"boughtOther"] = @(channel.boughtOther);
    dic[@"liveId"] = channel.currentRecordId;
    dic[@"nick"] = user?user.name:@"";
    dic[@"avatar"] = user?user.icon:@"";
    dic[@"gameGrade"] = user?@(user.gameGrade):@(0);
    dic[@"type"] = user?@(user.type):@"0";
    dic[@"tempMuted"] = @(channel.isMutedInRoom);
    dic[@"roomRole"] = @(channel.isAssistant?JHRoomRoleAssistant:JHRoomRoleAndience);
    dic[@"userTitleLevelIcon"] = self.levelModel?self.levelModel.title_level_icon:nil;
    dic[@"userTitleLevel"] = self.levelModel?self.levelModel.title_level:@"0";
    
    if ([channel.channelType isEqualToString:@"appraise"]) {
        dic[@"gameGradeIcon"] = self.levelModel?self.levelModel.game_level_icon:@"";
    }

    dic[@"userLevelType"] = channel.userLevelType?:@"0";
    dic[@"userLevelName"] = channel.userLevelName?:@"";
    dic[@"levelImg"] = channel.levelImg?:nil;
    
    
    if (self.levelModel.enter_effect_expire>time(NULL)) {
        dic[@"userEnterEffect"] =  self.levelModel?self.levelModel.enter_effect:@"";
    }else {
        if (self.levelModel.enter_effect_expire>0) {
            [self getUserLeveIlnfoCompletion:^(JHUserLevelInfoMode *mode, NSError *error) {
                
            }];
        }
    }
    
    
    dic[@"userTycoonLevel"] = @(user.hasBigCustomer);
    dic[@"userTycoonLevelIcon"] = user.userTycoonLevelIcon;
    dic[@"userMsgColor"] = user.hasBigCustomer?@"EA00FF":@"FFFFFF";
    
    
    return dic;
}
- (NSString *)findValue:(NSDictionary*)dict byKey:(NSString *)key
{
    for (NSString * string in dict.allKeys){
        if ([key isEqualToString:string]) {
            return dict[key];
        }
    }
    return nil;
}

+ (OrderStatusTipModel *)findOrderTip:(NSString *)status
{
    NSArray * arr = [UserInfoRequestManager sharedInstance].orderStatusTipArr;
    for (OrderStatusTipModel *tipModel in arr ) {
        if ([tipModel.orderStatus isEqualToString:status]) {
            return tipModel;
        }
    }
    return nil;
}

+ (OrderStatusTipModel *)findNewTip:(JHChangeDesCondition)condition
                             status:(NSString *)status {
    NSArray * arr = [UserInfoRequestManager sharedInstance].orderStatusTipArr;
    for (OrderStatusTipModel *tipModel in arr ) {
        if ([tipModel.orderStatus isEqualToString:status]) {
            tipModel.changeDesCondition = condition;
            return tipModel;
        }
    }
    return nil;
}

-(void)downloadOrderCategoryImages{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        self.orderCategoryIconImages= [NSMutableDictionary dictionaryWithCapacity:10];
        for (NSString *key  in self.orderCategoryIcons.allKeys ) {
            UIImage * image;
            NSString *url = self.orderCategoryIcons[key];
            if (url) {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                image = [UIImage imageWithData:data];
                [self.orderCategoryIconImages setObject:image forKey:key];
            }
            else{
                [self.orderCategoryIconImages setObject:[NSNull null] forKey:key];
            }
        }
    });
}

///推荐的开关
- (void)getRecommendSwitch
{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/customer/recommendInfo") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *data = respondObject.data;
        if(IS_DICTIONARY(data) && [data valueForKey:@"isAcceptRecommend"])
        {
            BOOL isRecommend = ([[data valueForKey:@"isAcceptRecommend"] intValue] == 1);
            [[NSUserDefaults standardUserDefaults] setBool:isRecommend forKey:NSUserDefaultsServerRecommendCloseSwitch];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSLog(@"1");
    }];
}

@end
