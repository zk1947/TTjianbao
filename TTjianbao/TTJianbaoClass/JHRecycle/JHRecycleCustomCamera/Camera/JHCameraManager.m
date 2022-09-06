//
//  JHCameraManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCameraManager.h"
#import "CommAlertView.h"

@interface JHCameraManager()<AVCaptureFileOutputRecordingDelegate>
/// session
@property (nonatomic, strong) AVCaptureSession *session;
/// 图片输出
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
/// 视频文件输出
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
/// 视频输入
@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;
/// 音频输入
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
/// 预览
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
/// 后置摄像机
@property (nonatomic, strong) AVCaptureDevice *backCamera;
/// 麦克风
@property (nonatomic, strong) AVCaptureDevice *audioDevice;
/// 视频临时存储路径
@property (nonatomic, strong) NSURL *movieURL;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@property (nonatomic, assign) UIDeviceOrientation orientation;
/// 对焦视图
@property (nonatomic, strong) UIImageView *focusView;
/// 手势视图-蒙层
@property (nonatomic, strong) UIView *getureView;
/// 是否可以拍照或者视频
@property (nonatomic, assign) BOOL canWork;
/// 是否可以拍照 - 禁用快速连续拍照
@property (nonatomic, assign) BOOL canTakePhone;

@end

@implementation JHCameraManager

#pragma mark - Life Cycle Functions
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCamera];
        [self addNotification];
    }
    return self;
}
/// 相机初始化
- (instancetype)initWithParentView:(UIView *)view 
{
    self = [super init];
    if (self) {
        [self setupCamera];
        [self addNotification];
        [self addPreviewIn:view];
    }
    return self;
}
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
#pragma mark - 拍照
/// 拍照
- (void)takePhoto {
    dispatch_async(self.sessionQueue, ^{
        if (![self checkCanStart]) return;
        
        if (self.imageOutput == nil) return;
        if (self.backCamera == nil) return;
        if (self.canWork == false) return;
        if (self.canTakePhone == false) return;
        self.canTakePhone = false;
        
        AVCaptureConnection *conntion = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
        if (conntion == nil || conntion.enabled == false || conntion.active == false) return;
       
        // 防抖
        AVCaptureVideoStabilizationMode stabilizationModel = AVCaptureVideoStabilizationModeAuto;
        if ([self.backCamera.activeFormat isVideoStabilizationModeSupported:stabilizationModel]) {
            [conntion setPreferredVideoStabilizationMode:stabilizationModel];
        }
        
        [self.imageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
            
            if (imageDataSampleBuffer == nil) return;
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            [self.videoPreviewLayer addAnimation:[self opacityForever_Animation:0.1] forKey:nil];
            
            [self setImageWithImageData:imageData];
            self.canTakePhone = true;
        }];
    });
}
#pragma mark - 录像
/// 开始录像
- (void)startRecordVideo {
    dispatch_async(self.sessionQueue, ^{
        if (![self checkCanStart]) return;
        if (self.canWork == false) return;
        
        AVCaptureConnection *videoConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if (videoConnection.supportsVideoStabilization) {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        if (videoConnection.supportsVideoOrientation) {
            videoConnection.videoOrientation = [self getVideoOrientation];
        }
        
        [self.movieFileOutput startRecordingToOutputFileURL:self.movieURL recordingDelegate:self];
    });
}
/// 停止录像
- (void)stopRecordVideo {
    dispatch_async(self.sessionQueue, ^{
        if (![self checkCanStart]) return;
        //        if (!self.movieFileOutput.isRecording) return;
        
        [self.movieFileOutput stopRecording];
    });
}
#pragma mark - 手电筒
/// 打开手电筒
- (void)openTorch {
    dispatch_async(self.sessionQueue, ^{
        [self setupTorchModel:AVCaptureTorchModeOn];
    });
}
/// 关闭手电筒
- (void)closeTorch {
    dispatch_async(self.sessionQueue, ^{
        [self setupTorchModel:AVCaptureTorchModeOff];
    });
}
#pragma mark - 启动数据流
/// 开始数据流
- (void)startCamera {
    dispatch_async(self.sessionQueue, ^{
        if (![self checkCameraAuthority]) return;
        if (self.session == nil) return;
        if (self.session.isRunning) return;
        [self.session startRunning];
    });
}
/// 停止抓取
- (void)stopCamera {
    dispatch_async(self.sessionQueue, ^{
        if (![self checkCameraAuthority]) return;
        if (self.session == nil) return;
        if (!self.session.isRunning) return;
        [self.session stopRunning];
    });
}
#pragma mark - Delegate
// 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"摄像机-录制输出 %@", error);
    if (error) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setVideoWithPath:outputFileURL];
    });
    
}
#pragma mark - 设置 图片 视频
- (void)setImageWithImageData : (NSData *)imageData {
    if (self.isAutoSave) {
        [self saveImageWithImageData:imageData];
    }else {
        [self setAssetModelWithImageData:imageData];
    }
}
- (void)setVideoWithPath : (NSURL *)path {
    if (self.isAutoSave) {
        [self saveVideoWithPath:path];
    }else {
        [self setAssetModelWithUrl:path];
    }
}

