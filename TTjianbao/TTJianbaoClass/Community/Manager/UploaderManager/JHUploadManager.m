//
//  JHUploadManager.m
//  TTjianbao
//
//  Created by apple on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHUploadManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import "UIImage+MultiFormat.h"
#import "NSString+AES.h"
#import "HttpRequestTool.h"
#import "NSString+NTES.h"
#import "CommHelp.h"
#import <AVFoundation/AVFoundation.h>
#import "TZImageManager.h"
#define kJHAiyunImageBucketName JHEnvVariableDefine.alyunImageBucketName
#define kJHAiyunVideoBucketName JHEnvVariableDefine.alyunVideoBucketName
#define kJHAiyunVoiceBucketName JHEnvVariableDefine.alyunVoiceBucketName

#define kJHAiyunEndPoint @"http://oss-cn-beijing.aliyuncs.com"
#define kJHAiyunTokenServier COMMUNITY_FILE_BASE_STRING(@"/content/getUploadToken")
#define kJHTokenAESKey @"kDKk#@#$)JLS!@#1"
#define kJHTokenAESIV @"JHsk#@#$)dfj!)(*"

#pragma mark -
#pragma mark - 阿里云相关图片路径

///社区发布图片路径
NSString *const kJHAiyunPublishPath             = @"client_publish/content";
///君子签 商家签约 企业认证上传营业执照图片的文件路径
NSString *const kJHAiyunCertificationPath       = @"client_publish/certification";
///3.1.7新增 银联签约路径
NSString *const kJHAiyunSignContractpath        = @"client_publish/sign_contract";
///直播间商品橱窗上传icon
NSString *const kJHAiyunRoomSaleGoodsPath       = @"client_publish/room/goods/";
///直播间主播上传icon
NSString *const kJHAiyunRoomAnchorPath          = @"client_publish/user/avatar/";
///社区阿里云图片地址 --- TODO lihui 355新增路径
NSString *const kJHAiyunCommunityPath           = @"client_publish/community";
                        

@interface JHUploadManager ()

@property (nonatomic, strong) OSSClient *client;

@property (nonatomic, strong) OSSPutObjectRequest *putRequest;

@end

static JHUploadManager *shareManger = nil;

@implementation JHUploadManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManger = [[JHUploadManager alloc] init];
    });
    return shareManger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initAliyunClient];
    }
    return self;
}

///账号被踢出后 取消上传的方法
- (void)cancelUplaod {
    if (!self.putRequest.isCancelled) {
        [self.putRequest cancel];
    }
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

///上传单张图片
- (void)uploadSingleImage:(UIImage*)images filePath:(NSString *)filePath finishBlock:(void(^)(BOOL isFinished, NSString* imgKey))finishBlock {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunImageBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",filePath,[self getFileNameWithType:@".jpg"]];
    put.uploadingData = [images sd_imageDataAsFormat:SDImageFormatJPEG]; // 直接上传NSData
//    put.contentMd5 = [OSSUtil base64Md5ForFilePath:@"<filePath>"]; // 如果是文件路径
    self.putRequest = put;
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            if (finishBlock) {
                finishBlock(YES, put.objectKey);
            }
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            if (finishBlock) {
                finishBlock(NO, put.objectKey);
            }
        }
        return nil;
    }];
}

- (void)uploadGifImage:(NSData*)gifImageData filePath:(NSString *)filePath finishBlock:(void(^)(BOOL isFinished, NSString* imgKey))finishBlock {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunImageBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",filePath,[self getFileNameWithType:@".gif"]];
    put.uploadingData = gifImageData; // 直接上传NSData
    self.putRequest = put;
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            if (finishBlock) {
                finishBlock(YES, put.objectKey);
            }
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            if (finishBlock) {
                finishBlock(NO, put.objectKey);
            }
        }
        return nil;
    }];
}

