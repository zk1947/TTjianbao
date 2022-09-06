//
//  JHDiscoverStatisticsModel.h
//  TTjianbao
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDiscoverStatisticsModel : NSObject
//@property (nonatomic, strong) NSString * item_id;// 商品唯一标识
@property (nonatomic, strong) NSString * item_uniq_id;// 商品唯一标识
//@property (nonatomic, assign) NSTimeInterval startTime;
//@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
@end

NS_ASSUME_NONNULL_END
