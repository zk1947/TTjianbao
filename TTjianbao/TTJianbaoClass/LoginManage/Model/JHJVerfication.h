//
//  JHJVerfication.h
//  TTjianbao
//  Description:一键登录认证(极光)
//  Created by Jesse on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVERIFICATIONService.h"

NS_ASSUME_NONNULL_BEGIN

/** actionBlock 授权页事件触发回调。
 * 包含type和content两个参数
 * type为事件类型，content为事件描述。
 */
typedef NS_ENUM(NSInteger, JHVerficationActiveType)
{
    /*actionBlock 返回type*/
    JHVerficationActiveTypePageClose = 1, //1,授权页被关闭
    JHVerficationActiveTypePageOpen = 2, //2,授权页面被拉起
    JHVerficationActiveTypeAgreementClick = 3, //3,运营商协议被点击
    JHVerficationActiveTypeDefine1AgreementClick = 4, //4,自定义协议1被点击
    JHVerficationActiveTypeDefine2AgreementClick = 5, //5,自定义协议2被点击
    JHVerficationActiveTypeCheckBoxSelected = 6, //6,checkBox变为选中
    JHVerficationActiveTypeCheckBoxUnselected = 7, //7,checkBox变为未选中
    JHVerficationActiveTypeLoginButtonClick = 8, //8,登录按钮被点击
    /*completion登录结果:result.code*/
    JHVerficationActiveTypePhoneVerifySuccess = 1000, //手机号验证一致
    JHVerficationActiveTypePhoneVerifyFail = 1001, //手机号验证不一致
    JHVerficationActiveTypeUnknowResult = 1002, //未知结果
    JHVerficationActiveTypeNetworkNotReachable = 2003, //网络连接不通
    JHVerficationActiveTypeRequestTimeout = 2005, //请求超时
    JHVerficationActiveTypeNetworkNotSupport = 2016, //当前网络环境不支持认证
    JHVerficationActiveTypeCarrierConfigInvalid = 2017, //运营商配置无效
    JHVerficationActiveTypeInvalidedPhoneNumber = 3002, //无效电话号码
    JHVerficationActiveTypeNotEnoughMoney = 4008, //没有足够的余额
    JHVerficationActiveTypeLoginFeatureNotAvailable = 4033, //未开启一键登录
    JHVerficationActiveTypeFetchTokenSuccess = 6000, //获取loginToken成功
    JHVerficationActiveTypeFetchTokenFail = 6001, //获取loginToken失败
    JHVerficationActiveTypeUserCancelLogin = 6002, //用户取消登录
    JHVerficationActiveTypeAuthorizationRequestingTryAgainLater = 6004, //正在登录中，稍候再试
    JHVerficationActiveTypeInitSuccess = 8000, //初始化成功
    JHVerficationActiveTypeInitFail = 8004, //初始化失败
    JHVerficationActiveTypeInitTimeout = 8005, //初始化超时
};


//文档地址 http://docs.jiguang.cn/jverification/client/ios_api/
@interface JHJVerfication : NSObject

+ (void)startJVerfication;
@end

@interface JHJVerficationResult : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *loginToken;
@property (nonatomic, copy) NSString *joperator;
@end

NS_ASSUME_NONNULL_END
