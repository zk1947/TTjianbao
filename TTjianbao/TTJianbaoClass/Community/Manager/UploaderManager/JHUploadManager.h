//
//  JHUploadManager.h
//  TTjianbao
//
//  Created by apple on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHUploadMediaType) {
    JHUploadMediaTypeVideo = 1,
    JHUploadMediaTypeImages,
};

@class JHArticleItemModel;
@class AVURLAsset;

typedef void(^UploadProgressBlock)(CGFloat progress);


NS_ASSUME_NONNULL_BEGIN

@interface JHUploadManager : NSObject

#pragma mark -
#pragma mark -------------- 阿里云图片路径相关 ----------------------

///社区发布图片路径
UIKIT_EXTERN NSString *const kJHAiyunPublishPath;
///君子签 商家签约 企业认证上传营业执照图片的文件路径
UIKIT_EXTERN NSString *const kJHAiyunCertificationPath;
///3.1.7新增 银联签约路径
UIKIT_EXTERN NSString *const kJHAiyunSignContractpath;
///直播间商品橱窗上传icon
UIKIT_EXTERN NSString *const kJHAiyunRoomSaleGoodsPath;
///直播间主播上传icon
UIKIT_EXTERN NSString *const kJHAiyunRoomAnchorPath;
///社区阿里云图片地址 --- TODO lihui 355新增路径
UIKIT_EXTERN NSString *const kJHAiyunCommunityPath;

#pragma mark ------------------  END  -----------------------------
#pragma mark -

///需要发布的文章参数数组
@property (nonatomic, strong) NSMutableArray <JHArticleItemModel *>*articleArray;
///被踢后是否需要取消上传
@property (nonatomic, assign) BOOL isNeedCancelUpload;


#pragma mark - Method

+ (instancetype)shareInstance;

- (void)cancelUplaod;

///上传单张图片
- (void)uploadSingleImage:(UIImage*)images filePath:(NSString *)filePath finishBlock:(void(^)(BOOL isFinished, NSString* imgKey))finishBlock;

///上传gif图
- (void)uploadGifImage:(NSData*)gifImageData filePath:(NSString *)filePath finishBlock:(void(^)(BOOL isFinished, NSString* imgKey))finishBlock;
///上传图片
- (void)uploadImage:(NSArray <UIImage*>*)images uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock;

- (void)uploadImage_third:(NSArray <UIImage*>*)images uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSArray<NSString*>* imgKeys))finishBlock;
///上传视频
- (void)uploadVideoByPath:(NSString *)videoPath uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock;

///暂时没用>>>>
- (void)postRequest:(NSDictionary *)parameters successBlock:(void(^)(RequestModel *respondObject))success failure:(void(^)(RequestModel *respondObject))failure;

///回收上传商品视频
- (void)uploadRecycleVideoByPath:(NSString *)videoUrl uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock;
///c2c 上传视频
- (void)uploadC2CVideoByPath:(NSString *)videoUrl uploadProgress:(UploadProgressBlock)uploadProgressBlock finishBlock:(void(^)(BOOL isFinished, NSString* videoKey))finishBlock;
/// 上传音频
- (void)uploadAudioByPath:(NSString *)audioPath filePath: (NSString *)filePath finishBlock:(void(^)(BOOL isFinished, NSString* imgKey))finishBlock;
@end

typedef NS_ENUM(NSUInteger, JHArticleUploadStatus) {
    JHArticleUploadStatusWaitUpload = 1,      ///等待合成
    JHArticleUploadStatusSuccess,          ///合成成功
    JHArticleUploadStatusUploading      ,   ///正在合成
    JHArticleUploadStatusInterrupt,       ///合成中断
};

typedef NS_ENUM(NSUInteger, JHArticleMediaType) {
    JHArticleMediaTypeImages = 1,   ///图片
    JHArticleMediaTypeVideo,        ///视频
};

@interface JHArticleItemModel : NSObject <NSCoding, NSCopying, NSMutableCopying>

///帖子上传进度
@property (nonatomic, assign) int uploadProgress;
//每个帖子对应的ID
@property (nonatomic, assign) int articleId;
///除视频/图片外的参数
@property (nonatomic, copy) NSDictionary *uploadParameters;
///视频路径
@property (nonatomic, copy) NSString *videoPath;
///媒体类型
@property (nonatomic, assign) JHArticleMediaType uploadMediaType;
///需要上传的图片数据
@property (nonatomic, strong) NSMutableArray <UIImage *>*uploadImageData;
///点赞按钮是否打开
@property (nonatomic, assign) BOOL isOn;
///已经上传到阿里云的视频的数据
@property (nonatomic, copy) NSString *videoPathURLKey;
///图片的地址数组
@property (nonatomic, copy) NSArray *imageURLs;
///合成的状态：正在合成 等待合成 合成中断
@property (nonatomic, assign) JHArticleUploadStatus uploadStatus;


@end


NS_ASSUME_NONNULL_END
