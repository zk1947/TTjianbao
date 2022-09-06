//
//  NSString+AES.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/26.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "NSString+AES.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#define AESKey @"kjsk#@#$)dfj!@#1"

/////电子签约认证信息加/解密的key
//#define SIGN_AES_KEY        @"#uDanplD#Zv9%wlM"
//#define SIGN_AES_IV_KEY     @"0x8vIDvzBrZAF472"

@implementation NSString (AES)

- (NSString *)aci_encryptWithAES {
    return [self aci_encryptAESWithKey:AESKey iv:AESKey];
}

- (NSString*)aci_decryptWithAES {
    return [self aci_decryptWithAESWithKey:AESKey iv:AESKey];
}


- (NSString *)aci_encryptAESWithKey:(NSString *)key iv:(NSString *)iv {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *retData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:key
                                         iv:iv];
    NSString *retStr = [retData base64EncodedStringWithOptions:0];
    retStr = [retStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    retStr = [retStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    retStr = [retStr stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    return retStr;
}

- (NSString *)aci_decryptWithAESWithKey:(NSString *)key iv:(NSString *)iv {
    NSMutableString * base64Str = [[NSMutableString alloc]initWithString:self];
    base64Str = [NSMutableString stringWithString:[base64Str stringByReplacingOccurrencesOfString:@"-" withString:@"+"]];
    base64Str = [NSMutableString stringWithString:[base64Str stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    NSInteger mod4 = base64Str.length % 4;
    if(mod4 > 0) {
        [base64Str appendString:[@"====" substringToIndex:(4-mod4)]];
    }
    NSLog(@"Base64原文：%@", base64Str);
    
    //base64解码
    NSData *base64DecodedData = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
    //AES解码
    NSData *retData = [self AES128operation:kCCDecrypt
                                       data:base64DecodedData
                                        key:key
                                         iv:iv];
    NSString *decryptString = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    return decryptString;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    
    char keyPtr[kCCKeySizeAES128 + 1];  //kCCKeySizeAES128是加密位数 可以替换成256位的
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 设置加密参数
    /**
     这里设置的参数ios默认为CBC加密方式，如果需要其他加密方式如ECB，在kCCOptionPKCS7Padding这个参数后边加上kCCOptionECBMode，即kCCOptionPKCS7Padding | kCCOptionECBMode，但是记得修改上边的偏移量，因为只有CBC模式有偏移量之说
     
     */
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}




@end
