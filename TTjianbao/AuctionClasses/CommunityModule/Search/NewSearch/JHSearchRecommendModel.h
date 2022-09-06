//
//  JHSearchRecommendModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchRecommendShopdModel : NSObject
@property (strong,nonatomic)NSString* comprehensiveScore; //综合评分
@property (strong,nonatomic)NSString* shopLogoImg;  //店铺标识
@property (strong,nonatomic)NSString * shopName; // 店铺名称
@property (strong,nonatomic)NSString * shopId;
@end

@interface JHSearchRecommendLivingModel : NSObject
@property (strong,nonatomic)NSString* anchorName; //名称
@property (strong,nonatomic)NSString* coverImg;  //封面
@property (strong,nonatomic)NSString * watchTotal; // 热度
@property (strong,nonatomic)NSString * channelLocalId;
@property (strong,nonatomic)NSString* smallCoverImg;
@end

@interface JHSearchRecommendKeyWordModel : NSObject
@property (strong,nonatomic)NSString* code; //编号
@property (strong,nonatomic)NSString* corner; //角标
@property (strong,nonatomic)NSString * icon; // ICON
@property (strong,nonatomic)NSString* isShow;  // 是否显示 0-隐藏，1-显示
@property (strong,nonatomic)NSString* landingName;  // 类型
@property (strong,nonatomic)NSString * name;  //  入口名称
@property (strong,nonatomic)NSString* operationSubjectId;  // 专题Id
@property (strong,nonatomic)NSString* sortNum;  //
@property (strong,nonatomic)NSDictionary * target;  // 落地页
@end

@interface JHSearchRecommendModel : NSObject
@property (strong,nonatomic)NSArray * operationSubjectResponses;//热门搜索词
@property (strong,nonatomic)NSArray * hotLiveResponses;  //热门直播间
@property (strong,nonatomic)NSArray * hotShopResponses;   //店铺
@end

NS_ASSUME_NONNULL_END
