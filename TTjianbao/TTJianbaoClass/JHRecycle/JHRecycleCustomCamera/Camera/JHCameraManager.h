//
//  JHCameraManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "JHAssetModel.h"
#import "PHPhotoLibrary+Save.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^ _Nullable JHPhotoLibraryAuthHandle)(BOOL success, PHAuthorizationStatus status);
typedef void(^ _Nullable JHCameraAuthHandle)(BOOL success, AVAuthorizationStatus status);

@interface JHCameraManager : NSObject

/// 资源 -图片、视频
@property (nonatomic, strong) RACSubject<JHAssetModel *> *assetSubject;

/// toast
@property (nonatomic, strong) RACSubject<NSString *> *toastSubject;
/// alert
@property (nonatomic, strong) RACSubject<NSString *> *alertSubject;
/// 是否自动开启手电筒
@property (nonatomic, assign) BOOL isAutoOpenTorch;

/// 是否自动存储照片到相册
@property (nonatomic, assign) BOOL isAutoSave;

/// 相机初始化
- (instancetype)initWithParentView:(UIView *)view;
/// 拍照
- (void)takePhoto;
/// 开始录像
- (void)startRecordVideo;
/// 停止录像
- (void)stopRecordVideo;
/// 打开手电筒
- (void)openTorch;
/// 关闭手电筒
- (void)closeTorch;

/// 添加预览视图
- (void)addPreviewIn : (UIView *)view;
/// 启动相机
- (void)startCamera;
/// 停用相机
- (void)stopCamera;
/// 相册权限
- (BOOL)checkPhotoLibraryAuthority;
@end

NS_ASSUME_NONNULL_END
