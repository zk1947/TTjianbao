//
//  JHShopServiceInfo.h
//  TTjianbao
//
//  Created by lihui on 2021/4/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHShopServiceInfo : NSObject
///剩余天数
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
///live:直播 shop:店铺 recycle:回收 excellent:优店
@property (nonatomic, copy) NSString *lineType;

@end

NS_ASSUME_NONNULL_END
