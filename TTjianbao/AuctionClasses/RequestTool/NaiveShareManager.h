//
//  NaiveShareManager.h
//  TTjianbao
//
//  Created by jiang on 2019/8/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NaiveShareManager : NSObject
+ (NaiveShareManager *)shareInstance;
- (void)nativeShare:(NSString *)path ;

@end

NS_ASSUME_NONNULL_END
