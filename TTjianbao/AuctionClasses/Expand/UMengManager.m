//
//  UMengManager.m
//  KGLibrary
//
//  Created by yaoyao on 2017/11/13.
//  Copyright © 2017年 yaoyao. All rights reserved.
//

#import "UMengManager.h"
//#import <UMAnalytics/MobClick.h>
#import <UShareUI/UShareUI.h>
#import <UMCommon/UMCommon.h>
#import "JHBaseOperationView.h"
//#import <TencentOpenAPI/QQApiInterface.h>
#import <UMAnalytics/MobClick.h>
#import "UMShareView.h"
#import "TTjianbaoBussiness.h"

#import "TTjianbaoHeader.h"
#import <UTDID/UTDevice.h>
static UMengManager *instance = nil;
@interface UMengManager()<UIAlertViewDelegate>
//@property(nonatomic, strong)UIViewController *target;
@property (nonatomic, strong)NSDictionary *userInfo;
@end
@implementation UMengManager


+ (UMengManager*)shareInstance{
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        instance = [[UMengManager alloc] init];
    });
    
    return instance;
}

- (void)setUMeng:(NSDictionary*)launchOptions{
   
    [UMConfigure initWithAppkey:UMengAppKey channel:UMengChannel];
//#if DEBUG
//[MobClick setCrashReportEnabled:NO];
//#else
//[MobClick setCrashReportEnabled:YES];
//#endif
    


    
//    if ([UtilsFactory token]) {
//        [MobClick profileSignInWithPUID:[OperatorManager getUserOperator].account.uid];
//
//    }else {
//        [MobClick profileSignInWithPUID:[UtilsFactory getIDFV]];
//
//    }
    
    [self setUpUmengShare];

    [self umengPushWithLaunchOptions:launchOptions];
    
}


- (void)umengPushWithLaunchOptions:(NSDictionary *)launchOptions {
//    //友盟推送
//    // Push组件基本功能配置
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
//
//
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//        }else{
//        }
//    }];
}

//注册友盟分享
- (void)setUpUmengShare{
    
    NSLog(@"umSocialSDKVersion: %@", [UMSocialGlobal umSocialSDKVersion]);
    //是否打开调试日志
    [[UMSocialManager defaultManager] openLog:NO];
    //设置友盟Appkey
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppKey];
    //当前网络请求是否用https
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):JHEnvVariableDefine.universalLink, @(UMSocialPlatformType_WechatTimeLine): JHEnvVariableDefine.universalLink};
    //设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppKey appSecret:WXAppSecret redirectURL:@""];
//    
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WXAppKey appSecret:WXAppSecret redirectURL:@""];
//    
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatFavorite appKey:WXAppKey appSecret:WXAppSecret redirectURL:@""];
    
    //设置分享到QQ互联的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppKey  appSecret:QQAppSecret redirectURL:@""];
//
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:QQAppKey  appSecret:QQAppSecret redirectURL:@""];
//
//    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppKey  appSecret:SinaAppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}