#pragma mark - 存储 图片 视频
- (void)saveImageWithImageData : (NSData *)imageData {
    if ([self checkPhotoLibraryAuthority] == false) return;
    @weakify(self)
    JHAssetModel *assetModel = [[JHAssetModel alloc] init];
    [assetModel saveImageWithImageData:imageData completion:^(BOOL success, NSError * _Nullable error) {
        @strongify(self)
        if (success == false) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.assetSubject sendNext:assetModel];
        });
    }];
}
- (void)saveVideoWithPath : (NSURL *)path {
    if ([self checkPhotoLibraryAuthority] == false) return;
    JHAssetModel *assetModel = [[JHAssetModel alloc] init];
    @weakify(self)
    [assetModel saveVideoWithURL:path completion:^(BOOL success, NSError * _Nullable error) {
        @strongify(self)
        if (success == false) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.assetSubject sendNext:assetModel];
        });
    }];
}
#pragma mark - 设置图片 model
- (void)setAssetModelWithImageData : (NSData *)imageData {
    JHAssetModel *assetModel = [[JHAssetModel alloc] initWithImageData:imageData];
    [self.assetSubject sendNext:assetModel];
}
- (void)setAssetModelWithUrl : (NSURL *)url {
    JHAssetModel *assetModel = [[JHAssetModel alloc] initWithVideoPath:url];
    [self.assetSubject sendNext:assetModel];
}

#pragma mark - 嵌入预览层
- (void)addPreviewIn : (UIView *)view {
    [view.superview layoutIfNeeded];
    self.getureView.frame = view.bounds;
    self.videoPreviewLayer.frame = view.bounds;
    
    [view.layer addSublayer:self.videoPreviewLayer];
    [view addSubview:self.getureView];
}
#pragma mark - 设置手电筒
- (void)setupTorchModel : (AVCaptureTorchMode )model {
    if ([self.backCamera hasTorch] == false) return;
    if ([self.backCamera isTorchModeSupported:model] == false) return;
    NSError *error;
    [self.backCamera lockForConfiguration:&error];
    self.backCamera.torchMode = model;
    [self.backCamera unlockForConfiguration];
}

