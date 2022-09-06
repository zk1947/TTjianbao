//
//  JHBaseOperationAction.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHConfigAlertView.h"
#import "JHBaseOperationAction.h"
#import "YDBaseModel.h"
#import "JHSQApiManager.h"
#import "JHOperationBanView.h"
#import "WXApi.h"
#import "JHWebViewController.h"
#import "UIImage+JHCompressImage.h"
#import "JHWebImage.h"
#import "JHRichTextEditViewController.h"
#import "JHSQPublishViewController.h"
#import "JHShareMakeImageView.h"
#import "JHFansClubBusiness.h"

@implementation JHBaseOperationAction
+(void)operationAction:(JHOperationType)operationType operationMode:(JHPostData*)mode bolck:(JHFinishBlock)result{
    
    if (operationType!=JHOperationTypeWechatSession&&
        operationType!=JHOperationTypeWechatTimeLine&&
        operationType!=JHOperationTypeCopyUrl&&
        operationType!=JHOperationTypeBack && operationType != JHOperationTypeMakeLongImage) {
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
            return;
        }
        
    }
    
    switch (operationType) {
        case JHOperationTypeWechatSession:
        case JHOperationTypeWechatTimeLine:///微信朋友圈
        {
            [JHBaseOperationAction toShare:operationType operationShareInfo:mode.share_info object_flag:mode.item_id];
        }
            break;
        case JHOperationTypeBack:/// 返回社区首页
        {
            [JHRootController.currentViewController.navigationController popToRootViewControllerAnimated:YES];
//            [JHRootController popToSQHomePageController];
//            [[JHRootController currentViewController].navigationController popToRootViewControllerAnimated:YES];
//            [JHRootController setTabBarSelectedIndex:0];
//            [JHNotificationCenter postNotificationName:kSQNeedSwitchToRcmdTabNotication object:nil];
        }
                break;
        case JHOperationTypeCopyUrl:/// 复制链接
        {
            [JHBaseOperationAction toCopyUrl:mode];
        }
            break;
        case JHOperationTypeReport: /// 举报
        {
            [JHBaseOperationAction toReport:mode bolck:result];
        }
            break;
        case JHOperationTypeColloct: /// 收藏
        {
            [JHBaseOperationAction toCollect:mode bolck:result];
        }
            break;
        case JHOperationTypeCancleColloct: /// 取消收藏
        {
            [JHBaseOperationAction toCollect:mode bolck:result];
        }
            break;
        case JHOperationTypeSetGood: //设为精华
        {
            [JHBaseOperationAction toGood:mode bolck:result];
        }
            break;
        case JHOperationTypeCancleSetGood: //取消精华
        {
            [JHBaseOperationAction toGood:mode bolck:result];
        }
            break;
            
        case JHOperationTypeSetTop: //置顶
        {
            //公告状态
            if (mode.content_style==3) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"请先取消公告，再设置置顶。" duration:1.0 position:CSToastPositionCenter];
                return;
            }
            [JHBaseOperationAction toTop:mode bolck:result];
        }
               break;
        case JHOperationTypeCancleSetTop: //取消置顶
        {
            [JHBaseOperationAction toTop:mode bolck:result];
        }
            
               break;
        case JHOperationTypeNoice://公告
        {
            if (mode.content_style==2) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"请先取消置顶，再设置公告。" duration:1.0 position:CSToastPositionCenter];
                return;
            }
            [JHBaseOperationAction toNotice:mode bolck:result];
        }
            break;
        case JHOperationTypeCancleNotice://取消公告
        {
            [JHBaseOperationAction toNotice:mode bolck:result];
        }
            break;
            
        case JHOperationTypeWaring://警告
        {
            [self jh_showAlertSheetReasonWithType:operationType model:mode bolck:result];
        }
            break;
            
        case JHOperationTypeMute://禁言
        {
            [self jh_showAlertSheetReasonWithType:operationType model:mode bolck:result];
        }
            break;
        case JHOperationTypeDelete ://删除
        {
            
            [self jh_showAlertSheetReasonWithType:operationType model:mode bolck:result];
        }
            break;
            
        case JHOperationTypeEdit :
        {
            //编辑
            if(mode && (mode.item_type == 20 || mode.item_type == 30 || mode.item_type == 40)) {
                if(mode.is_edit_check) {
                    JHTOAST(@"此内容正在审核修改，审核通过后才能继续编辑");
                    return;
                }
                else if(mode.is_back) {
                    JHTOAST(@"您没有此内容的修改权限");
                    return;
                }
                if(mode.item_type == 30) {
                    JHRichTextEditViewController *vc = [JHRichTextEditViewController new];
                    vc.itemId = mode.item_id;
                    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
                }
                else {
                    JHSQPublishViewController *vc = [JHSQPublishViewController new];
                    vc.itemType = OBJ_TO_STRING(@(mode.item_type));
                    vc.type = (mode.item_type == 40 ? 2 : 1);
                    vc.itemId = mode.item_id;
                    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
            
        case JHOperationTypeSealAccount ://封号
        {
            JHOperationBanView * view = [[JHOperationBanView alloc]init];
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            [view show];
            view.completeBlock = ^(id obj) {
                NSString * string = (NSString*)obj;
                [JHBaseOperationAction toBan:mode reasonId:string bolck:result];
            };
        }
            break;
  
        case JHOperationTypeMakeLongImage ://长图
        {
            [JHShareMakeImageView showWithModel:mode];
        }
            break;

        default:
            break;
    }
}

/// 删除、警告、禁言 操作弹框
+ (void)jh_showAlertSheetReasonWithType:(JHOperationType)type model:(JHPostData *)model bolck:(JHFinishBlock)result {
    
    if(model.is_self) {
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"是否删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self toDelete:model reasonId:(NSString *)@0 bolck:result];
        }];
        [alertV addAction:action];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertV addAction:cancelAction];
        [JHRootController presentViewController:alertV animated:YES completion:nil];
    }
    else {
        [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/bans/tags") Parameters:nil successBlock:^(RequestModel *respondObject) {
            NSLog(@"1");
            
            NSString *typeName = @"";
            switch (type) {
                case JHOperationTypeDelete:
                    typeName = @"删除";
                    break;
                    
                case JHOperationTypeWaring:
                    typeName = @"警告";
                    break;
                    
                case JHOperationTypeMute:
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
                        
                        if (type == JHOperationTypeMute) {
                            [self jh_showAlertSheetBannedWithReason:value reasonId:(NSString *)reasonId model:model];
                        }
                        else
                        {
                            [JHConfigAlertView jh_showConfigAlertViewWithBanned:NO typeName:typeName reason:value timeType:0 complete:^{
                                if(type == JHOperationTypeWaring) {
                                    [self toWaring:model reasonId:(NSString *)reasonId];
                                } else if(type == JHOperationTypeDelete) {
                                    [self toDelete:model reasonId:(NSString *)reasonId bolck:result];
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
}

/// 禁言选取时间弹框
+ (void)jh_showAlertSheetBannedWithReason:(NSString *)reason reasonId:(NSString *)reasonId model:(JHPostData *)model {
    
    NSArray *array1 = @[@"1天", @"3天", @"7天", @"永久"];
    NSArray *array2 = @[@1, @3, @7, @0];
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (int i = 0; i < array2.count; i++) {
        
        NSString *name = array1[i];
        NSInteger num = [array2[i] integerValue];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [JHConfigAlertView jh_showConfigAlertViewWithBanned:YES typeName:@"禁言" reason:reason timeType:num complete:^{
                [JHBaseOperationAction toMute:model reasonId:reasonId timeType:num];
            }];
        }];
        [alertV addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertV addAction:cancelAction];
    [JHRootController presentViewController:alertV animated:YES completion:nil];
}
#pragma mark - 分享
+ (void)toShareText :(JHOperationType)type shareInfo: (JHShareInfo*)shareInfo {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = true;
    req.text = shareInfo.title;
    if (type == JHOperationTypeWechatSession)
        req.scene = WXSceneSession;
    else
        req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"toShareImage complete!");
    }];
}
+ (void)toShareImage:(JHOperationType)type shareInfo:(JHShareInfo*)shareInfo
{
    //调用分享接口
    WXImageObject *imageObject = [WXImageObject object];
    if (!shareInfo.img)
    {//大小不能超过25M
        UIImage *image = [UIImage imageNamed:@"icon_logo"];
        imageObject.imageData = UIImageJPEGRepresentation(image, 0.7);
    }
    else
    {
        imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareInfo.img]];
    }

    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if (type == JHOperationTypeWechatSession)
        req.scene = WXSceneSession;
    else
        req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"toShareImage complete!");
    }];
}