///带有上传进度的上传图片的方法
- (void)uploadImage:(NSArray <UIImage*>*)images uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock {
    NSMutableArray *imgKesArray = [NSMutableArray arrayWithCapacity:images.count];

    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    static int allProgress = 0;
    @weakify(self);
    [images enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        //如果没有执行完 一直等待
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        @autoreleasepool {
            ///请求数据
            dispatch_group_enter(group);
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            put.bucketName = kJHAiyunImageBucketName;
            put.objectKey = [NSString stringWithFormat:@"%@/%@",kJHAiyunPublishPath,[self getFileNameWithType:@".jpg"]];
            put.uploadingData = [obj sd_imageDataAsFormat:SDImageFormatJPEG]; // 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                //bytesSent - 单次上传的字节数，totalByteSent - 累计上传字节数，
                //totalBytesExpectedToSend - 图片总计所需上传字节数
                NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                if (uploadProgressBlock) {
                    CGFloat progressValue = (float)totalByteSent/totalBytesExpectedToSend;
                    int tempValue = floor(progressValue*100);
                    float realUploadPercent = (float)(tempValue + allProgress)/images.count;
//                    NSLog(@"realUploadPercent:----- %.1f \n ", realUploadPercent);
                    uploadProgressBlock(realUploadPercent);
                }
            };
            self.putRequest = put;
            OSSTask * putTask = [_client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    NSLog(@"upload object success!");
                    allProgress += 100;
                    [imgKesArray addObject:put.objectKey];
                } else {
                    NSLog(@"upload object failed, error: %@" , task.error);
                }
                ///发送信号 表示图片上传完毕 可上传下一张
                dispatch_group_leave(group);
                dispatch_semaphore_signal(sema);
                return nil;
            }];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传结束");
        allProgress = 0;
        if (imgKesArray.count == images.count) {
            finishBlock(YES, imgKesArray);
        } else {
            finishBlock(NO, imgKesArray);
        }
    });
}
///带有上传进度的上传图片的方法
- (void)uploadImage_third:(NSArray <UIImage*>*)images uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock {
    NSMutableArray *imgKesArray = [NSMutableArray arrayWithCapacity:images.count];

    dispatch_group_t group = dispatch_group_create();
//    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    static int allProgress = 0;
    @weakify(self);
    [images enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        //如果没有执行完 一直等待
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        @autoreleasepool {
            ///请求数据
            dispatch_group_enter(group);
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            put.bucketName = kJHAiyunImageBucketName;
            put.objectKey = [NSString stringWithFormat:@"%@/%@",kJHAiyunPublishPath,[self getFileNameWithType:@".jpg"]];
            put.uploadingData = [obj sd_imageDataAsFormat:SDImageFormatJPEG]; // 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                //bytesSent - 单次上传的字节数，totalByteSent - 累计上传字节数，
                //totalBytesExpectedToSend - 图片总计所需上传字节数
//                NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//                if (uploadProgressBlock) {
//                    CGFloat progressValue = (float)totalByteSent/totalBytesExpectedToSend;
//                    int tempValue = floor(progressValue*100);
//                    float realUploadPercent = (float)(tempValue + allProgress);
////                    NSLog(@"realUploadPercent:----- %.1f \n ", realUploadPercent);
//                    uploadProgressBlock(realUploadPercent);
//                }
            };
            self.putRequest = put;
            OSSTask * putTask = [_client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    NSLog(@"upload object success!");
                    allProgress += 100/images.count;
                    if (uploadProgressBlock) {
                        uploadProgressBlock(allProgress);
                    }
                    [imgKesArray addObject:put.objectKey];
                } else {
                    NSLog(@"upload object failed, error: %@" , task.error);
                }
                ///发送信号 表示图片上传完毕 可上传下一张
                dispatch_group_leave(group);
//                dispatch_semaphore_signal(sema);
                return nil;
            }];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传结束");
        allProgress = 0;
        if (imgKesArray.count == images.count) {
            finishBlock(YES, imgKesArray);
        } else {
            finishBlock(NO, imgKesArray);
        }
    });
}
///带有上传进度的上传视频的方法
- (void)uploadVideoByPath:(NSString *)videoPath uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock {
    if (videoPath.length == 0) {
        return;
    }
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunVideoBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",kJHAiyunPublishPath,[self getFileNameWithType:@".mp4"]];
    put.uploadingFileURL = [NSURL URLWithString:videoPath];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (uploadProgressBlock) {
            CGFloat videoPercent = (float)totalByteSent / totalBytesExpectedToSend;
            int tempValue = floor(videoPercent*100);
            
            NSLog(@"tempValue: - %d - videoPercent: - %f", tempValue, videoPercent);
            
            uploadProgressBlock(tempValue);
        }
    };
    self.putRequest = put;

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

