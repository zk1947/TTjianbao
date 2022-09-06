//
//  JHAppAlertViewManger.m
//  TTjianbao
//
//  Created by apple on 2020/5/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "NTESAudienceLiveViewController.h"
#import "NTESAnchorLiveViewController.h"
#import "JHNormalLiveController.h"
#import "JHAppAlertViewManger.h"
#import "NSTimer+Help.h"
#import "JHAppAlertViewHeader.h"
#import "JH99FreeViewController.h"
#import "JHOrderViewModel.h"
#import "JHCustomizeOrderDetailController.h"
#import "JHNewUserRedPacketAlertView.h"
#import "JHAuthorize.h"
@interface JHAppAlertViewManger ()

/// 是否正在显示中
@property (nonatomic, assign) BOOL appAlertshowing;
/// 禁止展示弹窗 默认为NO
@property (nonatomic, assign) BOOL forbidShowAlert;

/// 访客是不是在连麦中
@property (nonatomic, assign) BOOL isLinking;

/// 当前的直播间
@property (nonatomic, copy) NSString *channelLocalId;

/// 红包去重集合
@property (nonatomic, strong) NSMutableDictionary *receivedRedPacketDic;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray <JHAppAlertModel *> *dataArray;

///首页
@property (nonatomic, strong) NSMutableArray <NSString *> *homeAlertSortArray;

/// 直播间
@property (nonatomic, strong) NSMutableArray <NSString *> *liveAlertSortArray;

#pragma mark -------- 为了超级红包加了一些~~ --------

/// 超级红包入口
@property (nonatomic, strong) YYAnimatedImageView *superRedPacketButton;

/// 超级红包不显示（NO-显示  YES-不显示）
@property (nonatomic, assign) BOOL superRedPacketDisAppear;

/// 超级红包入口位置
@property (nonatomic, assign) CGRect superRedPacketRect;

/// 是否在两分钟外(超级红包2分钟内不要重复弹出来)
@property (nonatomic, assign) BOOL isInTimeInterval;

/// 区分首页位置
@property (nonatomic, assign) JHAppAlertLocalType homePage;

@end

@implementation JHAppAlertViewManger

- (void)dealloc {
    [_timer invalidate];
}

- (void)showRedPacketFromArray {
    for (JHAppAlertModel *m in self.dataArray) {
        if(m.type == JHAppAlertTypeBigRedPacket)
        {
            self.appAlertshowing = YES;
            //超级红包弹框
            [JHRedPacketGuideView showRedPacketGuideWithModel:m.body removeBlock:^{
                [JHAppAlertViewManger cancleShowRedPacketWithModelArray:@[m]];
            }];
            break;
        }
    }
}

///变为可以继续展示的状态
- (void)changeTimeIntervalStatus
{
    self.isInTimeInterval = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isInTimeInterval = NO;
    });
}

