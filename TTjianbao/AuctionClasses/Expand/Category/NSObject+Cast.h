//
//  NSObject+Cast.h
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Cast)
+ (instancetype)cast:(id)object;
+ (BOOL)has:(id)object;
- (BOOL)isEmpty;
@end

NS_ASSUME_NONNULL_END
