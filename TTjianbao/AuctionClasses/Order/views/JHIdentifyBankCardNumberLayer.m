//
//  JHIdentifyBankCardNumberLayer.m
//  TTjianbao
//
//  Created by 张坤 on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentifyBankCardNumberLayer.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "JHUploadManager.h"

@interface JHIdentifyBankCardNumberLayer() <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>


// 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
// AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
// 当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
// session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
// 图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, assign) BOOL canCa;
@property (nonatomic)UIImage *image;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic)UIButton *photoButton;
@end

@implementation JHIdentifyBankCardNumberLayer

-(instancetype)init {
    self = [super init];
    if (self) {
        _canCa = [self canUserCamear];
        if (_canCa) {
            [self customCamera];
            [self customUI];
            
        }else{
            return self;
        }
    }
    return self;
}

- (void)show {
    [JHKeyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0.f);
        }];
        [UIView animateWithDuration:0.25f animations:^{
            [self layoutIfNeeded];
        }];
    });
}

- (void)dismiss {
    [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_mainView.height);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancleMethod {
    [self dismiss];
}

- (void)customUI {
    
    UIButton *cancleButton = [UIButton jh_buttonWithImage:[UIImage imageNamed:@"bg_navi_icon_back_white"] target:self action:@selector(cancleMethod) addToSuperView:_mainView];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.f);
        make.left.mas_equalTo(15.f);
    }];
    
    self.cardView = [UIView jh_viewWithColor:RGBA(0, 0, 0, 0) addToSuperview:self.mainView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(338, 214));
        make.top.mas_equalTo(137.f);
        make.centerX.mas_equalTo(self.mainView);
    }];
    
    [self addLRTBImage];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.photoButton.backgroundColor = UIColor.redColor;
    [self.photoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    [self.photoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    [self.photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.photoButton];
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mainView);
        make.bottom.mas_equalTo(-(60+UI.bottomSafeAreaHeight));
    }];
        
    [self layoutIfNeeded];
}

-(void)addLRTBImage {
    UIImageView *tl = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_add_bank_tl"] addToSuperview:self.cardView];
    [tl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(-2.5);
    }];
    
    UIImageView *tr = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_add_bank_tr"] addToSuperview:self.cardView];
    [tr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-2.5);
        make.right.mas_equalTo(2.5);
    }];
    
    UIImageView *bl = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_add_bank_bl"] addToSuperview:self.cardView];
    [bl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-2.5);
        make.bottom.mas_equalTo(2.5);
    }];
    
    UIImageView *br = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_add_bank_br"] addToSuperview:self.cardView];
    [br mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-2.5);
    }];
}

-(void)customCamera {
    self.backgroundColor = RGBA(0, 0, 0, 0.3);
    self.frame = JHKeyWindow.frame;
    UIButton *button = [UIButton jh_buttonWithTarget:self action:@selector(dismiss) addToSuperView:self];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _mainView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat h = (650.f+UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(h);
        make.bottom.mas_equalTo(h);
    }];
    
    [self layoutIfNeeded];
    [_mainView jh_cornerRadius:8.f rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight bounds:_mainView.bounds];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.mainView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.mainView.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    
}

#pragma mark - 截取照片
- (void)shutterCamera {
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self.session stopRunning];

        [self getBankCardNumber:self.image];
    }];
}

-(void)getBankCardNumber:(UIImage *)image {
    
    [SVProgressHUD show];
    NSString *const aliUploadPath = @"client_publish/bankCard";
    @weakify(self)
    [[JHUploadManager shareInstance] uploadSingleImage:image filePath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
        if (isFinished) {
            NSDictionary *parameters = @{ @"image":imgKey};
            
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/bank/ocr") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
               
                @strongify(self)
                NSDictionary *dic = respondObject.data;
                if (respondObject.code == 1000) {
                    if ([[dic valueForKey:@"status"] intValue] == 1) {
                        if (self.identifyBankCardNumberLayerBlock) {
                            self.identifyBankCardNumberLayerBlock(dic);
                        }
                    }else {
                        [JHKeyWindow makeToast:@"识别错误" duration:1.0 position:CSToastPositionCenter];
                    }
                }
                [self dismiss];
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                [self dismiss];
                [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            }];
        }else {
            [SVProgressHUD dismiss];
            [self dismiss];
            [JHKeyWindow makeToast:@"识别错误" duration:1.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 检查相机权限

- (BOOL)canUserCamear {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                }else {
                    [JHKeyWindow makeToast:@"您暂未授予相机权限，请在系统设置中开启" duration:1.0 position:CSToastPositionCenter];
                }
            });
        }];
        return NO;
    }
    else {
        return YES;
    }
    return YES;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0 && alertView.tag == 100) {
//
//        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//
//        if([[UIApplication sharedApplication] canOpenURL:url]) {
//
//            [[UIApplication sharedApplication] openURL:url];
//
//        }
//    }
//}

@end