- (BOOL)handleOpenURL:(NSURL*)url{
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (void)buryWithType:(ShareObjectType)type plat:(NSInteger)platformType
            pageFrom:(JHPageFromType)pageFrom
              object:(NSString *)objectFlag {

    NSString *to = @"";
    SharePlatformType plat = 0;
    if (platformType == UMSocialPlatformType_QQ) {
        plat = SharePlatformTypeQQ;
        to = @"QQ";
    }else if (platformType == UMSocialPlatformType_WechatSession) {
        plat = SharePlatformTypeWeiXin;
        to = @"微信";
    }else if (platformType == UMSocialPlatformType_WechatTimeLine){
        plat = SharePlatformTypeWeiCircle;
        to = @"微信";
    }

    NSInteger from = 1;
    
    switch (type) {
        case ShareObjectTypeAppraiseLive: // 鉴定直播 0
        case ShareObjectTypeSaleLive: //卖货直播 1
        case ShareObjectTypeAnchorAppraisePreview: //主播鉴定开播预览 3
        case ShareObjectTypeAnchorSalePreview: //主播卖货开播预览 4
            from = 1;
            break;
        case ShareObjectTypeAppraiseVideo: //鉴定视频 2
            from = 3;
            break;
        case ShareObjectTypeReport: //评估报告 5
            from = 2;
            break;
        case ShareObjectTypeSaleReport: //订单评估报告 6
            from = 4;
            break;
        case ShareObjectTypeSocialArticial: //社区文章 7
            ///之前这块固定写的5 现在为了区分页面换了  --- lihui
            from = pageFrom;
            break;
        case ShareObjectTypeSocialFriend: //社区宝友 8
            from = 6;
            break;
        case ShareObjectTypeWebShare: //h5调起分享 9
            from = 7;
            break;
        case ShareObjectTypeSaleReportComment: //从评价分享卖货评估报告 10
            from = 8;
            break;
        case ShareObjectTypeStoreShop: //社区商城 - 店铺
        case ShareObjectTypeStoreSpecialTopic: //社区商城 - 专题
        case ShareObjectTypeStoreGoodsDetail: //社区商城 - 商品详情
            from = 9;
            break;
        default:
            break;
    }
    
    JHBuryPointShareModel *model = [[JHBuryPointShareModel alloc] init];
    model.from = [NSString stringWithFormat:@"%ld", (long)from];
    model.to = to;
    model.to_type = plat;
    model.object_type = type;
    model.object_flag = objectFlag;
    
    [[JHBuryPointOperator shareInstance] shareBuryWithModel:model];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title
                              text:(NSString *)text
                          thumbUrl:(NSString *)thumbURL
                            webURL:(NSString *)url
                              type:(ShareObjectType)type
                          pageFrom:(JHPageFromType)pageFrom
                            object:(id)objectFlag

{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:thumbURL];
    if (!thumbURL) {
        shareObject.thumbImage = [UIImage imageNamed:@"LOGO"];
    }else {
        shareObject.thumbImage = thumbURL;
    }
    
    //设置网页地址
    if ([UserInfoRequestManager sharedInstance].user) {
        if (url) {
            if ([url hasSuffix:@"?"]) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"shareid=%@", [UserInfoRequestManager sharedInstance].user.invitationCode]];

            } else {
                url = [NSString stringWithFormat:@"%@&shareid=%@",url, [UserInfoRequestManager sharedInstance].user.invitationCode];
                
            }
            
            url = [NSString stringWithFormat:@"%@&customerId=%@",url, [UserInfoRequestManager sharedInstance].user.customerId];

        }
    }
    
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    MJWeakSelf
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(UMSocialShareResponse *data, NSError *error) {
        
        if (type == ShareObjectTypeSocialArticial || type == ShareObjectTypeSocialFriend) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddShareCountNoticeName object:nil];
        }

        VideoExtendModel *model = [JHGrowingIO videoExtendModel:self.appraisalDetailMode];
        if (error) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"分享失败" duration:2.0 position:CSToastPositionCenter];
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            if (type == ShareObjectTypeAppraiseVideo) {
                [JHGrowingIO trackEventId:JHTrackvideo_detail2_share_fail variables:[model mj_keyValues]];

            }else if (type == ShareObjectTypeSaleLive || type == ShareObjectTypeAppraiseLive) {
                [JHGrowingIO trackEventId:JHTracklive_share_fail variables:[JHRootController.serviceCenter.channelModel mj_keyValues]];

            }else if (type == ShareObjectTypeAgentPay) {
                [JHGrowingIO trackOrderEventId:JHTrackreplacePay_payResult orderCode:objectFlag payWay:@"replacePay" suc:@"false"];

            }

        }
        else
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"分享成功" duration:2.0 position:CSToastPositionCenter];
            if (type == ShareObjectTypeAppraiseVideo) {
                [JHGrowingIO trackEventId:JHTrackvideo_detail2_share_suc variables:[model mj_keyValues]];

            }else if (type == ShareObjectTypeSaleLive || type == ShareObjectTypeAppraiseLive) {
                [JHGrowingIO trackEventId:JHTracklive_share_suc variables:[JHRootController.serviceCenter.channelModel mj_keyValues]];

            }else if (type == ShareObjectTypeAgentPay) {
                [JHGrowingIO trackOrderEventId:JHTrackreplacePay_payResult orderCode:objectFlag payWay:@"replacePay" suc:@"true"];
            }
            
            //分享成功通知
            [JHNotificationCenter postNotificationName:kShareSuccessNotification object:nil];

            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@", resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                if ([objectFlag isKindOfClass:[NSString class]]) {
                    [weakSelf buryWithType:type plat:platformType pageFrom:pageFrom object:objectFlag];

                } else if ([objectFlag isKindOfClass:[NSDictionary class]]) {
                    
                    if (type == ShareObjectTypeWebShare) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameShareFinish" object:objectFlag];
                        [weakSelf buryWithType:type plat:platformType pageFrom:pageFrom object:@""];
                        return ;
                    }
                    NSString *currentId = objectFlag[@"currentRecordId"];
                    
                    if (currentId) {
                        [weakSelf buryWithType:type plat:platformType pageFrom:pageFrom object:currentId];
                    }
                    NSString *roomId = [objectFlag valueForKey:@"roomId"];
                    if (roomId) {
                        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/share") Parameters:@{@"roomId":roomId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
                            if(type == ShareObjectTypeSaleLive)
                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRedPacketShareSuccess object:nil];
                            }
                        } failureBlock:^(RequestModel *respondObject) {
                            [[UIApplication sharedApplication].keyWindow makeToast:@"失败，请重试" duration:2.0 position:CSToastPositionCenter];
                        }];
                    }
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameCommentRedPocket" object:nil];
                
            } else {
                UMSocialLogInfo(@"response data is %@",data);
            }

        }
        
    }];
}

