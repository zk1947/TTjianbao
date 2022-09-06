//
//  NSObject+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 2019/7/19.
//  Copyright © 2019 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YDAdd)

#pragma mark -
#pragma mark - File M
//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName;
//创建缓存文件夹
+ (BOOL)createDirInCache:(NSString *)dirName;

//缓存图片
+ (BOOL)saveImage:(UIImage *)image imageName:(NSString *)imageName inFolder:(NSString *)folderName;
+ (NSData *)loadImageDataWithName:( NSString *)imageName inFolder:(NSString *)folderName;
+ (BOOL)deleteImageCacheInFolder:(NSString *)folderName;

//缓存网络请求
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath;//缓存请求回来的json对象
+ (id)loadResponseWithPath:(NSString *)requestPath;//返回一个NSDictionary类型的json数据
+ (BOOL)deleteResponseCacheForPath:(NSString *)requestPath;
+ (BOOL)deleteResponseCache;
+ (NSUInteger)getResponseCacheSize;

@end

NS_ASSUME_NONNULL_END
