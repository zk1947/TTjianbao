//
//  HttpDownLoadFileTool.m
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "HttpDownLoadFileTool.h"
static HttpDownLoadFileTool *shareInstance;

@interface HttpDownLoadFileTool ()
@property(strong,nonatomic)  AFHTTPSessionManager *manager;
@end
@implementation HttpDownLoadFileTool

+ (HttpDownLoadFileTool *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[HttpDownLoadFileTool alloc]init];
    });
    return shareInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
     _manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)downLoadFileByURL:(NSString *)url andFilePath:(NSString*)path  progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:request
                                                                 progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                     //下载进度
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         if (downloadProgressBlock) {
                                                                             downloadProgressBlock(downloadProgress);
                                                                         }
                                                                     });
                                                                 }
                                                              destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                  //保存的文件路径
                                                                    return [NSURL fileURLWithPath:path];
                                                              }
                                                        completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if (completionHandler) {
                                                                    completionHandler(response,filePath,error);
                                                                }
                                                                NSLog(@"filePath==%@",filePath);
                                                            });
                                                        
                                                        }];
    //执行Task
    [download resume];
    
    
    
    
    
}

- (NSString *)orderDirectory
{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [doc stringByAppendingPathComponent:@"order"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
@end
