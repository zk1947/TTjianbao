//
//  JHSQManager.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHConfigAlertView.h"
#import "JHSQManager.h"
#import "TTjianbaoHeader.h"
#import "LNLaunchVC.h"
#import "JHSignViewController.h"
#import "JHWebViewController.h"
#import "JHGemmologistViewController.h"
#import "JHSelectMerchantViewController.h"
#import "JHSQModel.h"
#import "JHUserInfoModel.h"
#import "JHDynamicViewController.h"
#import "JHPostDetailViewController.h"
#import "JHTopicDetailController.h"
#import "JHPlateDetailController.h"
#import "JHPostDetailModel.h"
#import "JHCustomerInfoController.h"
#import "JHRecycleInfoViewController.h"
#import "JHSelectContractViewController.h"

static NSString *const JHAppLaunchedKey = @"JHAppLaunchedKey";
static NSString *const JHVideoMuteKey = @"JHVideoMuteKey";
static NSString *const JHSQChannelSelectedKey = @"JHSQChannelSelectKey";

@interface JHSQManager ()

///是否已经展示了弹窗
@property (nonatomic, assign) BOOL isShowed;

@end

@implementation JHSQManager

+ (instancetype)shareSQManger {
    static JHSQManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[JHSQManager alloc] init];
    });
    
    return shareManager;
}

+ (BOOL)isFirstLaunch {
    BOOL hasLaunched = [JHUserDefaults boolForKey:JHAppLaunchedKey];
    if (!hasLaunched) {
        [JHUserDefaults setBool:YES forKey:JHAppLaunchedKey];
        return YES;
    }
    return NO;
}

+ (BOOL)needToSelectSQChannel {
    BOOL isSelected = [JHUserDefaults boolForKey:JHSQChannelSelectedKey];
    if (!isSelected) {
        [JHUserDefaults setBool:YES forKey:JHSQChannelSelectedKey];
        return YES;
    }
    return NO;
}

///检查是否需要选择社区频道
 + (void)checkSQChannelNeedToSelectCompleteBlock:(dispatch_block_t)completeBlock
{
    if ([self needToSelectSQChannel]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LNLaunchVC" bundle:nil];
        LNLaunchVC *vc = (LNLaunchVC *)[storyboard  instantiateViewControllerWithIdentifier:@"LNLaunchVC_ID"];
        vc.hideBackBtn = YES;
        vc.completeBlock = completeBlock;
        [JHRootController.homeTabController presentViewController:vc animated:NO completion:nil];
    }
    else if(completeBlock)
    {
        completeBlock();
    }
}

