//
//  JHSessionManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSessionManager.h"
#import "JHChatBusiness.h"
#import "UserInfoRequestManager.h"
#import "NTESLoginManager.h"

static NSString * const WaringKey = @"isWaringShow";

typedef void(^HasHandler)(BOOL has);

@interface JHSessionManager()<JHChatManagerDelegate>

@end
@implementation JHSessionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NTESLoginData *data = [[NTESLoginManager sharedManager] currentNTESLoginData];
        self.myAccount = [data account];
        [self setupManager];
    }
    return self;
}
#pragma mark - 会话开始
- (void)startSessionWithReceiveAccount : (NSString *)receiveAccount {
    if (receiveAccount.length <= 0) return;
    self.receiveAccount = receiveAccount;
    self.chatManager.receiveAccount = receiveAccount;
    
    BOOL isBusiness = [JHChatUserManager sharedManager].userIsBusiness;
    NSString *type = isBusiness ? @"0" : @"1";
    [JHChatBusiness startSessionWithAccount:self.myAccount receiveAccount:self.receiveAccount type:type];
    
    @weakify(self)
    [self.chatManager loadLocalMessage:^(NSInteger count) {
        @strongify(self)
        [self.reloadDataSubject sendNext:nil];
        
        [self showUnReadView];
        [self showEvaluationView];
    }];
    
    [self getSessionRequest];
    
    
    [self setupSession];
}

