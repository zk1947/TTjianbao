//
//  JHMaskingManager.m
//  TTjianbao
//
//  Created by LiHui on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHAppAlertViewManger.h"
#import "JHMaskingManager.h"
#import "TTjianbaoMarcoKeyword.h"
#import "CommonTool.h"
#import "GrowingManager.h"
#import "JHMaskPopWindow.h"
#import "UserInfoRequestManager.h"
#import "CommHelp.h"
#import "NSString+YYAdd.h"
#import "JHStoreNewRedpacketModel.h"
#import "JHStoreApiManager.h"

#define redbagPopImageSize CGSizeMake(300, 359)
#define redbagButtonSize CGSizeMake(140, 46)

#define giftPopImageSize CGSizeMake(249, 190)
#define giftButtonSize  CGSizeMake(198, 40)

static JHMaskingManager *shareManager = nil;

@interface JHMaskingManager()
@property(nonatomic,strong)JHStoreNewRedpacketModel *redpacketModel;
@end
@implementation JHMaskingManager

+(instancetype)shareApiManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kAllLoginSuccessNotification object:nil];
    });
    return shareManager;
}

///获取用户是否领取过红包
- (void)getUserRedbagInfo:(void(^)(BOOL isNeedGrant,NSString *message))block {
    NSString *url = FILE_BASE_STRING(@"/coupon/haveReceivedCouponForLogin/auth?type=redbag");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        BOOL isNeed = NO;
        if ([respondObject.data intValue] == 1 && [JHRootController isLogin]) {
            ///已经领取过
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kWetherGrantRedbagKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            isNeed = NO;
        }
        else if ([respondObject.data intValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginedFirstRedbagKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            isNeed = YES;
        }
        if (block) {
            block(isNeed, respondObject.message);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"请求失败");
        if (block) {
            block(NO,respondObject.message);
        }
    }];
}

- (void)getUserGiftInfo:(void(^)(BOOL isNeedGrant,NSString *message))block {
    NSString *url = FILE_BASE_STRING(@"/coupon/haveReceivedCouponForLogin/auth?type=gift");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        BOOL isNeed = NO;
        if ([respondObject.data intValue] == 1 && [JHRootController isLogin]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kWetherGrantGiftKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            isNeed = NO;
        }
        else if ([respondObject.data intValue] == 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginedFirstGiftKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            isNeed = YES;
        }
        if (block) {
            block(isNeed, respondObject.message);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"请求失败");
        if (block) {
            block(NO,respondObject.message);
        }
    }];
}

- (void)commitData:(NSString *)type completeBlock:(void(^)(BOOL hasError,NSString *message))completeBlock {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/coupon/receiveCouponForLogin/auth?type=%@"), type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (completeBlock) {
            completeBlock(NO, respondObject.message);
        }
        [[JHMaskingManager shareApiManager] dealData:type];
    } failureBlock:^(RequestModel *respondObject) {
        if (respondObject.code == 1001) { ///不能继续领取
            [[JHMaskingManager shareApiManager] dealData:type];
        }
        if (completeBlock) {
            completeBlock(YES,respondObject.message);
        }
    }];
}


///领取红包/礼物
+ (void)pullDownWithType:(NSString *)type completeBlock:(HTTPCompleteBlock)block {
    @weakify(self);
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/coupon/receiveCouponForLogin/auth?type=%@"), type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [UITipView showTipStr:respondObject.message?:@"领取成功~"];
        [[self shareApiManager] dealData:type];
        block(respondObject, NO);
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [UITipView showTipStr:respondObject.message?:@"领取失败~"];
        if (respondObject.code == 1001) { ///不能继续领取
            [[self shareApiManager] dealData:type];
        }
        block(nil, YES);
    }];
}

///处理是否已经领取红包的数据
- (void)dealData:(NSString *)type {
    NSString *key = nil;
    if ([type isEqualToString:@"gift"]) {
        key = kWetherGrantGiftKey;
    }
    else if ([type isEqualToString:@"redbag"]) {
        key = kWetherGrantRedbagKey;
    }
    if (key) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)addGrowingPoint:(JHMaskPopWindowType)type {
    NSDictionary *params = [[self shareApiManager] growingParams];
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
        {
            [GrowingManager showRedbagPage:params];
        }
            break;
        case JHMaskPopWindowTypeGift:
        {
            [GrowingManager showGiftPage:params];
        }
            break;
        default:
            break;
    }
}