///校验社区文章是否合法
+ (BOOL)isValid:(CBridgeData *)data {
    if (data) {
        NSInteger itemType = data.item_type;
        NSInteger layout = data.layout;
        
        switch (itemType) {
            case JHSQItemTypeArticle:
            case JHSQItemTypeGoods: {
                switch (layout) {
                    case JHSQLayoutTypeImageText:
                    case JHSQLayoutTypeVideo:
                    case JHSQLayoutTypeAppraisalVideo: {
                        return YES;
                    }
                    default:
                        break;
                }
                break;
            }
            case JHSQItemTypeAD: {
                switch (layout) {
                    case JHSQLayoutTypeAD:
                    case JHSQLayoutTypeLiveStore: {
                        return YES;
                    }
                    default:
                        break;
                }
                break;
            }
            case JHSQItemTypeTopic: {
                switch (layout) {
                    case JHSQLayoutTypeTopic: {
                        return YES;
                    }
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
    return NO;
}

+ (BOOL)isMute {
    BOOL isMute = [JHUserDefaults boolForKey:JHVideoMuteKey];
    return isMute;
}

+ (void)setMute:(BOOL)isMute {
    //静音开关通知
    [JHUserDefaults setBool:isMute forKey:JHVideoMuteKey];
    [JHUserDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMuteStateChangedNotication object:nil];
}

//是否需要自动强制进入认证签约页面
+ (BOOL)needAutoEnterMerchantVC {
    JHUserSignInfo *signInfo = [UserInfoRequestManager sharedInstance].levelModel.sign;
    if (signInfo.is_need_sign) { //是否强制签约
        return YES;
    }
    return NO;
}

//进入商家认证
+ (void)enterMerchantVC {
//    JHSelectMerchantViewController *vc = [JHSelectMerchantViewController new];
//    //[self.navigationController pushViewController:vc animated:YES];
//    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
    
    JHUserSignInfo *signInfo = [UserInfoRequestManager sharedInstance].levelModel.sign;
    //0未认证 1已认证 2企业认证中 3企业审核不通过
    if (signInfo.status_real == 1 || signInfo.status_real == 4) { ///已认证  认证通过
        if (signInfo.sign_type == 1) {
            ///已签约
            return;
        }
        if (signInfo.sign_type == 0) {
            ///已认证 未签约 跳转至签约界面
            [self loadSignPageUrl];
            return;
        }
    }
    if (signInfo.status_real == 2) {
        ///认证中 跳转到审核界面
        JHSignViewController *vc = [[JHSignViewController alloc] init];
        vc.checkStatus = JHCheckStatusChecking;  ///审核中
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        return;
    }
    if (signInfo.status_real == 0 || signInfo.status_real == 3) {
        ///未认证/已认证 跳转至公告页
        JHSelectMerchantViewController *vc = [JHSelectMerchantViewController new];
        vc.merchantType = signInfo.real_type;
        vc.authStatus = signInfo.status_real;
        vc.signStatus = signInfo.sign_type;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        return;
    }
}

+ (void)loadSignPageUrl {
    @weakify(self);
    [SVProgressHUD show];
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/contract/sign");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求成功:%@", respondObject.data);
        ///跳转签约界面
        @strongify(self);
        NSString *urlString = respondObject.data[@"url"];
        [self gotoSignFile:urlString];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败:%@ - %zd", respondObject.message, respondObject.code);
        NSString *message = respondObject.message;
        [UITipView showTipStr:message ? message : @"跳转失败"];
    }];
}

+ (void)gotoSignFile:(NSString *)htmlString {
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.urlString =  htmlString;
    webVC.isNeedPoptoRoot = YES;
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 社区普通页面跳转
///进入用户个人主页<内部区分进入直播间、普通用户个人主页、鉴定师主页>
/// 定制二期，定制师进入定制师主页
+ (void)enterUserInfoVCWithPublisher:(JHPublisher *)publisher {
    if (publisher.is_live && [publisher.user_id isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        /// 正在直播,并且是自己
        return;
    }
    if (publisher.is_live && [publisher.room_id isNotBlank] && ![publisher.user_id isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        /// 正在直播，并且有roomId,并且不是自己
        /// 进入直播间
        [JHRootController EnterLiveRoom:publisher.room_id fromString:JHFromSQHomeFeedList];
        return;
    }
    if (publisher.blRole_appraiseAnchor) { //鉴定师
        JHGemmologistViewController *vc = [JHGemmologistViewController new];
        vc.anchorId = publisher.user_id;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        //【埋点】进入鉴定师主页
        [JHGrowingIO trackEventId:JHTrackSQIntoAppraiserHomePage from:JHFromSQHomeFeedList];
        
    } else if (publisher.blRole_customize) { // 定制师主页
        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
        vc.channelLocalId = publisher.room_id;
        vc.fromSource = @"businessliveplay";
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    } else if (publisher.blRole_recycle) { // 回收师主页
        JHRecycleInfoViewController *vc = [[JHRecycleInfoViewController alloc] init];
        vc.channelLocalId = publisher.room_id;
        vc.fromSource = @"businessliveplay";
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    } else {
        [JHRootController enterUserInfoPage:publisher.user_id from:JHFromSQHomeFeedList];
        //【埋点】进入宝友主页
        [JHGrowingIO trackEventId:JHTrackSQIntoUserHomePage from:JHFromSQHomeFeedList];
    }
}

///获取勋章信息
+ (NSArray *)getUserMedalInfo:(JHUserInfoModel *)userInfo {
    NSMutableArray *tempArray = [NSMutableArray array];
    if (userInfo.levelInfo == nil) {
        return tempArray;
    }
    ///设置勋章
    if ([userInfo.levelInfo.role_icon isNotBlank]) {
        [tempArray addObject:userInfo.levelInfo.role_icon];
    }
    if ([userInfo.levelInfo.title_level_icon isNotBlank]) {
        [tempArray addObject:userInfo.levelInfo.title_level_icon];
    }
    if ([userInfo.levelInfo.game_level_icon isNotBlank]) {
        [tempArray addObject:userInfo.levelInfo.game_level_icon];
    }
    if ([userInfo.levelInfo.plate_icon isNotBlank]) {
        [tempArray addObject:userInfo.levelInfo.plate_icon];
    }
    if ([userInfo.levelInfo.cert_icon isNotBlank]) {
        [tempArray addObject:userInfo.levelInfo.cert_icon];
    }
    if ([userInfo.levelInfo.consume_tag_icon isNotBlank]) {
        [tempArray addObject:userInfo.levelInfo.consume_tag_icon];
    }
    return tempArray;
}

+ (BOOL)isAccount:(NSString *)userId {
    userId = OBJ_TO_STRING(userId);
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    return [userId isEqualToString:customerId];
}

+ (BOOL)needLogin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
        return YES;
    }
    return NO;
}

- (void)__showAlertSheetController:(NSArray <NSString *>*)titles isSelf:(BOOL)isSelf actionBlock:(void(^)(JHAlertSheetControllerAction sheetAction,NSString *reason, NSString *reasonId, NSInteger timeType))actionBlock {
    if (self.isShowed) {
        return;
    }
    
    self.isShowed = YES;
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < titles.count; i ++) {
        NSString *str = titles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JHAlertSheetControllerAction type = [self getActionType:str];
            if((type == JHAlertSheetControllerActionDelete) || (type == JHAlertSheetControllerActionWarning) || (type == JHAlertSheetControllerActionBanned))
            {
                if(isSelf) {
                    if (actionBlock) {
                        actionBlock([self getActionType:str], nil, nil, 0);
                    }
                }
                else {
                    [JHSQManager jh_showAlertSheetReasonWithType:type actionBlock:actionBlock];
                }
                self.isShowed = NO;
            }
            else
            {
                if (actionBlock) {
                    self.isShowed = NO;
                    actionBlock([self getActionType:str], nil, nil, 0);
                }
            }
        }];
        [alertV addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            self.isShowed = NO;
            actionBlock(JHAlertSheetControllerActionCancel, nil, nil, 0);
        }
    }];
    [alertV addAction:cancelAction];
    [[JHRootController currentViewController] presentViewController:alertV animated:YES completion:nil];
}