- (void)getSessionRequest {
    [JHChatUserManager getUserInfoWithID:self.myAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
        self.userInfo = userInfo;
    }];
    [JHChatUserManager getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
        self.receiveUserInfo = userInfo;
        [self checkAppVersion];
        [self getQuickInfoRequest];
    }];
}
- (void)setupSession {
    [self showWaringView];
    self.chatManager.account = self.myAccount;
    
    if (self.orderInfo) {
        [self.toastSubject sendNext:@"可以在这里发送订单哟"];
    }
    
    if (self.goodsInfo) {
        [self sendGoodsMessage];
    }
    [self setupSourceTypeSession];
    
    NSArray *types = @[@2,@4,@6,@7,@9]; // 商家类型
    if ([types containsObject: @(self.userInfo.customerType)]) {
        [self setupBusinessSession];
    }else {
        [self setupNormalSession];
    }
    
}
// 普通用户
- (void)setupNormalSession {
    [self setupMediaListIsShowCoupon : false];
}
// 商家
- (void)setupBusinessSession {
    [self getCouponInfoRequest];
    [self setupMediaListIsShowCoupon : true];
//    self.quickInfoList = @[[JHIMQuickModel getEvaluationQuickModel]];
}
// 设置来源-
- (void)setupSourceTypeSession {
    if (self.sourceType != JHIMSourceTypeShop &&
        self.sourceType != JHIMSourceTypeLive &&
        self.sourceType != JHIMSourceTypeOrderDetail &&
        self.sourceType != JHIMSourceTypeC2COrderDetail) return ;
    
    if ([self canInsertTipMessage]) {
        [self insertTipMessageWithText:@"您好，请问有什么可以帮您～"];
    }
}
- (void)showEvaluationView {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        NSMutableArray *evaluates = [self.chatManager.messageList jh_filter:^BOOL(JHMessage * _Nonnull obj, NSUInteger idx) {
            return obj.customTipInfo.type == JHChatCustomTipTypeEvaluate;
        }];
        
        if (evaluates.count > 0) {
            // 服务评价
            JHMessage *model = evaluates.lastObject;
            BOOL isShow = [model.message.localExt[IsShowEvaluate] boolValue];

            if (isShow == false) {
                [NSThread sleepForTimeInterval:1];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.eventSubject sendNext:model.customTipInfo];
                    model.message.localExt = @{IsShowEvaluate : @(true)};
                    [self.chatManager updateMessage:model];
                }];
            }
        }
    }];
    
}
#pragma mark - 发送消息
/// 发送商品消息
- (void)sendGoodsMessage {
    if (self.goodsInfo == nil) return;

    if ([self canInsertTipMessage]) {
        [self sendGoodsMessageAndTip];
        return;
    }
    
    [self hasGoodsMessageWithId : self.goodsInfo.productId handler:^(BOOL has) {
        if (has == false) {
            [self sendGoodsMessageAndTip];
        }
    }];
    
}
- (void)sendGoodsMessageAndTip {
    JHMessage *msg = [[JHMessage alloc] initWithGoods: self.goodsInfo];
    
    [self.chatManager sendCustomMessage:msg account:self.receiveAccount];
    
    [self.chatManager insertWelcomeMessage:@"这位宝友眼光不错哦，喜欢的话可以聊聊~"];
}
- (void)sendMessageWithGoods : (JHChatGoodsInfoModel *)goodsInfo {
    JHMessage *msg = [[JHMessage alloc] initWithGoods:goodsInfo];
    [self.chatManager sendCustomMessage:msg account:self.receiveAccount];
}
/// 发送订单消息
- (void)sendMessageWithOrder : (JHChatOrderInfoModel *)orderInfo {
    JHMessage *msg = [[JHMessage alloc] initWithOrder:orderInfo];
    [self.chatManager sendCustomMessage:msg account:self.receiveAccount];
}
/// 发送优惠券消息
- (void)sendCouponMessage : (NSArray<JHChatCouponInfoModel *> *)coupons {
    if (![self canSendMessage]) return;
    NSArray *list = [coupons valueForKeyPath:@"couponId"];
    
    [JHChatBusiness sendCouponWithUserId:self.receiveUserInfo.customerId couponIds: list successBlock:^(JHChatCouponSendModel * _Nonnull respondObject) {
        NSMutableArray *list = [NSMutableArray new];
        for (JHChatCouponInfoModel *coupon in coupons) {
            for (JHChatCouponSendInfo *model in respondObject.coupons) {
                if (coupon.couponId.integerValue == model.couponId) {
                    coupon.timeTypeAStartTime = model.startUseTime;
                    coupon.timeTypeAEndTime = model.endUseTime;
                    [list appendObject:coupon];
                    break;
                }
            }
        }
        if (list.count == 0) {
            [self.toastSubject sendNext:@"优惠券发送失败"];
        }else {
            if (list.count != coupons.count ) {
                [self.toastSubject sendNext:@"优惠券部分发送失败"];
            }
            [self sendCoupon:list];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.toastSubject sendNext:@"优惠券发送失败"];
    }];
}
- (void)sendCoupon : (NSArray<JHChatCouponInfoModel *> *)coupons {
    for (JHChatCouponInfoModel *coupon in coupons) {
        JHMessage *msg = [[JHMessage alloc] initWithCoupon:coupon];
        [self.chatManager sendCustomMessage:msg account:self.receiveAccount];
    }
}
/// 插入tip  消息
- (void)insertTipMessageWithText : (NSString *)text {
    if (text.length == 0) return;
    [self.chatManager insertTipMessageWithText:text];
}
/// 重发消息
- (void)resendMessage : (JHMessage *)message {
    if (message.sendState == JHMessageSendStateBlack){
        [self.toastSubject sendNext:@"对方拒收了您的消息"];
        return;
    }
    [self.chatManager resendMessage:message];
}
- (BOOL)canSendMessage {
    if (self.canSendNewCustomMessage == 1) {
        return true;
    }else if (self.canSendNewCustomMessage == 0) {
        [self.toastSubject sendNext:@"对方APP版本过低，需更新后才能体验此功能"];
    }
    return false;
}
- (void)canSendMessage : (CanSendMessageHandler)handler {
    if (self.canSendNewCustomMessage == 1) {
        handler(true);
    }else if (self.canSendNewCustomMessage == 0) {
        [self.toastSubject sendNext:@"对方APP版本过低，需更新后才能体验此功能"];
        handler(false);
    }else {
        [JHChatBusiness checkAppVersionWithUserId:self.receiveUserInfo.customerId successBlock:^(RequestModel * _Nullable respondObject) {
            NSInteger can = [respondObject.data integerValue];
            handler(can == 1);
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            handler(false);
        }];
    }
}
#pragma mark -  评价
- (void)canEvaluation : (void(^)(BOOL canEvaluation))handler{
    if (self.chatManager.messageList.count == 0) {
        if (handler) {
            handler(false);
        }
        [self.toastSubject sendNext:@"当前客服还没有为您服务，不能评价哦～"];
        return;
    }
    [JHChatBusiness evaluationCheckWithUserId:self.userInfo.customerId evaluatorId:self.receiveUserInfo.customerId satisfaction:@"0" successBlock:^(RequestModel * _Nullable respondObject) {
        if (handler) {
            handler(true);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (handler) {
            handler(false);
        }
        [self.toastSubject sendNext:respondObject.message];
    }];
}
- (void)evaluationWithModel : (JHChatEvaluationModel *)model {
    [JHChatBusiness evaluationWithUserId:self.userInfo.customerId evaluatorId:self.receiveUserInfo.customerId satisfaction:model.evaluationId successBlock:^(RequestModel * _Nullable respondObject) {
        [self sendEvaluationMessage : model];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.toastSubject sendNext:@"评价失败，请重试～"];
    }];
}
/// 发送评价成功消息
- (void)sendEvaluationMessage : (JHChatEvaluationModel *)model {
    NSString *text = [NSString stringWithFormat:@"满意度评价: %@", model.title];
    JHMessage *msg = [[JHMessage alloc] initCustomTipApnsMessage:@"评价成功，感谢参与" receiverTip : text type : JHChatCustomTipTypeNormal];
    [self.chatManager sendCustomMessage:msg account:self.receiveAccount];
}
/// 商家发送评价
- (void)businessSendEvaluation {
    // 无消息记录不允许商家主动发起评价
    if (self.chatManager.messageList.count == 0) return;
    
    [JHChatBusiness evaluationCheckWithUserId: self.receiveUserInfo.customerId evaluatorId: self.userInfo.customerId satisfaction:@"0" successBlock:^(RequestModel * _Nullable respondObject) {
        JHMessage *msg = [[JHMessage alloc] initCustomTipApnsMessage:@"" receiverTip : @"" type : JHChatCustomTipTypeEvaluate];
        [self.chatManager sendCustomMessage:msg account:self.receiveAccount];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.toastSubject sendNext:respondObject.message];
    }];
}
#pragma mark - 点击事件
/// 点击消息
- (void)didClickMessage : (JHMessage *)message {
    switch (message.messageType) {
        case JHMessageTypeOrder:
            [self pushOrderDetailWithMessage: message];
            break;
        case JHMessageTypeGoods:
            [self pushGoodsDetailWithMessage : message];
        default:
            break;
    }
}
/// 查看商品详情
- (void)pushGoodsDetailWithMessage : (JHMessage *)message {
    JHChatGoodsInfoModel *goodsInfo = message.goodsInfo;
    if (goodsInfo == nil) return;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    par[@"method"] = @"push";
    par[@"params"] = params;
    
    params[@"productId"] = goodsInfo.productId;
    
    if (goodsInfo.goodsPlatformType == 1) {
        par[@"vc"] = @"JHStoreDetailViewController";
    }else {
        par[@"vc"] = @"JHC2CProductDetailController";
    }
    
    [self.pushEventSubject sendNext:par];
}
/// 查看订单详情
- (void)pushOrderDetailWithMessage : (JHMessage *)message {
    JHChatOrderInfoModel *orderInfo = message.orderInfo;
    if (orderInfo == nil) return;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    par[@"method"] = @"push";
    par[@"params"] = params;
    
    NSString *category = orderInfo.orderLoadingCategory;
    
    if (orderInfo.marketOrderType == 1) {
        if (message.senderType == JHMessageSenderTypeMe) {
            params[@"isBuyer"] = @(true);
            params[@"isSeller"] = @(false);
        }else {
            params[@"isBuyer"] = @(false);
            params[@"isSeller"] = @(true);
        }
    }
    else if ([orderInfo.customerId isEqualToString: self.userInfo.customerId] ||
        ![orderInfo.sellerCustomerId isEqualToString:self.userInfo.customerId]) {
        params[@"isBuyer"] = @(true);
        params[@"isSeller"] = @(false);
    }else {
        params[@"isBuyer"] = @(false);
        params[@"isSeller"] = @(true);
    }
    
    // 集市订单 - C2C
    if ([category isEqualToString:@"market"] || category == nil) {
        par[@"vc"] = @"JHMarketOrderDetailViewController";
        params[@"orderId"] = orderInfo.orderId;
    }
    // 卖场订单- B2C
    else if ([category isEqualToString:@"normal"]) {
        par[@"vc"] = @"JHOrderDetailViewController";
        params[@"orderId"] = orderInfo.orderId;
    }
    // 定制订单
    else if ([category isEqualToString:@"customize"]) {
        par[@"vc"] = @"JHCustomizeOrderDetailController";
        params[@"orderId"] = orderInfo.orderId;
    }
    [self.pushEventSubject sendNext:par];
}
#pragma mark - 显示未读视图
- (void)showUnReadView {
    NSInteger count = self.chatManager.unreadCount;
    if (count <= 0) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        usleep(5000);
        [self.showUnReadSubject sendNext:@(count)];
    });
}
- (void)showWaringView {
//    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:WaringKey];
//    if (!isShow) {
        [self.showWarningView sendNext:nil];
//    }
}
- (void)setWaringHiden {
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:WaringKey];
}
- (NSArray *)getAllBrowserMessage {
    NSArray *arr = [self.chatManager.messageList jh_filter:^BOOL(JHMessage * _Nonnull obj, NSUInteger idx) {
        return obj.messageType == JHMessageTypeImage || obj.messageType == JHMessageTypeVideo;
    }];
    return arr;
}
- (void)hasGoodsMessageWithId : (NSString *)goodsId handler : (HasHandler)handler{
    [self getAllGoodsMessage:^(NSArray<JHMessage *> * _Nonnull list) {
        NSArray *arr = [list jh_filter:^BOOL(JHMessage * _Nonnull obj, NSUInteger idx) {
            return [obj.goodsInfo.productId isEqualToString:goodsId];
        }];
        handler(arr.count > 0);
    }];
}
- (void)getAllGoodsMessage : (JHMesssageHandler) handler{
    NSTimeInterval end = [self getNowDateInterval];
    NSTimeInterval start = end - 5 *60 * 1000;
    [self.chatManager searchMessageWithStartTime:start endTime:end messageType:JHMessageTypeGoods handler:^(NSArray<JHMessage *> * _Nonnull list) {
        if (handler) {
            handler(list);
        }
    }];
}
- (NSArray<JHChatMenuItemModel *> *)getItemModelsWithMessage : (JHMessage *)message {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    JHChatMenuItemModel *model = [[JHChatMenuItemModel alloc] initWithType:JHChatMenuItemTypeDelete title:@"删除" iconName:@"IM_menu_delete_icon"];
    
    [arr appendObject:model];
    if (message.messageType == JHMessageTypeText) {
        JHChatMenuItemModel *model = [[JHChatMenuItemModel alloc] initWithType:JHChatMenuItemTypeCopy title:@"复制" iconName:@"IM_menu_copy_icon"];
        [arr insertObject:model atIndex:0];
    }
    if (message.senderType == JHMessageSenderTypeMe) {
        NSDate *datenow = [NSDate date];//现在时间
        
        NSTimeInterval timeSp = [datenow timeIntervalSince1970];
        
        if (timeSp - message.message.timestamp <= RevokeTime) {
            JHChatMenuItemModel *model = [[JHChatMenuItemModel alloc] initWithType:JHChatMenuItemTypeRevoke title:@"撤回" iconName:@"IM_menu_revoke_icon"];
            [arr appendObject:model];
        }
    }
    return arr;
}
// 是否可以插入提示文本
- (BOOL)canInsertTipMessage {
    if (self.chatManager.messageList.count == 0) return true;
    JHMessage *message = self.chatManager.messageList.lastObject;
    
    NSTimeInterval time = message.message.timestamp;
    
    NSTimeInterval nowTime = [self getNowDateInterval];
    NSTimeInterval inter = nowTime - time;
    return inter > TimeInterval;
}
#pragma mark - ChatManager delegate
- (void)insertManagerWithIndex : (NSInteger) index {
    if (self.delegate == nil) return;
    [self.delegate insertManagerWithIndex:index];
}
- (void)chatManagerReloadAllDatas {
    if (self.delegate == nil) return;
    [self.delegate reloadAllDatas];
}

