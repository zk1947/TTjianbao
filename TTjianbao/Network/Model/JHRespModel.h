//
//  JHRespModel.h
//  TTjianbao
//  Description:网络返回基类
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* 目前与HttpRequestTool中RequestModel数据结构对应
* */
@interface JHNetworkResponse : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id data;
@end

@interface JHRespModel : NSObject

/**网络返回code,~~暂时不用~~
* 它对应RequestModel中的code,
* 目前HttpRequestTool中用RequestModel接收的respondObjectj数据结构
* */
@property(nonatomic, assign) NSInteger code;

//字典或数组转模型
+ (id)convertData:(id)data;

//返回nil,避免警告
+ (NSString*)nullMessage;

@end