+ (void)jh_showAlertSheetController:(NSArray <NSString *>*)titles isSelf:(BOOL)isSelf actionBlock:(nonnull void (^)(JHAlertSheetControllerAction, NSString * _Nonnull, NSString * _Nonnull, NSInteger))actionBlock {
    [[JHSQManager shareSQManger] __showAlertSheetController:titles isSelf:isSelf actionBlock:actionBlock];
}

/// 删除、警告、禁言 操作弹框
+ (void)jh_showAlertSheetReasonWithType:(JHAlertSheetControllerAction)type actionBlock:(void(^)(JHAlertSheetControllerAction sheetAction,NSString *reason, NSString *reasonId, NSInteger timeType))actionBlock  {
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/bans/tags") Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSLog(@"1");
        
        NSString *typeName = @"";
        switch (type) {
            case JHAlertSheetControllerActionDelete:
                typeName = @"删除";
                break;
                
            case JHAlertSheetControllerActionWarning:
                typeName = @"警告";
                break;
                
            case JHAlertSheetControllerActionBanned:
                typeName = @"禁言";
                break;
                
            default:
                break;
        }
        NSArray *array = respondObject.data;
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSDictionary *dic in array) {
            if(IS_DICTIONARY(dic) && [dic valueForKey:@"value"])
            {
                NSString *value = [dic valueForKey:@"value"];
                NSNumber *reasonId = @([[dic valueForKey:@"label"] integerValue]);
                UIAlertAction *action = [UIAlertAction actionWithTitle:value style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (type == JHAlertSheetControllerActionBanned) {
                        [self jh_showAlertSheetBannedWithReason:value reasonId:reasonId actionBlock:actionBlock];
                    }
                    else
                    {
                        [JHConfigAlertView jh_showConfigAlertViewWithBanned:NO typeName:typeName reason:value timeType:0 complete:^{
                            if(actionBlock)
                            {
                                ///测试代码
                                actionBlock(type,value,reasonId,0);
                            }
                        }];
                    }
                }];
                [alertV addAction:action];
            }
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertV addAction:cancelAction];
        [JHRootController presentViewController:alertV animated:YES completion:nil];

    } failureBlock:^(RequestModel *respondObject) {
        JHTOAST(respondObject.message);
    }];
}

