//
//  JHNewStoreHomeSingelton.h
//  TTjianbao
//
//  Created by user on 2021/3/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreHomeSingelton : NSObject
@property (nonatomic, assign) BOOL hasBoutiqueValue;
+ (JHNewStoreHomeSingelton *)shared;
@end

NS_ASSUME_NONNULL_END
