
//
//  main.m
//  TTjianbao
//
//  Created by chris on 16/2/24.
//  Copyright © 2016年 Netease. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
   
    @autoreleasepool {
        /*
         * 为解决神策，新增全埋点点击track事件后，和GIO 相互hook 代码导致崩溃
         * 故此处修改GIO数据采集方式
         */
//        [Growing setAspectMode:GrowingAspectModeDynamicSwizzling];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