+ (void)toShare:(JHOperationType)type operationShareInfo:(JHShareInfo*)shareInfo object_flag:(id)object_flag
{
    NSString *imgStr = shareInfo.img;
    if([imgStr length] > 0)
    {
        //大小不能超过64K,否则会分享失败
        JH_WEAK(self)
        [JHWebImage downloadImageWithURL:[NSURL URLWithString:imgStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            UIImage *shareImage = [image compressedImageFiles:image imageMaxSizeKB:64/2.0];
            [self toShareInfo:shareInfo shareImg:shareImage operationType:type object_flag:object_flag];
        } ];
    }
    else
    {
        [self toShareInfo:shareInfo shareImg:[UIImage imageNamed:@"LOGO"] operationType:type object_flag:object_flag];
    }
}

+ (void)toShareInfo:(JHShareInfo*)shareInfo shareImg:(UIImage*)shareImg operationType:(JHOperationType)type object_flag:(id)object_flag
{
    NSString *title = shareInfo.title;
    NSString *descStr = shareInfo.desc;
    NSString *url = shareInfo.url;
    NSInteger pageFrom = shareInfo.pageFrom;
    __weak id extenseData = shareInfo.extenseData;
    id objectFlag = object_flag;
    
    ShareObjectType objectType = ShareObjectTypeSocialArticial;
    if (shareInfo.pageFrom == JHPageFromTypeSQTopicHomeList) {
        ///话题主页分享话题
        objectType = ShareObjectTypeTopicHomeList;
    }
    else if (shareInfo.pageFrom == JHPageFromTypeSQPlateHomeList) {
        ///板块主页分享板块
        objectType = ShareObjectTypePlateHomeList;
    }
    //修正下objectType，有效分享类型ShareObjectType
    if(shareInfo.shareType > -1)
    {
        objectType = shareInfo.shareType;
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
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = descStr;
    message.thumbImage = shareImg;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    UMSocialPlatformType platformType = UMSocialPlatformType_UnKnown;
    if (type == JHOperationTypeWechatSession) {
        platformType = UMSocialPlatformType_WechatSession;
        req.scene = WXSceneSession;
    }
    else {
        platformType = UMSocialPlatformType_WechatTimeLine;
        req.scene = WXSceneTimeline;
    }
    
    JH_WEAK(self)
    [WXApi sendReq:req completion:^(BOOL success) {
        JH_STRONG(self)
        if (objectType == ShareObjectTypeSocialArticial || objectType == ShareObjectTypeSocialFriend) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddShareCountNoticeName object:nil];
        }

        VideoExtendModel *model = [JHGrowingIO videoExtendModel:extenseData];//self.appraisalDetailMode];
        if (!success)
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"分享失败" duration:2.0 position:CSToastPositionCenter];
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            if (objectType == ShareObjectTypeAppraiseVideo) {
                [JHGrowingIO trackEventId:JHTrackvideo_detail2_share_fail variables:[model mj_keyValues]];

            }else if (objectType == ShareObjectTypeSaleLive || objectType == ShareObjectTypeAppraiseLive) {
                [JHGrowingIO trackEventId:JHTracklive_share_fail variables:[JHRootController.serviceCenter.channelModel mj_keyValues]];

            }else if (objectType == ShareObjectTypeAgentPay) {
                [JHGrowingIO trackOrderEventId:JHTrackreplacePay_payResult orderCode:objectFlag payWay:@"replacePay" suc:@"false"];
            }
        }
        else
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"分享成功" duration:2.0 position:CSToastPositionCenter];
            if (objectType == ShareObjectTypeAppraiseVideo) {
                [JHGrowingIO trackEventId:JHTrackvideo_detail2_share_suc variables:[model mj_keyValues]];

            }else if (objectType == ShareObjectTypeSaleLive || objectType == ShareObjectTypeAppraiseLive || objectType == ShareObjectTypeCustomizeLive) {
                [JHGrowingIO trackEventId:JHTracklive_share_suc variables:[JHRootController.serviceCenter.channelModel mj_keyValues]];
                //卖场直播间分享任务
                [JHFansClubBusiness FansTaskReport:JHFansTaskShare anchorId:JHRootController.serviceCenter.channelModel.anchorId channelId:JHRootController.serviceCenter.channelModel.channelLocalId customerId:[UserInfoRequestManager sharedInstance].user.customerId];

            }else if (objectType == ShareObjectTypeAgentPay) {
                [JHGrowingIO trackOrderEventId:JHTrackreplacePay_payResult orderCode:objectFlag payWay:@"replacePay" suc:@"true"];
            }
            
            //分享成功通知
            [JHNotificationCenter postNotificationName:kShareSuccessNotification object:nil];

