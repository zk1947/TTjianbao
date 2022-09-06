//
//  JHLuckyBagRewardModel.h
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagRewardModel : NSObject

@property (nonatomic, assign) int ID;//用户id

@property (nonatomic, copy) NSString *name;//用户名称

@property (nonatomic, copy) NSString *img;//用户头像

@property (nonatomic, copy) NSString *prizeTime;//中奖时间

@end

NS_ASSUME_NONNULL_END