- (void)shareVideoToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title
                              text:(NSString *)text
                          thumbUrl:(NSString *)thumbURL
                            webURL:(NSString *)url
                              type:(NSInteger)type
{

    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:text thumImage:thumbURL];
    if (!thumbURL) {
        shareObject.thumbImage = [UIImage imageNamed:@"icon_logo"];
    }
    
    //url = @"ygtoutiao://sunshine.app.com?";
    //设置网页地址
    shareObject.videoUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


//分享图片
- (void)showShareImageWithTarget:(id)target
                           title:(NSString *)title
                            text:(NSString *)text
                        thumbUrl:(id)thumbURL
                            type:(ShareObjectType)type
                          object:(id)objectFlag {
    
    [self showShareImageWithTarget:target title:title text:text thumbUrl:thumbURL type:type object:objectFlag showReport:NO];
}

///v2.2.4 新增showReport - 是否显示举报，默认隐藏
- (void)showShareImageWithTarget:(id)target
                           title:(NSString *)title
                            text:(NSString *)text
                        thumbUrl:(id)thumbURL
                            type:(ShareObjectType)type
                          object:(id)objectFlag
                      showReport:(BOOL)showReport
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self isInstall:UMSocialPlatformType_WechatSession]) {
        //        [self.target.view makeToast:@"没有安装微信" duration:1. position:CSToastPositionCenter];
        [array addObject:@(UMSocialPlatformType_WechatSession)];
        [array addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
//    if ([self isInstall:UMSocialPlatformType_QQ]) {
//        [array addObject:@(UMSocialPlatformType_QQ)];
//    }
    
    [UMSocialUIManager setPreDefinePlatforms:array];
    
    if (showReport) {
        [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                         withPlatformIcon:[UIImage imageNamed:@"share_icon_report"]
                                         withPlatformName:@"举报"];
    }
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    MJWeakSelf
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            if (weakSelf.shareReportBlock) {
                weakSelf.shareReportBlock();
            }
            
        } else {
            [weakSelf shareImageToPlatformType:platformType title:title text:text thumbUrl:thumbURL type:type object:objectFlag];
        }
        
    }];
}
    

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
                           title:(NSString *)title
                            text:(NSString *)text
                        thumbUrl:(id)thumbURL
                            type:(ShareObjectType)type
                          object:(id)objectFlag {
    if (!thumbURL) {
        thumbURL = [UIImage imageNamed:@"icon_logo"];
    }
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *imageObject = [UMShareImageObject shareObjectWithTitle:title descr:text thumImage:thumbURL];
    imageObject.shareImage = thumbURL;
    messageObject.shareObject = imageObject;


        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
}

     
- (void)showShareWithTarget:(id)target
                      title:(NSString *)title
                       text:(NSString *)text
                   thumbUrl:(NSString *)thumbURL
                     webURL:(NSString *)url
                       type:(ShareObjectType)type
                     object:(id)objectFlag
{
//    JHShareInfo* info = [JHShareInfo new];
//    info.title = title;
//    info.desc = text;
//    info.img = thumbURL;
//    info.url = url;
//    [JHBaseOperationView creatShareOperationView:info object_flag:objectFlag];
//    return;
    [self showShareWithTarget:target title:title text:text thumbUrl:thumbURL webURL:url type:type object:objectFlag showReport:NO];
}

