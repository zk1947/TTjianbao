//
//  JHAiyunOSSManager.m
//  TTjianbao
//
//  Created by bailee on 2019/7/19.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAiyunOSSManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import "UIImage+MultiFormat.h"
#import "NSString+AES.h"
#import "HttpRequestTool.h"
#import "NSString+NTES.h"
#import "CommHelp.h"

#define kJHAiyunImageBucketName JHEnvVariableDefine.alyunImageBucketName
#define kJHAiyunVideoBucketName JHEnvVariableDefine.alyunVideoBucketName
#define kJHAiyunPublishPath @"client_publish/content"

#define kJHAiyunEndPoint @"http://oss-cn-beijing.aliyuncs.com"
#define kJHAiyunTokenServier COMMUNITY_FILE_BASE_STRING(@"/content/getUploadToken")
#define kJHTokenAESKey @"kDKk#@#$)JLS!@#1"
#define kJHTokenAESIV @"JHsk#@#$)dfj!)(*"
                        
static JHAiyunOSSManager *shareInstance;

@interface JHAiyunOSSManager()

@property (nonatomic, strong) OSSClient *client;

@end

@implementation JHAiyunOSSManager
+ (JHAiyunOSSManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JHAiyunOSSManager alloc]init];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initAliyunClient];
    }
    return self;
}

- (void)initAliyunClient {
    if (!_client) {
        // 推荐使用OSSAuthCredentialProvider，token过期后会自动刷新。
        id<OSSCredentialProvider> credential = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:kJHAiyunTokenServier responseDecoder:^NSData * _Nullable(NSData * _Nonnull data) {
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //密文
            NSString *ciphertext = object[@"data"];
            //明文
            NSString *plaintext = [ciphertext aci_decryptWithAESWithKey:kJHTokenAESKey iv:kJHTokenAESIV];
            NSLog(@"%@",plaintext);
            
            if (plaintext.length > 0) {
                //明文字典
                NSData *jsonData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"明文字典：%@",dic);
                return jsonData;
            } else {
                NSDictionary *dic = @{@"StatusCode":@(0)};
                NSData *retData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
                return retData;
            }
        }];
        _client = [[OSSClient alloc] initWithEndpoint:kJHAiyunEndPoint credentialProvider:credential];
        
    }
}

- (void)uopladImage:(NSArray <UIImage*>*)images finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock {
    NSMutableArray *imgKesArray = [NSMutableArray arrayWithCapacity:images.count];
    
    dispatch_group_t group = dispatch_group_create();
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        put.bucketName = kJHAiyunImageBucketName;
        put.objectKey = [NSString stringWithFormat:@"%@/%@",kJHAiyunPublishPath,[self getFileNameWithType:@".jpg"]];
        put.uploadingData = [obj sd_imageDataAsFormat:SDImageFormatJPEG]; // 直接上传NSData
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        };
        OSSTask * putTask = [_client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                NSLog(@"upload object success!");
                [imgKesArray addObject:put.objectKey];
            } else {
                NSLog(@"upload object failed, error: %@" , task.error);
            }
            dispatch_group_leave(group);
            return nil;
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传结束");
        if (imgKesArray.count == images.count) {
            finishBlock(YES, imgKesArray);
        } else {
            finishBlock(NO, imgKesArray);
        }
    });
}

- (void)uploadVideoByPath:(NSString *)videoPath finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock {
    if (videoPath.length == 0) {
        return;
    }
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunVideoBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",kJHAiyunPublishPath,[self getFileNameWithType:@".mp4"]];
    put.uploadingFileURL = [NSURL URLWithString:videoPath];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        BOOL isFinished = NO;
        if (!task.error) {
            NSLog(@"upload object success!");
            isFinished = YES;
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            isFinished = NO;
        }
        if (finishBlock) {
            finishBlock(isFinished, put.objectKey);
        }
        return nil;
    }];
}

- (NSString *)getFileNameWithType:(NSString *)fileType {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];

    NSString *uuid = [CommHelp getKeyChainUUID];
    NSString *timeString = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    NSString *randString = [NSString stringWithFormat:@"%u",arc4random()];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@",uuid,timeString,randString];
    fileName = [fileName MD5String];
    
    return [NSString stringWithFormat:@"%@/%@%@",dateString,fileName,fileType];
}


