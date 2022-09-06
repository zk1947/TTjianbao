//
//  JHAiyunOSSManager.h
//  TTjianbao
//
//  Created by bailee on 2019/7/19.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHAiyunOSSManager : NSObject

+ (JHAiyunOSSManager *)shareInstance;
- (void)uopladImage:(NSArray <UIImage*>*)images finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock;
- (void)uploadVideoByPath:(NSString *)videoPath finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock;

- (void)uopladImage:(NSArray <UIImage*>*)images returnPath:(NSString *)path
        finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock;
- (void)uopladTemplateImage:(NSArray <UIImage*>*)images returnPath:(NSString *)path finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock;
- (void)uploadVideoByPath:(NSString *)videoPath returnPath:(NSString *)path finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock;

- (void)uploadVideoByPaths:(NSArray <NSString*>*)videoPaths returnPath:(NSString *)path finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* videoKeys))finishBlock;

///上传图片
//- (void)uploadImage:(NSArray <UIImage*>*)images uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock;
//
/////上传视频
//- (void)uploadVideoByPath:(NSString *)videoPath uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock;

@end

NS_ASSUME_NONNULL_END
