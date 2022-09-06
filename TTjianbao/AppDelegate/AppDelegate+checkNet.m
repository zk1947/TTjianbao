//
//  AppDelegate+checkNet.m
//  TTjianbao
//
//  Created by user on 2021/7/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "AppDelegate+checkNet.h"
#import <CoreTelephony/CTCellularData.h>
#import "JHASAManager.h"

@implementation AppDelegate (checkNet)
/*
 * 检测网络权限
 * 网络权限变更会调用 openDevice 方法
 * 解决新用户无网络授权时，无法模糊归因
 */

- (void)checkInternetPermission {
    // 应用启动后,检测应用中是否有联网权限
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        CTCellularData * cellularData = [[CTCellularData alloc] init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
//            switch (state) {
//                case kCTCellularDataRestricted:
//                    // app网络权限受限
//                    NSLog(@"app网络权限===受限");
//                    break;
//                case kCTCellularDataRestrictedStateUnknown:
//                    // app网络权限不确定
//                    NSLog(@"app网络权限===不确定");
//                    break;
//                case kCTCellularDataNotRestricted:
//                    // app网络权限不受限
//                    NSLog(@"app网络权限===不受限");
//                    /// 获取归因数据包
//                    break;
//                default:
//                    break;
//            }
            NSString *url = FILE_BASE_STRING(@"/index/openDevice");
            [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
            } failureBlock:^(RequestModel * _Nullable respondObject) {
            }];
        };
    }
}

@end