///v2.2.4 新增showReport - 是否显示举报，默认隐藏
- (void)showShareWithTarget:(id)target
                      title:(NSString *)title
                       text:(NSString *)text
                   thumbUrl:(NSString *)thumbURL
                     webURL:(NSString *)url
                       type:(ShareObjectType)type
                     object:(id)objectFlag
                 showReport:(BOOL)showReport
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self isInstall:UMSocialPlatformType_WechatSession]) {
        [array addObject:@(UMSocialPlatformType_WechatSession)];
        [array addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
//    if ([self isInstall:UMSocialPlatformType_QQ]) {
//        [array addObject:@(UMSocialPlatformType_QQ)];
//    }
    
    [UMSocialUIManager setPreDefinePlatforms:array];
    
    if (showReport) {
        [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                         withPlatformIcon:[UIImage imageNamed:@"share_icon_report"]
                                         withPlatformName:@"举报"];
    }
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    MJWeakSelf
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            NSLog(@"举报");
            if (weakSelf.shareReportBlock) {
                weakSelf.shareReportBlock();
            }
            
        } else {
             //url中文转码
             NSString *imgUrl = [thumbURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             if (type == ShareObjectTypeAppraiseVideo) {
                 if (platformType == UMSocialPlatformType_WechatSession) {
                     [JHGrowingIO trackEventId:JHTrackvideo_detail2_share_weixin variables:[self.appraisalDetailMode mj_keyValues]];

                     
                 }else if (platformType == UMSocialPlatformType_WechatTimeLine){
                                      [JHGrowingIO trackEventId:JHTrackvideo_detail2_share_pengyouquan variables:[self.appraisalDetailMode mj_keyValues]];
                 }

             }else if (type == ShareObjectTypeSaleLive || type == ShareObjectTypeAppraiseLive) {
                 
                 if (platformType == UMSocialPlatformType_WechatSession) {
                                     [JHGrowingIO trackEventId:JHTracklive_share_weixin variables:[JHRootController.serviceCenter.channelModel mj_keyValues]];

                                     
                                 }else if (platformType == UMSocialPlatformType_WechatTimeLine){
                                                      [JHGrowingIO trackEventId:JHTracklive_share_pengyouquan variables:[JHRootController.serviceCenter.channelModel mj_keyValues]];
                                 }

             }
            [weakSelf shareWebPageToPlatformType:platformType title:title text:text thumbUrl:imgUrl webURL:url type:type pageFrom:JHPageFromTypeUnKnown object:objectFlag];
        }
    }];
}


- (void)showCustomShareTitle:(NSString *)title
                        text:(NSString *)text
                    thumbUrl:(NSString *)thumbURL
                      webURL:(NSString *)url
                        type:(ShareObjectType)type
                      object:(id)objectFlag
                  isShowMore:(BOOL)showMore
                        isMe:(BOOL)isMe
{
    UMShareView *shareView = [[UMShareView alloc] initWithFrame:CGRectZero showMore:showMore isMe:isMe];
    @weakify(self);
    shareView.openShareBlock = ^(UMSocialPlatformType platformType) {
        @strongify(self);
         //url中文转码
         NSString *imgUrl = [thumbURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self shareWebPageToPlatformType:platformType title:title text:text thumbUrl:imgUrl webURL:url type:type pageFrom:JHPageFromTypeUnKnown object:objectFlag];
        
        NSInteger toType = 0;
        switch (platformType) {
            case (UMSocialPlatformType)1: {
                toType = 1;
                break;
            }
            case (UMSocialPlatformType)2: {
                toType = 2;
                break;
            }
            case (UMSocialPlatformType)4: {
                toType = 3;
                break;
            }
            case (UMSocialPlatformType)5: {
                toType = 4;
                break;
            }
            case (UMSocialPlatformType)6: {
                toType = 5;
                break;
            }
            default:
                break;
        }
        if (self.sharePlatformBlock) {
            self.sharePlatformBlock(toType);
        }
    };
    
    shareView.openMoreBlock = ^(UMShareMoreType moreType) {
        @strongify(self);
        switch (moreType) {
            case UMShareMoreType_Report: { //举报
                if (self.shareReportBlock) {
                    self.shareReportBlock();
                }
                break;
            }
            case UMShareMoreType_Delete: { //删除
            if (self.shareDeleteBlock) {
                self.shareDeleteBlock();
            }
                break;
            }
            default:
                break;
        }
    };
    [shareView show];
}

