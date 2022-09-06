//
//  JHNetwork.h
//  TTjianbao
//
//  Created by Jesse on 2020/1/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHNetwork_h
#define JHNetwork_h

#import "RequestModel.h" //以后网络合并,考虑model也合并
#import "JHRequestModel.h"
#import "JHResponseModel.h"

/**
 网络返回码
 */
#define kNetworkResponseCodeSuccess 1000 //操作成功
#define kNetworkResponseCodeFailed 1001  //操作失败
#define kNetworkResponseCodeUnauthorized 1002 //登录失败
#define kNetworkResponseCodeHttpError 1003  //HTTP异常
#define kNetworkResponseCodeInvalidToken 1004 //token无效
#define kNetworkResponseCodeInvalidParam 1005 //参数有误
#define kNetworkResponseCodeInvalidPhoneNum 1006 //验证手机号-无效手机号
#define kNetworkResponseCodeInvalidPhoneVerifyCode 1007 //验证手机验证码-无效
#define kNetworkResponseCodeInvalidVerifyParams 1008 //表单校验错误???
#define kNetworkResponseCodeBanUser 1008 //封禁code???重复
#define kNetworkResponseCodeIllegalState 1009 //错误的状态???
#define kNetworkResponseCodeNotFound 1010 //未找到
#define kNetworkResponseCodeRepeatSubmit 1011 //重复提交
#define kNetworkResponseCodeSigned 1700 //已签到
#define kNetworkResponseCodeCouponReceived 1710 //优惠券已领取
#define kNetworkResponseCodeLadderNoDisplay 1720 //无需展示津贴按钮
#define kNetworkResponseCodeLadderWithdrawFrozen 1800 //不能提现「1800 -- 1900 提现错误code」
#define kNetworkResponseCodeSystemBusy 2001 //系统繁忙
#define kNetworkResponseCodeIllegalState2 2002 //不正确的状态???重复

/**
 网络返回提示语
 */
#define kNetworkLinkFailTips @"连接失败,请检查网络"
#define kNetworkOkRequestFailTips @"错误"  //待完善

/**
 网络回调block回传值：
 respData:RequestModel.data
 errorMsg:RequestModel.message
 code:直接区分成功与失败,code=1000成功,直接使用respData;否则读取errorMsg,提示用户
 */
typedef void (^JHResponse)(id respData,  NSString *errorMsg);
typedef void (^JHSuccess)(id respData); //可能是模型或数组
typedef void (^JHFailure)(NSString *errorMsg);
typedef void (^JHApiRequestHandler)(RequestModel *respondObject ,  NSError *error);

#import "HttpRequestTool.h"

#endif /* JHNetwork_h */