//            if ([data isKindOfClass:[UMSocialShareResponse class]])
            {
//                UMSocialShareResponse *resp = data;
                //分享结果消息
//                UMSocialLogInfo(@"response message is %@", resp.message);
                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                if ([objectFlag isKindOfClass:[NSString class]]) {
                    [self buryWithType:objectType plat:platformType pageFrom:pageFrom object:objectFlag];

                } else if ([objectFlag isKindOfClass:[NSDictionary class]]) {
                    
                    if (objectType == ShareObjectTypeWebShare) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameShareFinish" object:objectFlag];
                        [self buryWithType:objectType plat:platformType pageFrom:pageFrom object:@""];
                        return ;
                    }
                    NSString *currentId = objectFlag[@"currentRecordId"];
                    
                    if (currentId) {
                        [self buryWithType:objectType plat:platformType pageFrom:pageFrom object:currentId];
                    }
                    NSString *roomId = [objectFlag valueForKey:@"roomId"];
                    if (roomId) {
                        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/share") Parameters:@{@"roomId":roomId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
                            if(objectType == ShareObjectTypeSaleLive || objectType == ShareObjectTypeCustomizeLive)
                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRedPacketShareSuccess object:nil];
                            }
                        } failureBlock:^(RequestModel *respondObject) {
                            [[UIApplication sharedApplication].keyWindow makeToast:@"失败，请重试" duration:2.0 position:CSToastPositionCenter];
                        }];
                    }
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameCommentRedPocket" object:nil];
                
            }