#pragma mark - 设置
- (void)setupCamera {
    self.canTakePhone = true;
    self.isAutoSave = true;
    [self checkCameraAuthority];
    [self checkMicrophoneAuthority];
    [self checkPhotoLibraryAuthority];
    self.orientation = UIDeviceOrientationPortrait;
}
- (BOOL)checkCanStart {
    if (![self checkCameraAuthority]) return false;
    if (!self.session.isRunning) return false;
    return true;
}
#pragma mark- 检测相机权限,自动跳到设置里。
- (BOOL)checkCameraAuthority{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        @weakify(self)
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            @strongify(self)
            if (granted) {
                [self startCamera];
            }else {
                [self showAlertWithDesc:@"无相机权限请前往设置"];
            }
        }];
        return false;
    }
    return true;
}
- (BOOL)checkMicrophoneAuthority {
    AVAudioSessionRecordPermission authStatus = AVAudioSession.sharedInstance.recordPermission;
    if (authStatus == AVAudioSessionRecordPermissionDenied) {
        [AVAudioSession.sharedInstance requestRecordPermission:^(BOOL granted) {
            if (granted == false) {
                [self showAlertWithDesc:@"无麦克风权限请前往设置"];
            }
        }];
        return false;
    }
    return true;
}

// 相册权限
- (BOOL)checkPhotoLibraryAuthority {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusDenied) {
        @weakify(self)
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            @strongify(self)
            if (status != PHAuthorizationStatusAuthorized) {
                [self showAlertWithDesc:@"无相册权限请前往设置"];
            }
        }];
        return false;
    }
    return true;
}

- (void)showAlertWithDesc : (NSString *)desc {
    dispatch_async(dispatch_get_main_queue(), ^{
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:@"设置"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.handle = ^{
            NSURL *settingUrl = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
            if ([UIApplication.sharedApplication canOpenURL:settingUrl]) {
                [UIApplication.sharedApplication openURL:settingUrl];
            }
        };
        alert.cancleHandle = ^{ };
    });
}

- (AVCaptureVideoOrientation)getVideoOrientation {
    return AVCaptureVideoOrientationPortrait;
//    switch (self.orientation) {
//        case UIDeviceOrientationPortrait:
//            return AVCaptureVideoOrientationPortrait;
//        case UIDeviceOrientationLandscapeLeft:
//            return AVCaptureVideoOrientationLandscapeLeft;
//        case UIDeviceOrientationLandscapeRight:
//            return AVCaptureVideoOrientationLandscapeRight;
//        default:
//            return AVCaptureVideoOrientationPortrait;
//    }
}
- (void)addNotification {
    @weakify(self)
    [NSNotificationCenter.defaultCenter addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        self.orientation = [UIDevice currentDevice].orientation;
    }];
    [NSNotificationCenter.defaultCenter addObserverForName:AVCaptureSessionDidStartRunningNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        self.canWork = true;
    }];
}
#pragma mark - 对焦
- (void)focusGesture:(UIGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:sender.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.getureView.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    
    [self setFocusModel:AVCaptureFocusModeAutoFocus focusPoint:focusPoint];
   
    // 下面是手触碰屏幕后对焦的效果
    self.focusView.center = point;
    self.focusView.hidden = false;

    @weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self)
        self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            @strongify(self)
            self.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            @strongify(self)
            self.focusView.hidden = true;
            [self setFocusModel:AVCaptureFocusModeContinuousAutoFocus];
        }];
    }];
}
#pragma mark - 对焦模式
- (void)setFocusModel : (AVCaptureFocusMode)model focusPoint : (CGPoint)focusPoint {
    NSError *error;
    if ([self.backCamera lockForConfiguration:&error]) {
        if ([self.backCamera isFocusModeSupported:model]) {
            [self.backCamera setFocusPointOfInterest:focusPoint];
            [self.backCamera setFocusMode:model];
        }
        [self.backCamera unlockForConfiguration];
    }
}
- (void)setFocusModel : (AVCaptureFocusMode)model {
    NSError *error;
    if ([self.backCamera lockForConfiguration:&error]) {
        if ([self.backCamera isFocusModeSupported:model]) {
            [self.backCamera setFocusMode:model];
        }
        [self.backCamera unlockForConfiguration];
    }
}
#pragma mark - Lazy

