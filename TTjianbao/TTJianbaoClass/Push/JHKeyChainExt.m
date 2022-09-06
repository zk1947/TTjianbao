//
//  JHKeyChainExt.m
//  TTjianbao
//
//  Created by jesee on 30/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHKeyChainExt.h"

#define kExtService @"JHExtService"
#define kExtAccount @"JHExtAccount"
#define kExtAccessGroup @"com.tianmou.jianbao.accessGroups"

@implementation JHKeyChainExt

+ (void)saveExtValue:(NSString *)aValue
{
    NSData *encodeValueData = [aValue dataUsingEncoding:NSUTF8StringEncoding];

    // if password was existed, update
    NSString *originValue = [self readExtValue];

    if (originValue.length > 0) {
        NSMutableDictionary *updateAttributes = [NSMutableDictionary dictionary];
        updateAttributes[(__bridge id)kSecValueData] = encodeValueData;

        NSMutableDictionary *query = [self keychainQueryWithService:kExtService account:kExtAccount accessGroup:kExtAccessGroup];
        OSStatus statusCode = SecItemUpdate(
                                           (__bridge CFDictionaryRef)query,
                                           (__bridge CFDictionaryRef)updateAttributes);
        NSAssert(statusCode == noErr, @"Couldn't update the Keychain Item." );
    }else{
        // else , add
        NSMutableDictionary *attributes = [self keychainQueryWithService:kExtService account:kExtAccount accessGroup:kExtAccessGroup];
        attributes[(__bridge id)kSecValueData] = encodeValueData;

        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)attributes, nil);

        NSAssert(status == noErr, @"Couldn't add the Keychain Item.");
    }
}

+ (NSString *)readExtValue
{
    NSMutableDictionary *attributes = [self keychainQueryWithService:kExtService account:kExtAccount accessGroup:kExtAccessGroup];
    attributes[(__bridge id)kSecMatchLimit] = (__bridge id)(kSecMatchLimitOne);
    attributes[(__bridge id)kSecReturnAttributes] = (__bridge id _Nullable)(kCFBooleanTrue);
    attributes[(__bridge id)kSecReturnData] = (__bridge id _Nullable)(kCFBooleanTrue);

    CFMutableDictionaryRef queryResult = nil;
    OSStatus keychainError = noErr;
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)attributes,(CFTypeRef *)&queryResult);
    if (keychainError == errSecItemNotFound) {
        if (queryResult) CFRelease(queryResult);
        return nil;
    }else if (keychainError == noErr) {

        if (queryResult == nil){return nil;}

        NSMutableDictionary *resultDict = (__bridge NSMutableDictionary *)queryResult;
        NSData *valueData = resultDict[(__bridge id)kSecValueData];
        CFRelease(queryResult);
        NSString *mVlaue = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];

        return mVlaue;
    }else
    {
        NSAssert(NO, @"Serious error.\n");
        if (queryResult) CFRelease(queryResult);
    }

    return nil;
}

+ (NSMutableDictionary *)keychainQueryWithService:(NSString *)service account:(NSString *)account accessGroup:(NSString *)accessGroup
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];

    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;

    query[(__bridge id)kSecAttrService] = service;

    query[(__bridge id)kSecAttrAccount] = account;

//    query[(__bridge id)kSecAttrAccessGroup] = accessGroup;

    return query;
}

@end
