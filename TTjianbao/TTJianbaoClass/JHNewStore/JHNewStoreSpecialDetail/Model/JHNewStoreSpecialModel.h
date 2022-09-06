//
//  JHNewStoreSpecialModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHShareInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreSpecialShowTabModel : NSObject

//专场tab表主键
@property (nonatomic, assign) long specialTabId;
//专场id
@property (nonatomic, strong) NSString * showId;
//标签名称
@property (nonatomic, strong) NSString *title;
//排序字段
@property (nonatomic, assign) NSInteger sort;

@end

@interface JHNewStoreSpecialModel : NSObject
//专场标题
@property (nonatomic, copy) NSString * title;
//封面。页眉图对应的app专场详情中的专场封面图
@property (nonatomic, copy) NSString * coverImg;
//专场状态--0 预告、1 热卖、2 结束、-1 未知
@property (nonatomic, assign) NSInteger showStatus;
//专场类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀",
@property (nonatomic, assign) NSInteger showType;
//专场标签
@property (nonatomic, strong) NSArray * tags;
//活动结束时间
@property (nonatomic, assign) long saleEndTime;
//活动开始时间
@property (nonatomic, assign) long saleStartTime;
//专场简介
@property (nonatomic, copy) NSString * showDesc;
//专场tab
@property (nonatomic, strong) NSMutableArray * showTabs;
//前台价格名称
@property (nonatomic, copy) NSString *priceName;
//热卖专场剩余时间
@property (nonatomic, assign) long remainTime;
//专场分享信息
@property (nonatomic, strong) JHShareInfo * shareInfoBean;
//终止状态 0-正常 1-终止
@property (nonatomic, assign) NSInteger stoped;
//是否隐藏 0-否 1-是
@property (nonatomic, assign) NSInteger hidden;
//开始展示时间
@property (nonatomic, assign) long displayStartTime;
//结束展示时间
@property (nonatomic, assign) long displayEndTime;
//订阅状态 0 未订阅，1 订阅"
@property (nonatomic, assign) NSInteger subscribeStatus;
@end

NS_ASSUME_NONNULL_END
