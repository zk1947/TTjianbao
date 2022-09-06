//
//  JHRootViewController+TransitPage.h
//  TTjianbao
//  Description:全局方法及页面跳转
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRootViewController.h"
#import "JHLiveRoomMode.h"
#import "User.h"
@class JHMessageTargetModel;
//NS_ASSUME_NONNULL_BEGIN

@interface JHRootViewController (TransitPage)

- (void)exitApp;
- (BOOL)isLogin;
- (void)logoutAccountData;
-(void)logoutAccountDataIsShowLogin : (BOOL)isShow;
- (void)loginIM:(NSString*)Account token:(NSString*)Token completion:(id)completion;
- (void)presentLoginVC;
- (void)presentLoginVC:(void (^)(BOOL result)) loginResult;
- (void)presentLoginVCWithTarget:(UIViewController *)vc complete:(void (^)(BOOL result))loginResult;
- (void)presentLoginVCWithTarget:(UIViewController *)vc params : (NSDictionary *)params complete:(void (^)(BOOL result))loginResult;
- (void)EnterLiveRoom:(NSString*) roomId  fromString:(NSString *)from;

- (void)EnterLiveRoom:(NSString*) roomId fromString:(NSString *)from isStoneDetail:(BOOL)isStoneDetail isApplyConnectMic:(BOOL)applyConnectMic;

- (void)webToLiveRoom:(NSString*)roomId roomList:(NSArray*)list fromString:(NSString *)from;
- (void)webToNativeVCName:(NSString *)vc param:(NSString *)string;
- (void)toNativeVC:(NSString *)className withParam:(NSDictionary *)paraDic from:(NSString *)from;
- (void)messageToNativeVC:(JHMessageTargetModel*)model from:(NSString *)from;
- (void)handleMessageModel:(id)keyValues from:(NSString *)from;
- (void)getLiveDetail:(NSString*)roomId isInLiveRoom:(BOOL)inLiveRoom isStoneDetail:(BOOL)isStoneDetail;
- (void)WXBind:(NSNotification*)notify;
/// 绑定微信
/// source : 1:个人中心绑定微信 2:退出登录后调用绑定微信 3：网页调起绑定微信
- (void)bindWxWithSource : (NSString *)source block:(JHFinishBlock)block;
-(void)bindWxWithWebSource : (NSString *)source block:(JHFinishBlock)block;
- (void)buryPointWithTopicId:(NSString *)topicId;

/// 判断是否登录 如果登录直接执行闭包 ，未登录情况下先登录 然后执行闭包
/// @param vc 弹出登录的vc
/// @param loginResult 要执行的闭包
- (void)checkLoginWithTarget:(UIViewController *)vc complete:(void (^)(BOOL result))loginResult;

///进入个人主页界面
- (void)enterUserInfoPage:(NSString *)userId
                     from:(NSString *)fromSource;

///进入个人主页 区分用户身份
- (void)enterUserInfoPage:(NSString *)userId
                 user:(User*)user
                     from:(NSString *)fromSource;

///进入个人主页界面 带关注按钮回调的
- (void)enterUserInfoPage:(NSString *)userId
                     from:(NSString *)fromSource
              resultBlock:(id)block;


@end

//NS_ASSUME_NONNULL_END
