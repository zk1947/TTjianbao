//
//  JHLuckyBagShowModel.h
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagShowModel : NSObject

@property (nonatomic, assign) int bagStatus;//福袋状态码 1:进行中 2:已下架 3:已开奖

@property (nonatomic, copy) NSString *bagStatusDes;//福袋状态描述： 进行中 已下架 已开奖

@property (nonatomic, copy) NSString *bagTitle;//福袋标题

@property (nonatomic, assign) int configId;//配置id

@property (nonatomic, assign) NSInteger countdownSeconds;//开奖时间/秒

@property (nonatomic, copy) NSString *createTime;//活动时间

@property (nonatomic, copy) NSString *imgUrl;//图片

@property (nonatomic, assign) int prizeNumber;//奖励数量

@property (nonatomic, assign) int ID;//id

@end

NS_ASSUME_NONNULL_END
