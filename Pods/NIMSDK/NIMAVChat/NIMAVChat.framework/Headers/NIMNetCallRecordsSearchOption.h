//
//  NIMNetCallRecordsSearchOption.h
//  NIMAVChat
//
//  Created by He on 2019/8/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  音视频话单搜索可选项
 */
@interface NIMNetCallRecordsSearchOption : NSObject

/**
    该时间戳之前的记录, 小于、等于0表示全部
 */
@property (nonatomic,assign) NSTimeInterval timestamp;

/**
    分页的数目
 */
@property (nonatomic,assign) NSUInteger limit;

@end

NS_ASSUME_NONNULL_END
