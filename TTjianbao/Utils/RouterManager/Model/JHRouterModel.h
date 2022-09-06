//
//  JHRouterModel.h
//  TTjianbao
//  Description:接收模型,尽量通用
//  Created by Jesse on 2020/2/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JHRouterPresentType)
{
    JHRouterPresentTypePush,
    JHRouterPresentTypePresent
};

typedef NS_ENUM(NSInteger, JHRouterType)
{
    JHRouterTypeDefault, //默认无参
    JHRouterTypeParams, //有参数
};

NS_ASSUME_NONNULL_BEGIN

@interface JHRouterModel : NSObject

@property (nonatomic, copy) NSString* type; //页面类型->JHRouterType
@property (nonatomic, copy) NSString* presentType; //页面跳转方式,push or present
@property (nonatomic, copy) NSString* vc; //具体页面viewController
@property (nonatomic, strong) NSDictionary* params; //JHRouterControllerModel
@property (nonatomic, copy) NSString *componentName; //社区的vc

/// 埋点用-vc名称
@property (nonatomic, copy) NSString *recordComponentName;
//字典或数组转模型
+ (id)convertData:(id)data;

@end

@interface JHRouterControllerModel : NSObject

@property (nonatomic, copy) NSString* mId; //各种Id:roomId/userId/item_id/customerId..
@property (nonatomic, copy) NSString* index; //各种索引:index/currentIndex/selectedIndex
@property (nonatomic, copy) NSString* extend; //扩展字段
@end

NS_ASSUME_NONNULL_END
