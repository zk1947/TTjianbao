//
//  HttpDownLoadFileTool.h
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpDownLoadFileTool : NSObject
+ (HttpDownLoadFileTool *)shareInstance;
- (void)downLoadFileByURL:(NSString *)url andFilePath:(NSString*)path   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@property(strong,nonatomic)  NSString *orderDirectory;
@end

NS_ASSUME_NONNULL_END
