//
//  CommonTool.h
//  DoctorPlatForm
//
//  Created by 宋志明 on 15-4-29.
//  Copyright (c) 2015年 songzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CommonTool : NSObject
//找到最近的上一级 ViewController
+ (UIViewController *)findNearsetViewController:(UIView *)view;
/**
 *  得到目标路径文件的大小
 *  @param path 文件路径
 *  @return 文件大小
 */
+ (unsigned long long)fileSizeForPath:(NSString *)path;
//判断特殊字符
+ (BOOL)checkStrIsSpecial:(NSString *)str;
//判断是否全是数字
+ (BOOL)checkPhoneStr:(NSString *)str;
//判断系统
+ (BOOL)isSystemVersioniOS8;
//判断 是否开启通知
+ (BOOL)isAllowedNotification;
//判断是否有emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;
//判断 是否有相册权限
+ (BOOL)isAllowPhoto;
//判断 是否有相机权限
+ (BOOL)isAllowTakePhoto;
//判断字符串空和 空格
+ (BOOL)isBlankString:(NSString *)string;
//返回window上有几个alertview
+ (int)backAlertViewNumber;
//使用cagradientlayer设置view的渐变效果
//+ (CAGradientLayer *)shadowAsInverse;

//替换null  == ""
+(NSDictionary *)nullDic:(NSDictionary *)myDic;
+(NSArray *)nullArr:(NSArray *)myArr;
+(NSString *)stringToString:(NSString *)string;
+(NSString *)nullToString;
+(id)changeType:(id)myObj;
@end
