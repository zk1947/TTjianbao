//
//  NSString+AES.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/26.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES)

- (NSString *)aci_encryptWithAES;//加密
- (NSString *)aci_decryptWithAES;//解密

- (NSString *)aci_encryptAESWithKey:(NSString *)key iv:(NSString *)iv;//加密
- (NSString *)aci_decryptWithAESWithKey:(NSString *)key iv:(NSString *)iv;//解密

@end

NS_ASSUME_NONNULL_END
