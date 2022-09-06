//
//  SourceMallApiManager.h
//  TTjianbao
//
//  Created by jiang on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTjianbaoMarcoKeyword.h"


@interface SourceMallApiManager : NSObject

/**
 *获取周年庆-源头直播-皮肤-落地页跳转url
 *@param response
 */
+ (void)getCelebrateMallDetailUrl:(JHResponse)response;

/**
获取源头直播分类
 @param completion completion description
 */
+ (void)getMallCateCompletion:(JHApiRequestHandler)completion;

/**
 获取卖场banner

 @param completion completion description
 */
+ (void)getMallBannerCompletion:(JHApiRequestHandler)completion;



/**
 我的关注列表

 @param completion completion description
 
 */
+ (void)getMallMyAttentonCompletion:(JHApiRequestHandler)completion;

+(void)requestGroupConditionArrayBlock:(void (^) (NSArray *modelArray))block;


/// 我的足迹列表
/// @param completion completion description
+ (void)getMallMyWatchTrackCompletion:(JHApiRequestHandler)completion;


/// 专题和专区接口
/// @param completion completion description
+ (void)getMallSpecialAreaCompletion:(JHApiRequestHandler)completion;

///删除指定文件数据
+ (void)deleteDataFromFiles;

/// 获取源头直播首页为宝友把关数量
/// @param completion 数量放在data里了
+ (void)requestOrderCountBlock:(JHApiRequestHandler)completion;


/// 新专区接口，后端可配置楼层
/// @param completion completion description
+ (void)getMallCustomSpecialAreaCompletion:(JHApiRequestHandler)completion;

/// 列表单独广告位接口
/// @param completion completion description
+ (void)getMallListAdvertCompletion:(JHApiRequestHandler)completion;

/**
获取源头直播分类 新接口
  @param groupId   获取一级分类传空， 获取二级分类传一级分类id。
 @param completion completion description
 */
+ (void)getSourceMallCate:(NSString*)prentId Completion:(HTTPCompleteBlock)completion;

//获取直播间频道频道详情
+ (void)getChannelDetail:(NSString *)ID Completion:(void(^)(BOOL hasError, ChannelMode* channelMode))completion;

///请求直播购物页面每个标签下的运营位数据
+ (void)getMallGroupBannerList:(NSString *)definiSerial Completion:(HTTPCompleteBlock)block;


@end