- (void)setIsAutoOpenTorch:(BOOL)isAutoOpenTorch {
    _isAutoOpenTorch = isAutoOpenTorch;
    if (isAutoOpenTorch) {
        [self setupTorchModel:AVCaptureTorchModeAuto];
    }
}

- (AVCaptureSession *)session {
    if (!_session){
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetPhoto];
        // 添加后置摄像头输出
        if ([_session canAddInput:self.backCameraInput]) {
            [_session addInput:self.backCameraInput];
        }
        if ([_session canAddOutput:self.imageOutput]) {
            [_session addOutput:self.imageOutput];
        }
        if ([_session canAddInput:self.audioInput]) {
            [_session addInput:self.audioInput];
        }
        if ([_session canAddOutput:self.movieFileOutput]) {
            [_session addOutput:self.movieFileOutput];
        }
    }
    return _session;
}
- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    return _videoPreviewLayer;
}
- (AVCaptureStillImageOutput *)imageOutput {
    if (!_imageOutput) {
        _imageOutput = [[AVCaptureStillImageOutput alloc]init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [_imageOutput setOutputSettings:outputSettings];
    }
    return _imageOutput;
}
- (AVCaptureMovieFileOutput *)movieFileOutput {
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        //        if ([self.session canAddOutput:_movieFileOutput]) {
        //            [self.session addOutput:_movieFileOutput];
        //        }
    }
    return _movieFileOutput;
}
- (AVCaptureDeviceInput *)backCameraInput {
    if (!_backCameraInput) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.backCamera error:&error];
    }
    return _backCameraInput;
}
- (AVCaptureDeviceInput *)audioInput {
    if (!_audioInput) {
        NSError *error;
        _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.audioDevice error:&error];
    }
    return _audioInput;
}
- (AVCaptureDevice *)backCamera {
    if (!_backCamera) {
        AVCaptureDevice *device;
        device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera
                                                    mediaType:AVMediaTypeVideo
                                                     position:AVCaptureDevicePositionBack];
        if (device == nil) {
            device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                        mediaType:AVMediaTypeVideo
                                                         position:AVCaptureDevicePositionBack];
        }
        
        
        [device lockForConfiguration:nil];
        if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [device setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        [device unlockForConfiguration];
        
        _backCamera = device;
    }
    return _backCamera;
}
- (AVCaptureDevice *)audioDevice {
    if (!_audioDevice) {
        _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    }
    return _audioDevice;
}
- (NSURL *)movieURL {
    if (!_movieURL) {
        _movieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"movie.mov"]];
    }
    return _movieURL;
}

- (dispatch_queue_t)sessionQueue {
    if (!_sessionQueue) {
        _sessionQueue = dispatch_queue_create("sessionQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _sessionQueue;
}

- (RACSubject<JHAssetModel *> *)assetSubject {
    if (!_assetSubject) {
        _assetSubject = [RACSubject subject];
    }
    return _assetSubject;
}

- (RACSubject<NSString *> *)toastSubject {
    if (!_toastSubject) {
        _toastSubject = [RACSubject subject];
    }
    return _toastSubject;
}
- (RACSubject<NSString *> *)alertSubject {
    if (!_alertSubject) {
        _alertSubject = [RACSubject subject];
    }
    return _alertSubject;
}

- (UIView *)getureView {
    if (!_getureView) {
        _getureView = [[UIView alloc] initWithFrame:CGRectZero];
        _getureView.backgroundColor = UIColor.clearColor;
        [_getureView addSubview:self.focusView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
        
        [_getureView addGestureRecognizer:tap];
    }
    return _getureView;
}
- (UIImageView *)focusView {
    if (!_focusView) {
        _focusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_focusView jh_borderWithColor:HEXCOLOR(0xffd70f) borderWidth:1];
        _focusView.hidden = true;
    }
    return _focusView;
}
- (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = time;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
    
}
@end