///计时器轮询方法
- (void)starSetData
{
    if(self.dataArray.count <= 0)
    {
        [self.timer jh_stop];
        self.superRedPacketButton.hidden = YES;
        return;
    }
    self.superRedPacketButton.hidden = YES;
    for (JHAppAlertModel *m in self.dataArray) {
        if(m.type == JHAppAlertTypeBigRedPacket)
        {
            self.superRedPacketButton.hidden = NO;
            break;
        }
    }
    
    if(!self.appAlertshowing&&!self.forbidShowAlert){
        ///没有在显示 弹框位置验证
        BOOL isHome = NO;
        BOOL isLiveRoom = NO;
        
        UIViewController *vc = [JHRouterManager jh_getViewController];
        if([vc isKindOfClass:[NSClassFromString(@"LoginViewController") class]] || [vc isKindOfClass:[NSClassFromString(@"JVTelecomViewController") class]])
        {///登录框 不显示弹层

            return;
        }
        
        if([vc isKindOfClass:[NTESAudienceLiveViewController class]] || [vc isKindOfClass:[NTESAnchorLiveViewController class]] || [vc isKindOfClass:[JHNormalLiveController class]])
        {
            isLiveRoom = YES;
        }
            
        UINavigationController *nav = vc.navigationController;
        if(IS_ARRAY(nav.viewControllers) && nav.viewControllers.count == 1) {
            isHome = YES;
        }
         
        if(self.dataArray.count >= 2) {
            
            if(!isLiveRoom && !isHome){
                for(int i = 0; i < self.dataArray.count; i++) {
                    JHAppAlertModel *mi = self.dataArray[i];
                    if(i != 0 && (mi.type == JHAppAlertTypeBigRedPacket)){
                        [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                        break;
                    }
                }
            }
            else if(isHome){
                for (NSString *obj in self.homeAlertSortArray) {
                    BOOL canBreak = NO;
                    for(int i = 0; i < self.dataArray.count; i++) {
                        JHAppAlertModel *m0 = self.dataArray[0];
                        JHAppAlertModel *mi = self.dataArray[i];
                        if(i != 0 && [obj isEqualToString:mi.typeName] && ![m0.typeName isEqualToString:mi.typeName]){
                            [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                            canBreak = YES;
                            break;
                        }
                    }
                    if(canBreak){
                        break;
                    }
                }
            }
            else if(isLiveRoom){
                for (NSString *obj in self.liveAlertSortArray) {
                    BOOL canBreak = NO;
                    for(int i = 0; i < self.dataArray.count; i++) {
                        JHAppAlertModel *m0 = self.dataArray[0];
                        JHAppAlertModel *mi = self.dataArray[i];
                        if(i != 0 && [obj isEqualToString:mi.typeName] && ![m0.typeName isEqualToString:mi.typeName]){
                            [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                            canBreak = YES;
                            break;
                        }
                    }
                    if(canBreak){
                        break;
                    }
                }
            }
            
        }
        
        /// 获取可以展示的数据
        for (JHAppAlertModel *model in self.dataArray) {
            switch (model.localType) {

                case JHAppAlertLocalTypeHome:
                {
                    // 首页
                    if(isHome){
                        [self showWithModel:model];
                        return;
                    }
                }
                    break;

                case JHAppAlertLocalTypeLiveRoom:
                {
                    // 直播间
                    if(isLiveRoom)
                    {
                        [self showWithModel:model];
                        return;
                    }
                }
                    break;
                    
                case JHAppAlertLocalTypeLiveRoomOut:
                {// 直播间外
                    if(!isLiveRoom)
                    {
                        [self showWithModel:model];
                        return;
                    }
                }
                    break;
                
                case JHAppAlertLocalTypeMallPage:
                {// 源头直购-直播购物
                    if(self.homePage == JHAppAlertLocalTypeMallPage)
                    {
                        [self showWithModel:model];
                        return;
                    }
                }
                    break;

                default:
                    break;
            }
        }
    }
}

///要显示的数据模型
- (void)showWithModel:(JHAppAlertModel *)sender
{   
    if((sender.type == JHAppAlertTypeBigRedPacket) && self.isInTimeInterval)
    {
        return;
    }

    if((sender.type == JHAppAlertTypeBigRedPacket) && self.superRedPacketDisAppear)
    {
        return;
    }
    self.appAlertshowing = YES;
    /// 弹框展示
    switch (sender.type) {
        case JHAppAlertTypeActivity:
        {
            //活动弹框
            JHAppAlertBodyActivityModel *model = [JHAppAlertBodyActivityModel mj_objectWithKeyValues:sender.param];
            [JHActivityAlertView showAPPAlertViewWithModel:model];
        }
            break;
            
        case JHAppAlertTypeBigRedPacket:
        {
            //超级红包弹框
            [JHRedPacketGuideView showRedPacketGuideWithModel:sender.body removeBlock:^{
                [JHAppAlertViewManger cancleShowRedPacketWithModelArray:@[sender]];
            }];;
            return;
        }
            break;
            
        case JHAppAlertTypeRedPacket:
        {
            [JHRedPacketAlertView showWithModel:sender.body];
        }
            break;
            
        case JHAppAlertTypeRiskWarning:
        {
            /// 原石风险
            JHShowRiskAlert *alert = [[JHShowRiskAlert alloc] initWithFrame:JHKeyWindow.bounds];
            [alert style2WithPrice:(NSString *)sender.body];
            [JHKeyWindow addSubview:alert];
        }
            break;
            
        case JHAppAlertTypeAppUpdate:
        {
            /// APP升级
            [JHUpdateAlertView showUpdateAlertWithModel:sender.body];
        }
            break;
            
        case JHAppAlertTypeAppRaise:
        {
            /// 去评价
            [JHAppraisalAlertView new];
        }
            break;
            
        case JHAppAlertTypeNewUserRedPacket:
        {
            ///新手红包
            [JHNewUserRedPacketAlertView showAlertViewWithModel:sender.body];
        }
            break;
        
        case JHAppAlertTypeGift:
        {
            /// 新手礼物
//            [JHMaskingManager showPopWindow:JHMaskPopWindowTypeGift];
        }
            break;
        
        case JHAppAlertTypeAppraiseProblem:
        {
            /// 鉴定问题
            
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"鉴定问题通知" andDesc:@"经鉴定师鉴定，您购买的宝贝存在一定瑕疵，请查看鉴定详情。" cancleBtnTitle:@"关闭" sureBtnTitle:@"查看详情"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        NSString *orderId =[NSString stringWithFormat:@"%@",sender.body];
            alert.handle = ^{
                
        [JHOrderViewModel requestOrderDetail:orderId isSeller:NO completion:^(RequestModel *respondObject, NSError *error) {
         if (!error) {
             
            OrderMode *mode = [OrderMode mj_objectWithKeyValues: respondObject.data];
            if (mode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder) {
                JHCustomizeOrderDetailController * detail = [JHCustomizeOrderDetailController new];
            detail.orderId = orderId;
            detail.isSeller = NO;
            [JHRootController.homeTabController.navigationController pushViewController:detail animated:YES];
            [JHAppAlertViewManger appAlertshowing:NO];
        }
            else{
            JHOrderDetailViewController * detail = [JHOrderDetailViewController new];
                detail.orderId = orderId;
                detail.isSeller = NO;
                [JHRootController.homeTabController.navigationController pushViewController:detail animated:YES];
                [JHAppAlertViewManger appAlertshowing:NO];
              }
            }
                    
            else{
                [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
            }
        }];
                
            };
            alert.cancleHandle = ^{
                [JHAppAlertViewManger appAlertshowing:NO];
            };
            [[NSUserDefaults standardUserDefaults] setObject:[CommHelp getCurrentDate] forKey:[AppraiseIssueLastDate stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]];
            
        }
            break;
            
        case JHAppAlertType99Free:
        {
            /// 新手礼物
            JH99FreeViewController *vc = [[JH99FreeViewController alloc] init];
            JHRootController.definesPresentationContext = YES;
            vc.freeModel = sender.body;
            vc.edgesForExtendedLayout = UIRectEdgeAll;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [JHRootController presentViewController:vc animated:NO completion:nil];
        }
            break;
        case JHAppAlertTypeNotification :
            
            [JHAuthorize showNotificationAlertView];
            break;
        default:
        {
            self.appAlertshowing = NO;
        }
            break;
    }
    
    [self.dataArray removeObject:sender];
}

///变为可以继续展示的状态
- (void)switchSuperRedPacketAppear:(BOOL)appear {
    self.superRedPacketDisAppear = !appear;
    [[NSUserDefaults standardUserDefaults] setBool:!appear forKey:@"superRedPacketDisAppear"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark --------------- get ---------------
- (YYAnimatedImageView *)superRedPacketButton {
    if(!_superRedPacketButton) {
        _superRedPacketButton = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@"super_redpacket.webp"]];
        _superRedPacketButton.contentMode = UIViewContentModeScaleAspectFit;
        @weakify(self);
        [_superRedPacketButton jh_addTapGesture:^{
            @strongify(self);
            self.superRedPacketButton.hidden = YES;
            [JHAppAlertViewManger switchSuperRedPacketAppear:YES];
            [self showRedPacketFromArray];
        }];
    }
    return _superRedPacketButton;
}
- (NSMutableArray<JHAppAlertModel *> *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray<NSString *> *)homeAlertSortArray
{
    if(!_homeAlertSortArray){
        _homeAlertSortArray = [NSMutableArray new];
        [_homeAlertSortArray addObject:AppAlertUpdateVersion];
        [_homeAlertSortArray addObject:AppAlertName99Free];
        [_homeAlertSortArray addObject:AppAlertNewSellerPacket];
        [_homeAlertSortArray addObject:AppAlertNewAppraisePacket];
        [_homeAlertSortArray addObject:AppAlertActivity];
        [_homeAlertSortArray addObject:AppAlertAppraiseProblem];
        [_homeAlertSortArray addObject:AppAlertSign];
        [_homeAlertSortArray addObject:AppAlertGuideMarket];
        [_homeAlertSortArray addObject:AppAlertSuperRedPacket];
    }
    return _homeAlertSortArray;
}

- (NSMutableArray<NSString *> *)liveAlertSortArray
{
    if(!_liveAlertSortArray){
        _liveAlertSortArray = [NSMutableArray new];
        [_liveAlertSortArray addObject:AppAlertRough];
        [_liveAlertSortArray addObject:AppAlertActivityRoom];
        [_liveAlertSortArray addObject:AppAlertRandomRedPacket];
        [_liveAlertSortArray addObject:AppAlertSuperRedPacket];
    }
    return _liveAlertSortArray;
}

- (NSMutableDictionary *)receivedRedPacketDic
{
    if(!_receivedRedPacketDic)
    {
        _receivedRedPacketDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _receivedRedPacketDic;
}

- (NSTimer *)timer
{
    if(!_timer)
    {
        @weakify(self);
        _timer = [NSTimer jh_scheduledTimerWithTimeInterval:0.4 repeats:YES block:^{
            @strongify(self);
            [self starSetData];
        }];
    }
    return _timer;
}

/// 去重添加红包模型，根据服务器消减带展示的红包
-(void)changeModelArray:(NSArray<JHAppAlertModel *> *)modelArray isAdd:(BOOL)isAdd
{
    @synchronized (self) {
        if(isAdd)
        {
            for(JHAppAlertModel *obj1 in modelArray)
            {
                JHRedPacketGuideModel *model1 = (JHRedPacketGuideModel *)obj1.body;
                BOOL add = YES;
                if((self.channelLocalId&&[self.channelLocalId isEqualToString:model1.channelLocalId]))
                {
                    /// 当前直播间不允许出现当前直播间的超级红包
                    [JHAppAlertViewManger addRedPacketWithId:model1.redPacketId];
                    add = NO;
                }
                
                for(NSString *key in self.receivedRedPacketDic)
                {
                    if([model1.redPacketId isEqualToString:key])
                    {
                        add = NO;
                        break;
                    }
                }
                if(add)
                {
                    [self.dataArray addObject:obj1];
                    if(self.dataArray.count == 1){
                    }
                }
            }
        }
        else
        {
            for(JHAppAlertModel *obj1 in modelArray)
            {
                JHRedPacketGuideModel *model1 = (JHRedPacketGuideModel *)obj1.body;
                for (JHAppAlertModel *obj2 in self.dataArray) {
                    JHRedPacketGuideModel *model2 = (JHRedPacketGuideModel *)obj2.body;
                    if([model2 isKindOfClass:[JHRedPacketGuideModel class]])
                    {
                        if([model1.redPacketId isEqualToString:model2.redPacketId])
                        {
                            [self.dataArray removeObject:obj2];
                            break;
                        }
                    }
                }
            }
        }
    }
}

#pragma mark -------- 暴露在外调用的类方法 --------
///变为可以继续展示的状态
+ (void)publishChangeTimeIntervalStatus
{
    [[JHAppAlertViewManger manger] changeTimeIntervalStatus];
}

/// 有数据，开始
+ (void)addModelArray:(NSArray<JHAppAlertModel *> *)array
{
    if(IS_ARRAY(array)){
        JHAppAlertModel *m = array[0];
        if(m.type == JHAppAlertTypeBigRedPacket){
            if(![JHRedPacketGuideView isAnchor] && ![JHAppAlertViewManger manger].isLinking){
                [[JHAppAlertViewManger manger] changeModelArray:array isAdd:YES];
            }
        }
        else{
            [[JHAppAlertViewManger manger].dataArray addObjectsFromArray:array];
        }
        
        ///第一次启动延时一次
        static BOOL delay = YES;
        if(delay)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                delay = NO;
                [[JHAppAlertViewManger manger].timer jh_star];
            });
        }
        else
        {
            [[JHAppAlertViewManger manger].timer jh_star];
        }
    } 
}

/// 当前是否正在展示
+ (void)appAlertshowing:(BOOL)appAlertshowing
{
    [JHAppAlertViewManger manger].appAlertshowing = appAlertshowing;
}
/// 是否禁止展示弹窗
+ (void)forbidShowAlert:(BOOL)forbidShowAlert{
    
    [JHAppAlertViewManger manger].forbidShowAlert = forbidShowAlert;
}

+(void)isLinking:(BOOL)isLinking
{
    [JHAppAlertViewManger manger].isLinking = isLinking;
}

+(void)channelLocalId:(NSString *)channelLocalId
{
    [JHAppAlertViewManger manger].channelLocalId = channelLocalId;
}

+ (void)addRedPacketWithId:(NSString *)redPacketId
{
    [[JHAppAlertViewManger manger].receivedRedPacketDic setValue:redPacketId forKey:redPacketId];
}

+ (void)cancleShowRedPacketWithModelArray:(NSArray<JHAppAlertModel *> *)modelArray
{
    [[JHAppAlertViewManger manger] changeModelArray:modelArray isAdd:NO];
}

#pragma mark -------- request --------
+ (void)getAlertSort {
    NSString *urlStr = FILE_BASE_STRING(@"/activity/api/dialogPriority/list");
    [HttpRequestTool getWithURL:urlStr Parameters:nil  successBlock:^(RequestModel *respondObject) {
        NSDictionary *data = respondObject.data;
        if (IS_DICTIONARY(data)) {
            NSArray *homeArray = [data valueForKey:@"list"];
            NSArray *liveArray = [data valueForKey:@"live"];
            if(IS_ARRAY(homeArray)){
                NSMutableArray *array = JHAppAlertViewManger.manger.homeAlertSortArray;
                [array removeAllObjects];
                [array addObjectsFromArray:homeArray];
                [array insertObject:AppAlertName99Free atIndex:0];
                [array insertObject:AppAlertUpdateVersion atIndex:0];
                [array addObject:AppAlertNameNotification];
            }
            if(IS_ARRAY(liveArray)){
                NSMutableArray *array = JHAppAlertViewManger.manger.liveAlertSortArray;
                [array removeAllObjects];
                [array addObjectsFromArray:liveArray];
                [array insertObject:AppAlertRough atIndex:0];
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {}];
}

+ (instancetype)manger {
    
    static dispatch_once_t onceToken;
    static JHAppAlertViewManger *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JHAppAlertViewManger new];
        [self getAlertSort];
        [instance resetRedPacketMethod];
        
    });
    return instance;
}
/// 在view上显示入口
+ (void)showSuperRedPacketEnterWithSuperView:(UIView *)sender {
    
    JHAppAlertViewManger *manger = [JHAppAlertViewManger manger];
    manger.superRedPacketButton.hidden = YES;
    for (JHAppAlertModel *m in manger.dataArray) {
        if(m.type == JHAppAlertTypeBigRedPacket)
        {
            manger.superRedPacketButton.hidden = NO;
            break;
        }
    }
    [sender addSubview:[JHAppAlertViewManger manger].superRedPacketButton];
}

/// 设置小框位置
+ (void)setShowSuperRedPacketEnterWithTop:(CGFloat)top {
    CGRect rect = CGRectMake(ScreenW - 67, top - UI.bottomSafeAreaHeight, 50, 50);
    [JHAppAlertViewManger manger].superRedPacketRect = rect;
    [JHAppAlertViewManger manger].superRedPacketButton.frame = rect;
}

/// 设置小框位置
+ (void)setShowSuperRedPacketEnterWithLeft:(CGFloat)left{
    CGRect rect = [JHAppAlertViewManger manger].superRedPacketRect;
    CGRect rect2 = CGRectMake(left, rect.origin.y, 50, 50);
    [JHAppAlertViewManger manger].superRedPacketRect = rect2;
    [JHAppAlertViewManger manger].superRedPacketButton.frame = rect2;
}

/// 获取当前小框位置
+ (CGRect)getShowSuperRedPacketEnterRect {
    CGRect rect = [JHAppAlertViewManger manger].superRedPacketRect;
    rect = CGRectMake(rect.origin.x + 7, rect.origin.y, rect.size.width - 14, rect.size.height);
    return rect;
}

///变为可以继续展示的状态
+ (void)switchSuperRedPacketAppear:(BOOL)appear {
    [[JHAppAlertViewManger manger] switchSuperRedPacketAppear:appear];
}

///重置红包逻辑
- (void)resetRedPacketMethod {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYYMMdd";
    NSString *dateString = [formatter stringFromDate:date];
    NSInteger num1 = dateString.integerValue;
    
    NSInteger num2 = [[NSUserDefaults standardUserDefaults]integerForKey:@"superRedPacketDisAppearDate"];
    BOOL appear = YES;
    if(num1 != num2)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:num1 forKey:@"superRedPacketDisAppearDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        appear = YES;
    }
    else
    {
        appear = ![[NSUserDefaults standardUserDefaults]boolForKey:@"superRedPacketDisAppear"];
    }
    [self switchSuperRedPacketAppear:appear];
}

/// APP当前位置
+ (void)appCurrentLocalHomePage:(JHAppAlertLocalType)homePage {
    [JHAppAlertViewManger manger].homePage = homePage;
}
@end
