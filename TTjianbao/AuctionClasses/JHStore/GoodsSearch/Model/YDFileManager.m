//
//  YDFileManager.m
//  Cooking-Home
//
//  Created by Wuyd on 2018/7/10.
//  Copyright © 2018 Wuyd. All rights reserved.
//

#import "YDFileManager.h"

@implementation YDFileManager

// 获取沙盒根路径
+ (NSString *)getHomePath {
    return NSHomeDirectory();
}

// 获取tmp路径
+ (NSString *)getTmpPath {
    return NSTemporaryDirectory();
}

// 获取Documents路径
+ (NSString *)getDocumentsPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

// 获取Library路径
+ (NSString *)getLibraryPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

// 获取LibraryCache路径
+ (NSString *)getLibraryCachePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

// 检查文件、文件夹是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path isDirectory:isDir];
    return exist;
}

// 创建路径
+ (void)createDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!isDir) {
        [fileManager removeItemAtPath:path error:nil];
        exist = NO;
    }
    if (!exist) {
        // 注：直接创建不会覆盖原文件夹
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

// 创建文件
+ (NSString *)createFile:(NSString *)filePath fileName:(NSString *)fileName {
    // 先创建路径
    [self createDirectory:filePath];
    
    // 再创建路径上的文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [filePath stringByAppendingPathComponent:fileName];
    BOOL isDir;
    BOOL exist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDir) {
        [fileManager removeItemAtPath:path error:nil];
        exist = NO;
    }
    if (!exist) {
        // 注：直接创建会被覆盖原文件
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

// 复制 文件or文件夹
+ (void)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager copyItemAtPath:srcPath toPath:dstPath error:&error];
    if (!result && error) {
        NSLog(@"copyItem Err : %@", error.description);
    }
}

// 移动 文件or文件夹
+ (void)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager moveItemAtPath:srcPath toPath:dstPath error:&error];
    if (!result && error) {
        NSLog(@"moveItem Err : %@", error.description);
    }
}

// 删除 文件or文件夹
+ (void)removeItemAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager removeItemAtPath:path error:&error];
    if (!result && error) {
        NSLog(@"removeItem Err : %@", error.description);
    } else {
        NSLog(@"删除成功");
    }
}

// 获取目录下所有内容
+ (NSArray *)getContentsOfDirectoryAtPath:(NSString *)docPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *contentArr = [fileManager contentsOfDirectoryAtPath:docPath error:&error];
    if (!contentArr.count && error) {
        NSLog(@"ContentsOfDirectory Err : %@", error.description);
    }
    return contentArr;
}

@end
