//
//  JHLuckyBagModel.h
//  TTjianbao
//
//  Created by zk on 2021/11/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHLuckyBagPlatformModel;
@class JHLuckyBagMarchantModel;

@interface JHLuckyBagModel : NSObject

@property (nonatomic, assign) BOOL haveOngoingBag;//是否存在正在进行中的福袋 true-存在，false-不存在

@property (nonatomic, assign) BOOL needShowBag;//是否需要展示福袋 true-展示，false-不展示

@property (nonatomic, assign) int todayBagCount;//今日已发福袋数量

@property (nonatomic, strong) JHLuckyBagPlatformModel *platformBagConfig;

@property (nonatomic, strong) JHLuckyBagMarchantModel *sellerBagConfig;

@end

@interface JHLuckyBagPlatformModel : NSObject

@property (nonatomic, assign) int bagPrizeMax;//每个福袋奖品上限

@property (nonatomic, assign) int countdownSeconds;//开奖时间/秒

@property (nonatomic, assign) int dayBagMax;//每日福袋上限

@property (nonatomic, assign) int ID;//平台配置id

@end

@interface JHLuckyBagMarchantModel : NSObject

@property (nonatomic, assign) int ID;//商家福袋id

@property (nonatomic, assign) int lastCountDownSeconds;//剩余倒计时 - 秒

@property (nonatomic, assign) int prizeNumber;//奖励数量

@property (nonatomic, assign) int productCateId;//商品分类id

@property (nonatomic, copy) NSString *bagKey;//福袋口令

@property (nonatomic, copy) NSString *bagTitle;//福袋标题

@property (nonatomic, copy) NSString *imgUrl;//商品图url

@property (nonatomic, copy) NSString *productCateName;//商品分类name

@end

NS_ASSUME_NONNULL_END