- (void)shareMiniProgramToPlatformType:(UMSocialPlatformType)platformType
                             articleId:(NSString *)Id
                              targetVC:(UIViewController *)tag
                                 title:(NSString *)title
                                  text:(NSString *)text
                              thumbUrl:(NSString *)thumbURL
                                webURL:(NSString *)url
                                  type:(NSInteger)type

{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:text thumImage:thumbURL];
    shareObject.webpageUrl = url;
    shareObject.userName = @"gh_cf0d3e2f406e";
    if (type == 0) {
        shareObject.path = [NSString stringWithFormat:@"/pages/article_detail/article_detail?id=%@",Id];

    }else {
        shareObject.path = [NSString stringWithFormat:@"/pages/article_detail/article_detail?id=v%@",Id];

    }
    
    if (!thumbURL) {
        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon_logo"]);
        thumbURL = [thumbURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData * data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString:thumbURL]];
        
        shareObject.hdImageData = data?:imageData;

    }
    
    shareObject.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:tag completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}






//授权并获取用户信息
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType currentViewController:(UIViewController*)currentViewController userInfoResult:(platformResult)userInfoResult {

    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:currentViewController completion:^(id result, NSError *error) {
            UMSocialUserInfoResponse *umResult = result;
            
            ShareUserInfoModel *userinfo = [[ShareUserInfoModel alloc] init];
            userinfo.uid = umResult.uid;
            userinfo.openid = umResult.openid?:umResult.accessToken;
            userinfo.name = umResult.name;
            userinfo.iconurl = umResult.iconurl;
            userinfo.gender = umResult.gender;
            userinfo.token = umResult.accessToken;
            
            if (userInfoResult) {
                userInfoResult(userinfo,error);
            }
        }];
    }];

}

- (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType
{
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        
    }];
    
}

- (BOOL) isInstall:(UMSocialPlatformType)platformType
{
//    if (platformType == UMSocialPlatformType_QQ) {
//        if ([QQApiInterface isQQInstalled]) {
//            return YES;
//        }
//
//    }

    return [[UMSocialManager defaultManager] isInstall:platformType];
}

- (void)processPushInfo:(NSDictionary *)userInfo isApplicationActive:(BOOL)isActive {
    self.userInfo = userInfo;
  
    if (userInfo[@"aps"][@"content-available"]) {
        [self getPushInfo:userInfo];
    } else {
        if (isActive) { //在前台显示Alert弹框
            id alert = userInfo[@"aps"][@"alert"];
            
            NSString *title = @"";
            NSString *message = @"";
            
            if ([alert isKindOfClass:[NSDictionary class]]) {
                title = alert[@"title"];
                message = alert[@"body"];
            } else {
                title = @"消息通知";
                message = alert;
            }
            
            if (title.length > 0 && message.length > 0) {
               
                
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil] show];

            }
        } else { //否则跳转到对应控制器
            [self getPushInfo:userInfo];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self getPushInfo:self.userInfo];
    }
}

- (void)getPushInfo:(NSDictionary *)info {
//    PushType type = [info[@"type"] integerValue];
//    NSString *ids = info[@"id"];
//    switch (type) {
//        case PushTypeNews:{
//
//            YGNewsDetailViewController *vc = [[YGNewsDetailViewController alloc] init];
//            vc.contentId = ids;
//            [self pushToVC:vc];
//
//        }
//            break;
//        case PushTypeVideo:{
//            YGVideoDetailViewController *vc = [[YGVideoDetailViewController alloc] init];
//            vc.contentId = ids;
//            vc.channelId = info[@"cid"];
//            [self pushToVC:vc];
//
//        }
//
//            break;
//        case PushTypeShop:{
//            YGShopDetailViewController *vc = [[YGShopDetailViewController alloc] init];
//            vc.shopId = ids;
//            [self pushToVC:vc];
//        }
//
//            break;
//
//        case PushTypeURL:{
//            YGWebViewController *vc = [[YGWebViewController alloc] initWithURLString:ids];
//            vc.titleString = @"推送消息";
//
//            BasicNavigationViewController *nav = [[BasicNavigationViewController alloc] initWithRootViewController:vc];
//
//            [self presentVC:nav];
//        }
//
//            break;
//
//
//        case PushTypeScore:{
//            if ([UtilsFactory token]) {
//                YGInOutRecordVC *vc = [[YGInOutRecordVC alloc] init];
//                vc.isPush = YES;
//                [self pushToVC:vc];
//
//            }
//
//        }
//
//            break;
//
//
//        default:
//            break;
//    }
    
}


