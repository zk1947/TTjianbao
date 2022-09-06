//
//  JHASAManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHASAManager : NSObject

+ (instancetype)sharedManager;

/// 获取归因包
- (void)asaAttribution;
@end

NS_ASSUME_NONNULL_END