///显示红包弹窗
+ (void)showPopWindow:(JHMaskPopWindowType)type {
    ///显示弹窗埋点
    [self addGrowingPoint:type];
        
    NSString *popImage = [self popImage:type];
//    NSString *buttonImage = [self popButtonImage:type];
    CGSize popImageSize = [self popImageSize:type];
//    CGSize buttonImageSize = [self popButtonImageSize:type];
    
    JHPopPlaceStyle style =  [self placePopStyle:type];
    [JHMaskPopWindow showPopWindowWithPopImage:popImage
                                  popImageSize:popImageSize
                                      popStyle:style
                                cancelPosition:JHPopCancelPositionTopRight
                                   actionBlock:^(BOOL isEnter) {
        /// 弹窗点击事件埋点
        [self growingActionPoint:isEnter type:type];

        if (isEnter) {
            if (![JHRootController isLogin]) {
                [JHRootController presentLoginVC];
                return;
            }
            if (type == JHMaskPopWindowTypeRedbag) {
                [[self shareApiManager] grantRegbag];
            }
            else if (type == JHMaskPopWindowTypeGift) {
                [[self shareApiManager] grantGift];
            }
            else {
                [JHMaskPopWindow dismiss];
            }
        }
        else {
            ///取消的block回调
            if (type == JHMaskPopWindowTypeRedbag) {
                ///红包
                [[JHMaskPopWindow defaultWindow] closeToLittle];
             }
             else {
                [JHMaskPopWindow dismiss];
            }
        }
    }];
}

+ (void)growingActionPoint:(BOOL)isEnter type:(JHMaskPopWindowType)type {
    NSDictionary *params = [[self shareApiManager] growingParams];
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
        {
            if (isEnter) {
                ///领取
                [GrowingManager grawRedbagClick:params];
            }
            else {
                [GrowingManager cancelRedbagClick:params];
            }
        }
            break;
        case JHMaskPopWindowTypeGift:
        {
            if (isEnter) {
                ///领取红包/礼物按钮点击事件埋点
                [GrowingManager furlGiftBtnClick:params];
            }
            else {
                ///取消领取红包埋点
                [GrowingManager cancelGiftClick:params];
            }
        }
        default:
            break;
    }
}

///移除弹窗
+ (void)dismissPopWindow {
    [JHMaskPopWindow dismiss];
}

///给用户发放红包
- (void)grantRegbag {
    [[JHMaskingManager shareApiManager] getUserRedbagInfo:^(BOOL isNeedGrant, NSString *message) {
        if (isNeedGrant) {
            [self commitDataWithwindowType:JHMaskPopWindowTypeRedbag];
        }
        else {
            NSString *str = [message isNotBlank] ? message:@"您已经领取过红包了哦~";
            [UITipView showTipStr:str];
            [JHMaskPopWindow dismiss];
        }
    }];
}

///发放礼物前判断是否下发过礼物
- (void)grantGift {
    [[JHMaskingManager shareApiManager] getUserGiftInfo:^(BOOL isNeedGrant, NSString *message) {
        if (isNeedGrant) {
            [self commitDataWithwindowType:JHMaskPopWindowTypeGift];
        }
        else {
            NSString * str = [message isNotBlank] ? message:@"您已经领取过礼物了哦~";
            [UITipView showTipStr:str];
            [JHMaskPopWindow dismiss];
        }
    }];
}

///提交领取红包/礼物数据
-(void)commitDataWithwindowType:(JHMaskPopWindowType)type {
    NSString *dataType = [self dataType:type];
    [self commitData:dataType completeBlock:^(BOOL hasError, NSString *message) {
        NSString *str = hasError ? @"领取失败" : @"领取成功";
        if(!hasError)
        {
            [JHMaskPopWindow removeLittleBtn];
            [[JHMaskPopWindow defaultWindow] updateRedpacketDetail];
            [[JHMaskPopWindow defaultWindow] showDetailRedpacket];
        }
        [UITipView showTipStr:message ?: str];
    }];
}

#pragma mark - 参数相关

+ (JHPopPlaceStyle)placePopStyle:(JHMaskPopWindowType)type {
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
            return JHPopPlaceStyleCombine;
            break;
            case JHMaskPopWindowTypeGift:
                return JHPopPlaceStyleSeparate;
                break;
        default:
            return 0;
            break;
    }
}

- (NSString *)dataType:(JHMaskPopWindowType)type {
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
            return @"redbag";
            break;
            case JHMaskPopWindowTypeGift:
                return @"gift";
                break;
        default:
            return nil;
            break;
    }
}

+ (NSString *)popImage:(JHMaskPopWindowType)type {
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
//            return @"icon_new_redpage";
        {
            JHStoreNewRedpacketModel *model = [JHMaskingManager shareApiManager].redpacketModel;
            if (model) {
                NSString *firstImg = model.firstImg;
                NSString *secImg = model.secondImg;
                NSString *fImg = [CommonTool isBlankString:firstImg] ? @"":firstImg;
                NSString *sImg = [CommonTool isBlankString:secImg] ? @"":secImg;
                return [NSString stringWithFormat:@"%@img1&&&&&img2%@",fImg,sImg];
            }else{
                return @"";
            }
            
        }
            break;
            case JHMaskPopWindowTypeGift:
                return @"icon_new_gift";
                break;
        default:
            return @"";
            break;
    }
}