/** push到某个页面 */
- (void)pushToVC:(UIViewController *)vc {
//    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
//
//    if ([rootVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabBarC = (UITabBarController *)rootVC;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [tabBarC.selectedViewController pushViewController:vc animated:YES];
//        });
//    } else if ([rootVC isKindOfClass:[KGAdLaunchVC class]]) {
//        KGAdLaunchVC *adVC = (KGAdLaunchVC *)rootVC;
//        BasicNavigationViewController *nav = [[BasicNavigationViewController alloc] initWithRootViewController:vc];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [adVC presentViewController:nav animated:YES completion:nil];
//        });
//    } else if ([NSStringFromClass([rootVC class]) isEqualToString:@"UIApplicationRotationFollowingController"]) {
//        UIWindow *realWindow = [[[UIApplication sharedApplication] windows] firstObject];
//        UITabBarController *tabBarC = (UITabBarController *)realWindow.rootViewController;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [tabBarC.selectedViewController pushViewController:vc animated:YES];
//        });
//    }
}


- (void)presentVC:(UIViewController *)vc {
//    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
//
//    if ([rootVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabBarC = (UITabBarController *)rootVC;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [tabBarC.selectedViewController presentViewController:vc animated:YES completion:nil];
//        });
//    } else if ([rootVC isKindOfClass:[KGAdLaunchVC class]]) {
//        KGAdLaunchVC *adVC = (KGAdLaunchVC *)rootVC;
//        BasicNavigationViewController *nav = [[BasicNavigationViewController alloc] initWithRootViewController:vc];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [adVC presentViewController:nav animated:YES completion:nil];
//        });
//    } else if ([NSStringFromClass([rootVC class]) isEqualToString:@"UIApplicationRotationFollowingController"]) {
//        UIWindow *realWindow = [[[UIApplication sharedApplication] windows] firstObject];
//        UITabBarController *tabBarC = (UITabBarController *)realWindow.rootViewController;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [tabBarC.selectedViewController presentViewController:vc animated:YES completion:nil];
//        });
//    }
}


- (void)openAppWithString:(NSString *)string {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    string = [string stringByReplacingOccurrencesOfString:YGOpenUrl withString:@""];
//    NSArray *array = [string componentsSeparatedByString:@"&"];
//    for (NSString *string in array) {
//        NSArray *arr = [string componentsSeparatedByString:@"="];
//        if (arr.count == 2) {
//            dic[arr[0]] = arr[1];
//        }
//    }
//    [self getPushInfo:dic];
    
}


- (void)requestShareDomain {

    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/shareDomain") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.shareDomian = respondObject.data;
        self.shareVideoUrl = [NSString stringWithFormat:@"%@%@",self.shareDomian,@"/jianhuo/shipin.html?id="];
        self.shareLiveUrl = [NSString stringWithFormat:@"%@%@",self.shareDomian,@"/jianhuo/video.html?"];
        self.shareReporterUrl = [NSString stringWithFormat:@"%@%@",self.shareDomian,@"/jianhuo/baogao.html?"];
        self.shareSaleReporterUrl = [NSString stringWithFormat:@"%@%@",self.shareDomian,@"/jianhuo/baogao2.html?"];
        
        self.shareStoneDetailUrl = [NSString stringWithFormat:@"%@%@",self.shareDomian,@"/jianhuo/app/passOnShare.html?"];

    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (NSString *)getUmengId {
    return [UMConfigure umidString];
}
- (NSString *)getUmengUtid {
    return [UTDevice utdid];
}
@end
