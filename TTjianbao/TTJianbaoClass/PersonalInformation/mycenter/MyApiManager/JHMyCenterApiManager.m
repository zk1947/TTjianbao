//
//  JHMyCenterApiManager.m
//  TTjianbao
//
//  Created by lihui on 2020/3/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHPersonInfoModel.h"
#import "JHMyCenterApiManager.h"

@implementation JHMyCenterApiManager

+ (instancetype)shareInstance
{
    static JHMyCenterApiManager * apiManagerInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiManagerInstance = [JHMyCenterApiManager new];
    });
    return apiManagerInstance;
}

///获取签到信息
///POST /app/opt/checkin/customer/get_check
+ (void)getUserCheckInfo:(HTTPCompleteBlock)block {
    NSString *url = FILE_BASE_STRING(@"/app/opt/checkin/customer/get_check");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        if (block) {
            block(respondObject,NO);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject,YES);
        }
    }];
}

///个人中心点击签到有礼
//POST /app/opt/checkin/customer/initiative_click
+ (void)clickPersonCenterCheckBtn:(HTTPCompleteBlock)block {
    NSString *url = FILE_BASE_STRING(@"/app/opt/checkin/customer/initiative_click");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        if (block) {
            block(respondObject,NO);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject,YES);
        }
    }];
}

///是否显示签到有礼按钮
///POST /app/opt/checkin/customer/is_allowed
+ (void)isAllowCustomerCheck:(HTTPCompleteBlock)block {
    NSString *url = FILE_BASE_STRING(@"/app/opt/checkin/customer/is_allowed");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        JHAllowSignModel *model = [JHAllowSignModel mj_objectWithKeyValues:respondObject.data];
        [JHMyCenterApiManager shareInstance].allowSignModel = model;

        if (block) {
            block(model,NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject,YES);
        }
    }];
}

///弹窗点击
//POST /app/opt/checkin/customer/popup_click
+ (void)customerClickPopup:(HTTPCompleteBlock)block {
    NSString *url = FILE_BASE_STRING(@"/app/opt/checkin/customer/popup_click");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        if (block) {
            block(respondObject,NO);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject,YES);
        }
    }];
}

+ (void)commitCheckInfo {
    [JHMyCenterApiManager clickPersonCenterCheckBtn:^(RequestModel *respObj, BOOL hasError) {
        if (hasError) {
            [UITipView showTipStr:respObj.message];
        }
    }];
}

@end
