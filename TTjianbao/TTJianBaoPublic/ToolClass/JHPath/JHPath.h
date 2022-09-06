//
//  JHPath.h
//  TTjianbao
//
//  Created by user on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPath : NSObject
+ (NSString *)bundle;
+ (NSString *)document;
+ (NSString *)cache;
+ (NSString *)library;
+ (NSString *)temp;
+ (NSString *)download;
+ (BOOL)exists:(NSString*)path;
/**
 *  外部调用的时候需要传一个isDirectory变量
 *
 *  @param path 需要检测的路径
 *  @param isDirectory 返回是否是目录, YES是, NO不是
 *
 *  @return 路径存在则YES，否则NO；
 */
+ (BOOL)exists:(NSString *)path isDirectory:(BOOL *)isDirectory;
+ (BOOL)rm:(NSString *)path;
+ (BOOL)rm:(NSString *)path error:(NSError **)error;
/**
 *  删除旧的同名文件，创建新的文件。
 *
 *  @param path 路径名称
 */
+ (BOOL)touch:(NSString *)path;

/**
 *  创建文件夹
 *
 *  @param path 要创建的文件夹路径,会自动创建中间目录
 *
 *  @return  YES创建成功,NO创建失败
 */
+ (BOOL)mkdir:(NSString *)path;

+ (nullable NSString *)pathForResource:(NSString *)resource;

/**
 *  返回指定路径的文件的大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小
 */
+ (long long)fileSize:(NSString *)path;
+ (long long)fileSize:(NSString *)path error:(NSError **)error;

/**
 *  返回指定路径的文件夹下的文件大小。
 *
 *  @param path 文件夹路径
 *
 *  @return 文件总大小
 */
+ (long long)folderSize:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
