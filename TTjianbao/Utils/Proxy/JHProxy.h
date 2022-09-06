//
//  JHProxy.h
//  TTjianbao
//  Description:自定义代理,做中转
//  Created by jesee on 18/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHProxy : NSProxy

//target
@property (nonatomic, weak) id target;

@end

NS_ASSUME_NONNULL_END