//            else
//            {
//                NSLog(@"WXApi share fail!");//(@"response data is %@",data);
//            }
        }
    }];
}

+ (void)buryWithType:(ShareObjectType)type plat:(NSInteger)platformType
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

#pragma mark - 复制链接
+ (void)toCopyUrl:(JHPostData*)mode{
    [UITipView showTipStr:@"链接复制成功，快去分享给好友吧"];
    [[UIPasteboard generalPasteboard] setString:mode.share_info.url];
}

#pragma mark - 收藏
+ (void)toCollect:(JHPostData*)mode bolck:(JHFinishBlock)result{
   
    [JHSQApiManager collectRequest:mode block:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            result();
        }
    }];
}
#pragma mark - 设为精华
+ (void)toGood:(JHPostData*)mode bolck:(JHFinishBlock)result{
    [JHSQApiManager contentlevelRequest:mode block:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            result();
        }
    }];
}
#pragma mark - 置顶
+ (void)toTop:(JHPostData*)mode bolck:(JHFinishBlock)result{
    [JHSQApiManager topRequest:mode block:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            result();
        }
    }];
}

#pragma mark - 公告
+ (void)toNotice:(JHPostData*)mode bolck:(JHFinishBlock)result{
    [JHSQApiManager noticeRequest:mode block:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            result();
        }
    }];
}

#pragma mark - 警告
+ (void)toWaring:(JHPostData*)mode reasonId:(NSString *)reasonId{
    [JHSQApiManager waringRequest:mode reasonId:reasonId];
}
#pragma mark - 删除
+ (void)toDelete:(JHPostData*)mode reasonId:(NSString *)reasonId  bolck:(JHFinishBlock)result{
    if(mode.is_self)
    {
        [JHSQApiManager deleteRequestAsAuthor:mode reasonId:reasonId block:^(id  _Nullable respObj, BOOL hasError) {
            if(result) {
                result();
            }
        }];
    }
    else
    {
        [JHSQApiManager deleteRequestAsPlator:mode reasonId:reasonId block:^(id  _Nullable respObj, BOOL hasError) {
            if(result) {
                result();
            }
        }];
    }
    
}
#pragma mark - 禁言
+ (void)toMute:(JHPostData*)mode reasonId:(NSString *)reasonId timeType:(NSInteger)timeType {
    [JHSQApiManager muteRequest:mode reasonId:reasonId timeType:timeType block:nil];
}

#pragma mark - 封号
+ (void)toBan:(JHPostData*)mode reasonId:(NSString*)reasonId bolck:(JHFinishBlock)result{
    [JHSQApiManager banRequest:mode reasonId:reasonId block:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            result();
        }
    }];
}
#pragma mark - 举报
+ (void)toReport:(JHPostData*)mode bolck:(JHFinishBlock)result{
   
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.titleString = @"举报";
    NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/report.html?");
    url = [url stringByAppendingFormat:@"rep_source=%ld&rep_obj_id=%@&live_user_id=",
           (long)mode.item_type, mode.item_id];
    webVC.urlString = url;
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
    
}
@end

