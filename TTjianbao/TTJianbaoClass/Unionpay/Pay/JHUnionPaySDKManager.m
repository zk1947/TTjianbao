//
//  JHUnionPaySDKManager.m
//  TTjianbao
//
//  Created by yaoyao on 2020/6/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionPaySDKManager.h"

#import "UMSPPPayUnifyPayPlugin.h"
#import "UMSPPPayPluginSettings.h"

#import "TTjianbaoUtil.h"
#import "JHEnvVariableDefine.h"

@implementation JHUnionPayResultInfo

@end

@implementation JHUnionPaySDKManager


+ (void)startUniconPay {
    //注册微信支付
   // wxf1ff86749cc69b3f
    [UMSPPPayUnifyPayPlugin registerApp:WXAPPID universalLink:AppUniversalLink];
    
    [UMSPPPayPluginSettings sharedInstance].umspSplash = NO;
    [UMSPPPayPluginSettings sharedInstance].umspEnviroment = JHEnvVariableDefine.serviceType > JHServiceTypeRelease ? UMSP_TEST : UMSP_PROD;
}

+ (void)payWithPayChannelType:(JHPayType)payType payData:(id)payData callbackBlock:(nonnull void (^)(JHUnionPayResultInfo * _Nonnull))callback {
    NSString *channel = @"";
    switch (payType) {
        case JHPayTypeWxPay:
            channel = CHANNEL_WEIXIN;
            break;
        case JHPayTypeAliPay:
            channel = CHANNEL_ALIPAY;
            break;
            
        default:
            break;
    }

    
    [UMSPPPayUnifyPayPlugin payWithPayChannel:channel payData:payData callbackBlock:^(NSString *resultCode, NSString *resultInfo) {
        JHUnionPayResultInfo *model = [JHUnionPaySDKManager  parseResultCode:resultCode resultInfo:resultInfo];
        callback(model);
    }];
}

+ (BOOL)handleOpenURL:(NSURL *)url withDelegate:(id<WXApiDelegate>)delegate {
    return [UMSPPPayUnifyPayPlugin handleOpenURL:url otherDelegate:delegate];
}


+ (JHUnionPayResultInfo *)parseResultCode:(NSString *)resultCode resultInfo:(NSString *)info {
    
    JHUnionPayResultInfo *model = [JHUnionPayResultInfo mj_objectWithKeyValues:[info mj_keyValues]];
    model.resultCode = resultCode;
    model.resultInfo = info;
    model.isSuccess = [resultCode isEqualToString:@"0000"];
    return model;
}

@end
