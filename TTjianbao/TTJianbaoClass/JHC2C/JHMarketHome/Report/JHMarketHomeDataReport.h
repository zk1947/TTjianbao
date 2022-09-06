//
//  JHMarketHomeDataReport.h
//  TTjianbao
//
//  Created by zk on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketHomeDataReport : NSObject

/**
 首页集市-页面埋点
 */
+ (void)marketHomePageReport;

/**
 首页社区-页面埋点
 */
+ (void)marketCommunityPageReport;

/**
 首页集市-金刚位点击
 */
+ (void)kingKongTouchReport:(NSString *)kingKongName;

/**
 首页集市-点击搜索按钮
 */
+ (void)searchTouchReport;

/**
 首页集市-点击活动宫格专题资源位
 */
+ (void)specialTouchReport:(NSString *)url type:(NSString *)type;

/**
 首页集市-点击商品
 */
+ (void)goodsTouchReport:(NSString *)goodsId goodsTag:(NSString *)goodsTag goodsPrice:(NSString *)goodsPrice type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