- (void)postRequest:(NSDictionary *)parameters successBlock:(void(^)(RequestModel *respondObject))success failure:(void(^)(RequestModel *respondObject))failure {
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/user/content") Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (success) {
            success(respondObject);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (failure) {
            failure(respondObject);
        }
    }];
}


///回收上传视频
- (void)uploadRecycleVideoByPath:(NSString *)videoUrl uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunVideoBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",@"client_publish/recovery/uploadProduct",[self getFileNameWithType:@".mp4"]];
    put.uploadingFileURL = [NSURL URLWithString:videoUrl];
    put.contentType = @"video/mp4";
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (uploadProgressBlock) {
            CGFloat videoPercent = (float)totalByteSent / totalBytesExpectedToSend;
            int tempValue = floor(videoPercent*100);
            NSLog(@"tempValue: - %d - videoPercent: - %f", tempValue, videoPercent);
            uploadProgressBlock(tempValue);
        }
    };
    self.putRequest = put;

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

///c2c上传视频
- (void)uploadC2CVideoByPath:(NSString *)videoUrl uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunVideoBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",@"client_publish/c2c/uploadProduct",[self getFileNameWithType:@".mp4"]];
    put.uploadingFileURL = [NSURL URLWithString:videoUrl];
    put.contentType = @"video/mp4";
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        if (uploadProgressBlock) {
            CGFloat videoPercent = (float)totalByteSent / totalBytesExpectedToSend;
            int tempValue = floor(videoPercent*100);
            NSLog(@"tempValue: - %d - videoPercent: - %f", tempValue, videoPercent);
            uploadProgressBlock(tempValue);
        }
    };
    self.putRequest = put;

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
///c2c上传音频
///上传单张图片
- (void)uploadAudioByPath:(NSString *)audioPath filePath: (NSString *)filePath finishBlock:(void(^)(BOOL isFinished, NSString* imgKey))finishBlock {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kJHAiyunVoiceBucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",filePath,[self getFileNameWithType:@".wav"]];
    put.uploadingFileURL = [NSURL fileURLWithPath:audioPath];
    put.contentType = @"audio/mp3";
    self.putRequest = put;
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            if (finishBlock) {
                finishBlock(YES, put.objectKey);
            }
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            if (finishBlock) {
                finishBlock(NO, put.objectKey);
            }
        }
        return nil;
    }];
}
/*
AVAssetExportPresetLowQuality        低质量 可以通过移动网络分享
AVAssetExportPresetMediumQuality     中等质量 可以通过WIFI网络分享
AVAssetExportPresetHighestQuality    高等质量
AVAssetExportPreset640x480
AVAssetExportPreset960x540
AVAssetExportPreset1280x720    720pHD
AVAssetExportPreset1920x1080   1080pHD
AVAssetExportPreset3840x2160
*/

#pragma mark ### MOV转码MP4
- (void)convertMovToMp4FromAVURLAsset:(AVURLAsset*)urlAsset
    andMovEncodeToMpegToolResultBlock:(void(^)(NSString*, NSError*))finishBlock {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlAsset.URL options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
  // 查询是否有匹配的预设
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        //  在Documents目录下创建一个名为FileData的文件夹
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Cache/VideoData"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
        if(!(isDirExist && isDir)) {
            BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            if(!bCreateDir){
                NSLog(@"创建文件夹失败！%@",path);
            }
            NSLog(@"创建文件夹成功，文件路径%@",path);
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyyMMddHHmmss"]; //每次启动后都保存一个新的文件中
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        NSString *resultPath = [path stringByAppendingFormat:@"/%@.mp4",dateStr];
        NSLog(@"resultFileName = %@",dateStr);

        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset
                                                                               presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown: {
                    NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                                         code:10001
                                                     userInfo:@{NSLocalizedDescriptionKey:@"AVAssetExportSessionStatusUnknown"}];
                    finishBlock(nil , error);
                }
                    break;
                case AVAssetExportSessionStatusWaiting: {
                    NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                                         code:10002
                                                     userInfo:@{NSLocalizedDescriptionKey:@"AVAssetExportSessionStatusWaiting"}];
                    finishBlock(nil , error);
                }
                    break;
                case AVAssetExportSessionStatusExporting: {
                    NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                                         code:10003
                                                     userInfo:@{NSLocalizedDescriptionKey:@"AVAssetExportSessionStatusExporting"}];
                    finishBlock(nil , error);
                }
                    break;
                case AVAssetExportSessionStatusCompleted: {
//                    NSData *mp4Data = [NSData dataWithContentsOfURL:exportSession.outputURL];
                    finishBlock(exportSession.outputURL.absoluteString, nil);
                }
                    break;
                case AVAssetExportSessionStatusFailed: {
                    NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                                         code:10005
                                                     userInfo:@{NSLocalizedDescriptionKey:@"AVAssetExportSessionStatusFailed"}];
                    finishBlock(nil , error);
                }
                    break;
                case AVAssetExportSessionStatusCancelled: {
                    NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                                         code:10006
                                                     userInfo:@{NSLocalizedDescriptionKey:@"AVAssetExportSessionStatusCancelled"}];
                    finishBlock(nil , error);
                }
                    break;
            }
        }];
    }
    else{
        NSError *error = [NSError errorWithDomain:@"ConvertMovToMp4ErrorDomain"
                                             code:10007
                                         userInfo:@{NSLocalizedDescriptionKey:@"AVAssetExportSessionStatusNoPreset"}];
        finishBlock(nil , error);
    }
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