- (void)uopladImage:(NSArray <UIImage*>*)images returnPath:(NSString *)path finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock {
    NSMutableArray *imgKesArray = [NSMutableArray arrayWithCapacity:images.count];
    
    dispatch_group_t group = dispatch_group_create();
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        put.bucketName = kJHAiyunImageBucketName;
        put.objectKey = [NSString stringWithFormat:@"%@/%@",path,[self getFileNameWithType:@".jpg"]];
        put.uploadingData = [obj sd_imageDataAsFormat:SDImageFormatJPEG]; // 直接上传NSData
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        };
        OSSTask * putTask = [_client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                NSLog(@"upload object success!");
                [imgKesArray addObject:put.objectKey];
            } else {
                NSLog(@"upload object failed, error: %@" , task.error);
            }
            dispatch_group_leave(group);
            return nil;
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传结束");
        if (imgKesArray.count == images.count) {
            finishBlock(YES, imgKesArray);
        } else {
            finishBlock(NO, imgKesArray);
        }
    });
}

- (void)uopladTemplateImage:(NSArray <UIImage*>*)images returnPath:(NSString *)path finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock {
    NSMutableArray *imgKesArray = [NSMutableArray arrayWithCapacity:images.count];
    
    dispatch_group_t group = dispatch_group_create();
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        put.bucketName = kJHAiyunImageBucketName;
        put.objectKey = [NSString stringWithFormat:@"%@/%@",path,[self getFileNameWithType:@".png"]];
        put.uploadingData = [obj sd_imageDataAsFormat:SDImageFormatPNG]; // 直接上传NSData
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        };
        OSSTask * putTask = [_client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                NSLog(@"upload object success!");
                [imgKesArray addObject:put.objectKey];
            } else {
                NSLog(@"upload object failed, error: %@" , task.error);
            }
            dispatch_group_leave(group);
            return nil;
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传结束");
        if (imgKesArray.count == images.count) {
            finishBlock(YES, imgKesArray);
        } else {
            finishBlock(NO, imgKesArray);
        }
    });
}
- (void)uploadVideoByPath:(NSString *)videoPath returnPath:(NSString *)path finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock {
    if (videoPath.length == 0) {
        return;
    }
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunVideoBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",path,[self getFileNameWithType:@".mp4"]];
    put.uploadingFileURL = [NSURL URLWithString:videoPath];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        BOOL isFinished = NO;
        if (!task.error) {
            NSLog(@"upload object success!");
            isFinished = YES;
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            isFinished = NO;
        }
        if (finishBlock) {
            finishBlock(isFinished, put.objectKey);
        }
        return nil;
    }];
}


- (void)uploadVideoByPaths:(NSArray <NSString*>*)videoPaths returnPath:(NSString *)path finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* videoKeys))finishBlock {
    NSMutableArray *imgKesArray = [NSMutableArray arrayWithCapacity:videoPaths.count];
    
    dispatch_group_t group = dispatch_group_create();
    [videoPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
           put.bucketName = kJHAiyunVideoBucketName;
           put.objectKey = [NSString stringWithFormat:@"%@/%@",path,[self getFileNameWithType:@".mp4"]];
           put.uploadingFileURL = [NSURL URLWithString:obj];
           put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
               NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
           };
           OSSTask * putTask = [_client putObject:put];
           [putTask continueWithBlock:^id(OSSTask *task) {
               BOOL isFinished = NO;
               if (!task.error) {
                   NSLog(@"upload object success!");
                   isFinished = YES;
                   [imgKesArray addObject:put.objectKey];

               } else {
                   NSLog(@"upload object failed, error: %@" , task.error);
                   isFinished = NO;
               }
               
               dispatch_group_leave(group);

               return nil;
           }];
        
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传结束");
        if (imgKesArray.count == videoPaths.count) {
            finishBlock(YES, imgKesArray);
        } else {
            finishBlock(NO, imgKesArray);
        }
    });
}

@end
