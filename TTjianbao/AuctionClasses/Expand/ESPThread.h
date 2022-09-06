//
//  ESPThread.h
//  TTjianbao
//
//  Created by jiangchao on 2019/3/14.
//  Copyright © 2019 Netease. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ESPThread : NSObject

+ (ESPThread *) currentThread;

- (BOOL) sleep: (long long) milliseconds;

- (void) interrupt;

- (BOOL) isInterrupt;

@end