- (NSMutableArray *)articleArray {
    if (!_articleArray) {
        _articleArray = [NSMutableArray array];
    }
    return _articleArray;
}

@end


@implementation JHArticleItemModel

- (id)copyWithZone:(NSZone *)zone {
    JHArticleItemModel *model = [[JHArticleItemModel allocWithZone:zone] init];
    model.uploadProgress = self.uploadProgress;
    model.articleId = self.articleId;
    model.uploadParameters = [self.uploadParameters copy];
    model.videoPath = self.videoPath;
    model.uploadMediaType = self.uploadMediaType;
    model.isOn = self.isOn;
    model.videoPathURLKey = self.videoPathURLKey;
    model.imageURLs = [self.imageURLs copy];
    model.uploadStatus = self.uploadStatus;
    return model;
}


- (id)mutableCopyWithZone:(NSZone *)zone {
    JHArticleItemModel *model = [[JHArticleItemModel allocWithZone:zone] init];
    model.uploadProgress = self.uploadProgress;
    model.articleId = self.articleId;
    model.uploadParameters = [self.uploadParameters copy];
    model.videoPath = self.videoPath;
    model.uploadMediaType = self.uploadMediaType;
    model.isOn = self.isOn;
    model.videoPathURLKey = self.videoPathURLKey;
    model.imageURLs = [self.imageURLs copy];
    model.uploadStatus = self.uploadStatus;
    return model;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:_uploadProgress forKey:@"uploadProgress"];
    [coder encodeInt:_articleId forKey:@"articleId"];
    [coder encodeObject:_uploadParameters forKey:@"uploadParameters"];
    [coder encodeObject:_videoPath forKey:@"videoPath"];
    [coder encodeInteger:_uploadMediaType forKey:@"uploadMediaType"];
    [coder encodeBool:_isOn forKey:@"isOn"];
    [coder encodeObject:_videoPathURLKey forKey:@"videoPathURLKey"];
    [coder encodeObject:_imageURLs forKey:@"imageURLs"];
    [coder encodeInteger:_uploadStatus forKey:@"uploadStatus"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _uploadProgress = [coder decodeIntForKey:@"uploadProgress"];
        _articleId = [coder decodeIntForKey:@"articleId"];
        _uploadParameters = [coder decodeObjectForKey:@"uploadParameters"];
        _videoPath = [coder decodeObjectForKey:@"videoPath"];
        _uploadMediaType = [coder decodeIntegerForKey:@"uploadMediaType"];
        _isOn = [coder decodeBoolForKey:@"isOn"];
        _videoPathURLKey = [coder decodeObjectForKey:@"videoPathURLKey"];
        _imageURLs = [coder decodeObjectForKey:@"imageURLs"];
        _uploadStatus = [coder decodeIntegerForKey:@"uploadStatus"];
    }
    return self;
}


- (NSMutableArray *)uploadImageData {
    if (!_uploadImageData) {
        _uploadImageData = [NSMutableArray array];
    }
    return _uploadImageData;
}

@end
