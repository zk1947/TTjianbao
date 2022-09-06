//
//  JHKeyChainExt.h
//  TTjianbao
//  Description:系统最原始的方式存取keychain【不允许引用三方库时,使用】
//  Created by jesee on 30/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHKeyChainExt : NSObject

//读取数据
+ (NSString *)readExtValue;
//保存数据
+ (void)saveExtValue:(NSString *)aValue;
@end

NS_ASSUME_NONNULL_END