+ (NSString *)popButtonImage:(JHMaskPopWindowType)type {
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
            return @"icon_newuser_redpacket_receive";
            break;
            case JHMaskPopWindowTypeGift:
                return @"icon_new_gift_btn";
                break;
        default:
            return @"";
            break;
    }
}

+ (CGSize)popImageSize:(JHMaskPopWindowType)type {
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
            return redbagPopImageSize;
            break;
            case JHMaskPopWindowTypeGift:
                return giftPopImageSize;
                break;
        default:
            return CGSizeZero;
            break;
    }
}

+ (CGSize)popButtonImageSize:(JHMaskPopWindowType)type {
    switch (type) {
        case JHMaskPopWindowTypeRedbag:
            return redbagButtonSize;
            break;
            case JHMaskPopWindowTypeGift:
                return giftButtonSize;
                break;
        default:
            return CGSizeZero;
            break;
    }
}

///埋点参数
- (NSDictionary *)growingParams {
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    if (![userId isNotBlank]) {
        userId = @"";
    }
    NSDictionary *params = @{@"user_id":userId,
                            @"time":@([[CommHelp getNowTimeTimestampMS] integerValue]),
                            @"deviceId":[GrowingManager getDeviceId]
    };
    return params;
}

/// 根据类型显示弹窗
/// @param type 弹窗类型
+ (void)showPopWindowWithType:(JHMaskPopWindowType)type {
    JHAppAlertModel *m = [JHAppAlertModel new];
    m.type = (type == JHMaskPopWindowTypeRedbag ? JHAppAlertTypeNewUserRedPacket : JHAppAlertTypeGift);
    m.localType = JHAppAlertLocalTypeMallPage;
    m.typeName = (type == JHMaskPopWindowTypeRedbag ? AppAlertNewSellerPacket : AppAlertNewAppraisePacket);;
    [JHAppAlertViewManger addModelArray:@[m]];
}

+ (void)showLittleRedpoket {
    [[JHMaskPopWindow defaultWindow] makeLittleImage:[JHMaskingManager shareApiManager].redpacketModel];
    [[JHMaskPopWindow defaultWindow] closeToLittle];
}

/// 显示新手红包的规则
+ (BOOL)showRedPacketRegular {
    //没领取的用户 每天启动次数前三次显示

    BOOL isShow = NO;
    NSString *key = @"CountTodayLaunch";
    NSString *dateCount = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *today = [CommHelp getCurrentDate];
    NSString *value = @"";
    if (!dateCount) {
        value = [today stringByAppendingFormat:@":1"];
        isShow = YES;
    }else {
        NSArray *array = [dateCount componentsSeparatedByString:@":"];
        if (array.count == 2) {
            if ([((NSString *)array[0]) isEqualToString:today]) {
                NSInteger count = [array[1] integerValue];
                count = count + 1;
                if (count <= 3) {
                    isShow = YES;
                }
                value = [today stringByAppendingFormat:@":%zd", count];

                
            } else {
                value = [today stringByAppendingFormat:@":1"];
                isShow = YES;
            }
        }
    }
    if (isShow) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return isShow;
}

+ (void)removeRedPocketKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CountTodayLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)showNewUserRedPacketWithRedpacketModel:(JHStoreNewRedpacketModel *)model {
    [JHMaskingManager shareApiManager].redpacketModel = model;
    [JHMaskPopWindow defaultWindow].redpacketModel = model;
    if (![JHRootController isLogin]) {
        if ([JHMaskingManager showRedPacketRegular]) {
            [JHMaskingManager showPopWindowWithType:JHMaskPopWindowTypeRedbag];
        }
        else {
            [JHMaskingManager showLittleRedpoket];
        }
    }
    else {
        [[JHMaskingManager shareApiManager] getUserRedbagInfo:^(BOOL isNeedGrant, NSString *message) {
            if (isNeedGrant) {  ///需要发放红包
                [JHMaskingManager showLittleRedpoket];
            }
        }];
    }
}

+ (void)loginSuccess {
    [[JHMaskingManager shareApiManager] getUserRedbagInfo:^(BOOL isNeedGrant, NSString *message) {
        if (!isNeedGrant) {
            [JHMaskPopWindow dismiss];
        }else
        {
             [JHMaskingManager showLittleRedpoket];
        }
    }];
}

@end