- (void)chatManagerReloadDatasWithScrollIndex : (NSInteger)index {
    if (self.delegate == nil) return;
    [self.delegate reloadMoreDatasWithScrollIndex : index];
}
- (void)audioDidStartPlay {
    if (self.delegate == nil) return;
    [self.delegate audioDidStartPlay];
}
- (void)audioDidPlayCompleted {
    if (self.delegate == nil) return;
    [self.delegate audioDidPlayCompleted];
}
- (void)reloadMessageWithIndex : (NSUInteger)index {
    if (self.delegate == nil) return;
    [self.delegate reloadCell:index];
}
- (void)setupMediaListIsShowCoupon : (BOOL)isShowCoupon {
    BOOL isBlack = [self.chatManager.userManager isUserInBlack:self.receiveAccount];
    self.mediaList = [JHChatMediaModel getDefaultMediaList:isBlack isShowCoupon : isShowCoupon];
}
// 获取当前时间戳
- (NSTimeInterval)getNowDateInterval {
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval timeSp = [datenow timeIntervalSince1970];
    return timeSp;
}
#pragma mark - Private
- (void)setupManager {
    self.canSendNewCustomMessage = -1;
    [[JHIMLoginManager sharedManager] imLogin];
    [self bindData];
}
- (void)bindData {
    @weakify(self)
    [self.chatManager.eventSubject subscribeNext:^(JHChatCustomTipInfo * _Nullable x) {
        @strongify(self)
        [self.eventSubject sendNext:x];
    }];
}
#pragma mark - 网络请求
- (void)getQuickInfoRequest {
    NSString *userId = self.receiveUserInfo.customerId;
    [JHChatBusiness getQuickInfoWithUserId:userId successBlock:^(NSArray<JHIMQuickModel *> * _Nonnull respondObject) {
        self.quickInfoList = respondObject;
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
- (void)getCouponInfoRequest {
    [JHChatBusiness getCouponInfoSuccessBlock:^(NSArray<JHChatCouponInfoModel *> * _Nonnull respondObject) {
        self.couponDataSource = respondObject;
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
- (void)checkAppVersion {
    [JHChatBusiness checkAppVersionWithUserId:self.receiveUserInfo.customerId successBlock:^(RequestModel * _Nullable respondObject) {
        NSInteger can = [respondObject.data integerValue];
        self.canSendNewCustomMessage = can;
      
    } failureBlock:^(RequestModel * _Nullable respondObject) {
       
    }];
}
#pragma mark - LAZY
- (void)setMyAccount:(NSString *)myAccount {
    _myAccount = myAccount;
    self.chatManager.account = myAccount;
}
- (JHChatManager *)chatManager {
    if (!_chatManager) {
        _chatManager = [[JHChatManager alloc] init];
        _chatManager.delegate = self;
    }
    return _chatManager;
}
- (RACReplaySubject *)showWarningView {
    if (!_showWarningView) {
        _showWarningView = [RACReplaySubject subject];
    }
    return _showWarningView;
}
- (RACSubject *)reloadDataSubject {
    if (!_reloadDataSubject) {
        _reloadDataSubject = [RACSubject subject];
    }
    return _reloadDataSubject;
}
- (RACSubject *)showUnReadSubject {
    if (!_showUnReadSubject) {
        _showUnReadSubject = [RACSubject subject];
    }
    return _showUnReadSubject;
}
- (RACSubject<NSString *> *)toastSubject {
    if (!_toastSubject) {
        _toastSubject = [RACSubject subject];
    }
    return _toastSubject;
}
- (RACSubject<JHChatCustomTipInfo *> *)eventSubject {
    if (!_eventSubject) {
        _eventSubject = [RACSubject subject];
    }
    return _eventSubject;
}
- (RACSubject<NSDictionary *> *)pushEventSubject {
    if (!_pushEventSubject) {
        _pushEventSubject = [RACSubject subject];
    }
    return _pushEventSubject;
}
@end
