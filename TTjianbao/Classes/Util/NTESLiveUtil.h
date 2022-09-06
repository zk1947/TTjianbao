//
//  NTESLiveUtil.h
//  NIMDemo
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <NIMSDK/NIMSDK.h>
#import "NTESLiveViewDefine.h"

@interface NTESLiveUtil : NSObject

+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
                                  minSize:(CGSize)imageMinSize
                                  maxSize:(CGSize)imageMaxSize;


//接收时间格式化
+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;

+ (void)sessionWithInputURL:(NSURL*)inputURL
                  outputURL:(NSURL*)outputURL
               blockHandler:(void (^)(AVAssetExportSession*))handler;

+ (NSDictionary *)dictByJsonData:(NSData *)data;

+ (NSDictionary *)dictByJsonString:(NSString *)jsonString;

+ (NSString *)liveTypeToString:(NTESLiveType)type;

+ (NSString *)dataTojsonString:(id)object;

+ (NSString *)jsonString:(NSString *)destinationJsonString addJsonString:(NSString *)jsonString;

+ (NTESLiveType)stringToLiveType:(NSString *)string;

+ (NTESFilterType)changeToLiveType:(NSInteger)index;

@end
