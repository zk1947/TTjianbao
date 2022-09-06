//
//  NOSUpImageTool.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NOSUpImageTool.h"
#import "NOSSDK.h"
#import "CommHelp.h"

@interface NOSUpImageTool()
{
    
    NOSUploadManager *upManager;
    succeedBlock successblock;
    failureBlock failueblock;
    NOSFormData * nosFormData;
}

@end

@implementation NOSUpImageTool
+ (instancetype)getInstance{
    
    static NOSUpImageTool *upImageTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        upImageTool = [[self alloc] init];
        
    });
    return upImageTool;
}
-(id)init{
    
    self = [super init];
    if (self) {
        
        //        NOSConfig *conf = [[NOSConfig alloc] initWithLbsHost: @"https://lbs-eastchina1.126.net"
        //                                               withSoTimeout: 30
        //                                         withRefreshInterval: 2 * 60 * 60
        //                                               withChunkSize: 128 * 1024
        //                                         withMoniterInterval: 120
        //                                              withRetryCount: 2];
        //        [NOSUploadManager setGlobalConf:conf];
        //
        upManager = [NOSUploadManager sharedInstanceWithRecorder:nil
                                            recorderKeyGenerator:nil];
        
    }
    return self;
}
-(void)upImageWithformData:(NOSFormData *)data
              successBlock:(succeedBlock)success
              failureBlock:(failureBlock)failure{
    
    successblock=success;
    failueblock=failure;
    nosFormData=data;
    
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/auth/upload/wy/token?fileExt=jpg&fileDir=") stringByAppendingString:OBJ_TO_STRING(data.fileDir)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        nosFormData.imgUrl=respondObject.data[@"successUrl"];
        
        [upManager putFileByHttp: [CommHelp saveImage:nosFormData.fileImage]
                          bucket: respondObject.data[@"bucket"]
                             key:respondObject.data[@"fileName"]
                           token: respondObject.data[@"token"]
                        complete: ^(NOSResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info==%@", info); // 请求的响应信息、是否出错保存在info中
            NSLog(@"resp==%@", resp); // 请求的响应返回的json保存在resp中，用户一般无需此信息
            if (info.isOK) {
                
                RequestModel *respondObject =[[RequestModel alloc ] init];
                respondObject.data=nosFormData.imgUrl;
                
                dispatch_async(dispatch_get_main_queue(),  ^{
                    if (successblock) {
                        successblock(respondObject);
                    }
                });
                
                
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(),  ^{
                    RequestModel *model = [[RequestModel alloc] init];
                    model.message = @"上传失败";
                    if (failure) {
                        failure(model);
                    }
                });
                
            }
            
        }
                          option: nil];
        
    } failureBlock:^(RequestModel *respondObject) {        
        if (failueblock) {
            failueblock(respondObject);
        }
        
    }];
    
}

- (void)failureBlock:(failureBlock)failure errorResponse:(NSString *)message{
    
    //    NSLog(@"jsonDic==%@",message);
    
    RequestModel *model = [[RequestModel alloc] init];
    model.message = message?:@"";
    if (failure) {
        failure(model);
    }
}
@end

@implementation NOSFormData

@end
