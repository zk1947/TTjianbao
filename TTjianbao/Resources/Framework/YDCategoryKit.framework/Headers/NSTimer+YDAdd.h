//
//  NSTimer+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (YDAdd)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)(void))block repeats:(BOOL)yesOrNo;

@end