/// 禁言选取时间弹框
+ (void)jh_showAlertSheetBannedWithReason:(NSString *)reason reasonId:(NSString *)reasonId actionBlock:(void(^)(JHAlertSheetControllerAction sheetAction,NSString *reason,NSString *reasonId, NSInteger timeType))actionBlock {
    
    NSArray *array1 = @[@"1天", @"3天", @"7天", @"永久"];
    NSArray *array2 = @[@1, @3, @7, @0];
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (int i = 0; i < array2.count; i++) {
        
        NSString *name = array1[i];
        NSInteger num = [array2[i] integerValue];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [JHConfigAlertView jh_showConfigAlertViewWithBanned:YES typeName:@"禁言" reason:reason timeType:num complete:^{
                if(actionBlock)
                {
                    actionBlock(JHAlertSheetControllerActionBanned,reason,reasonId,num);
                }
            }];
        }];
        [alertV addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertV addAction:cancelAction];
    [JHRootController presentViewController:alertV animated:YES completion:nil];
}

- (JHAlertSheetControllerAction)getActionType:(NSString *)title {
    if ([title isEqualToString:@"回复"]) {
        return JHAlertSheetControllerActionReply;
    }
    if ([title isEqualToString:@"复制"]) {
        return JHAlertSheetControllerActionCopy;
    }
    if ([title isEqualToString:@"删除"]) {
        return JHAlertSheetControllerActionDelete;
    }
    if ([title isEqualToString:@"举报"]) {
        return JHAlertSheetControllerActionReport;
    }
    if ([title isEqualToString:@"警告"]) {
        return JHAlertSheetControllerActionWarning;
    }
    if ([title isEqualToString:@"禁言"]) {
        return JHAlertSheetControllerActionBanned;
    }
    if ([title isEqualToString:@"封号"]) {
        return JHAlertSheetControllerActionBlockAccount;
    }
    
    return 0;
}

+ (NSArray *)commentActions:(JHPostDetailModel *)postDetailInfo comment:(JHCommentModel *)comment {
    NSArray *actions = nil;
    ///先判断是否是版主
    NSString * customerId = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSMutableArray * ownerIds = [[NSMutableArray alloc] init];
    for (JHOwnerInfo *info in postDetailInfo.plateInfo.owners) {
        if ((OBJ_TO_STRING(info.user_id)).length > 0) {
            [ownerIds addObject:OBJ_TO_STRING(info.user_id)];
        }
    }

    if ([ownerIds containsObject:customerId]) {
        ///是版主
        ///判断评论是否是自己发的
        if ([JHSQManager isAccount:comment.publisher.user_id]) {
            ///评论是自己发的
            actions = @[@"回复", @"复制", @"删除"];
        }
        else if ([ownerIds containsObject:comment.publisher.user_id]) {
            ///如果这条评论是板块别的版主发布的 版主用户没有权限删除该条信息
            ///版主看版块内其他版主发的
            actions = @[@"回复", @"复制", @"举报"];
        }
        else {
            ///版主看别人发的
//            actions = @[@"回复", @"复制", @"删除", @"警告", @"禁言", @"封号"];
            actions = @[@"回复", @"复制", @"删除", @"警告", @"禁言"];
        }
    }
    else {
        ///普通用户
        if ([JHSQManager isAccount:comment.publisher.user_id]) {
            ///看自己
            actions = @[@"回复", @"复制", @"删除"];
        }
        else {
            ///看别人
            actions = @[@"回复", @"复制", @"举报"];
        }
    }

    return actions;
}

+ (void)enterCallUsetListPage {
    [JHSQManager enterCallUsetListPage:nil];
}

+ (void)enterCallUsetListPage:(SelectRowBlock)block {
    JHContactListViewController *vc = [[JHContactListViewController alloc] init];
    vc.block = block;
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}

@end


@implementation CBridgeData

@end
