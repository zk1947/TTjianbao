//
//  CommonTool.m
//  DoctorPlatForm
//
//  Created by 宋志明 on 15-4-29.
//  Copyright (c) 2015年 songzm. All rights reserved.

#import "CommonTool.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AVFoundation/AVFoundation.h>
@implementation CommonTool
//找到最近的上一级 ViewController
+ (UIViewController *)findNearsetViewController:(UIView *)view {
    UIViewController *viewController = nil;
    for (UIView *next = view; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)nextResponder;
            break;
        }
    }
    return viewController;
}

+ (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

+ (BOOL)checkStrIsSpecial:(NSString *)str
{
    NSArray *arr = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    for (int i = 0; i < str.length; i++) {
        NSString *checkStr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *newCheckStr = [checkStr uppercaseString];
        if (![arr containsObject:newCheckStr] ) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkPhoneStr:(NSString *)str
{
    NSArray *arr = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    for (int i = 0; i < str.length; i++) {
        NSString *checkStr = [str substringWithRange:NSMakeRange(i, 1)];
        if (![arr containsObject:checkStr] ) {
            return NO;
        }
    }
    return YES;
}



+ (BOOL)isSystemVersioniOS8
{
    //check systemVersion of device
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    if (sysVersion >= 8.0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAllowedNotification
{
    if ([CommonTool isSystemVersioniOS8]) {//ios8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }else{//ios7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (UIRemoteNotificationTypeNone != type) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

+ (BOOL)isAllowPhoto
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    return YES;
}
+ (BOOL)isAllowTakePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    return YES;
}
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



+ (int)backAlertViewNumber
{
    int count = 0;
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            if ([view isKindOfClass:[UIAlertView class]]) {
                count ++;
            }
        }
    }
    return count;
}

//+ (CAGradientLayer *)shadowAsInverse
//{
//    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
//    CGRect newShadowFrame = CGRectMake(0, 0, 320, );
//    newShadow.frame = newShadowFrame;
//    //添加渐变的颜色组合
//    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor,nil];
//    return newShadow;
//}


//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
+(NSString *)nullToString
{
    return @"";
}

//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

@end
