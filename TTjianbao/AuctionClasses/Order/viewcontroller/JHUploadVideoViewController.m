//
//  JHUploadVideoViewController.m
//  TTjianbao
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHUploadVideoViewController.h"
#import "TZImagePickerController.h"
#import "JHWebViewController.h"
#import "JHAiyunOSSManager.h"
#import "BaseNavViewController.h"
#import "MBProgressHUD.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JHGrowingIO.h"

#define kJHAiyunAppraiseVideoPath @"client_publish/order/report"

@interface JHUploadImageBtn:UIButton

@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UILabel *titleLab;



@end

@implementation JHUploadImageBtn

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLab.text = @"";
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = HEXCOLOR(0xdedede).CGColor;
        self.layer.borderWidth = 1;
        [self addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@(25));
        }];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(40);
        }];
    }
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont fontWithName:kFontMedium size:15];
        _titleLab.textColor = HEXCOLOR(0x444444);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
@end


@interface JHUploadVideoViewController ()<TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)JHUploadImageBtn *coverBtn;
@property(nonatomic, strong)JHUploadImageBtn *videoBtn;
@property (nonatomic, strong)UILabel *orderCodeLabel;

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *videoBucketKey;
@property (nonatomic, strong) PHAsset *videoAsset;
@property (nonatomic, strong) PHAsset *pictureAsset;

@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSString *coverBucketKey;

@property (nonatomic, assign) NSInteger videoSize;
@property (nonatomic, assign) NSInteger videoDuring;
@property (nonatomic, strong) UIImage *videoImage;

@property (nonatomic, assign)BOOL isUploading;

@end
@implementation JHUploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"上传视频"];
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"上传视频";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [endBtn setTitle:@"结束鉴定" forState:UIControlStateNormal];
    [endBtn setTitleColor:HEXCOLOR(0x444444) forState:UIControlStateNormal];
    endBtn.backgroundColor = kGlobalThemeColor;
    [endBtn addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endBtn];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45-UI.bottomSafeAreaHeight);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(1);
    }];
    
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.scrollView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
    }];
    
    
    [self.scrollView addSubview:self.orderCodeLabel];
    
    
    UILabel *title1 = [UILabel new];
    title1.font = [UIFont fontWithName:kFontMedium size:16];
    title1.textColor = HEXCOLOR(0x333333);
    title1.text = @"添加宝贝图片";
    [self.scrollView addSubview:title1];
    
    [self.scrollView addSubview:self.coverBtn];
    
    UILabel *title2 = [UILabel new];
    title2.font = [UIFont fontWithName:kFontMedium size:16];
    title2.textColor = HEXCOLOR(0x333333);
    title2.text = @"上传鉴定视频";
    [self.scrollView addSubview:title2];
    
    [self.scrollView addSubview:self.videoBtn];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportBtn setTitle:@"完善/修改鉴定报告" forState:UIControlStateNormal];
    [reportBtn setTitleColor:HEXCOLOR(0x444444) forState:UIControlStateNormal];
    reportBtn.backgroundColor = HEXCOLOR(0xF9F9F9);
    [reportBtn addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:reportBtn];
    
    
    [self.orderCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.scrollView);
        make.height.equalTo(@40);
        make.width.equalTo(@(ScreenW));
        
        
    }];
    
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scrollView).offset(15);
        make.top.equalTo(self.orderCodeLabel.mas_bottom).offset(15);
        make.trailing.equalTo(self.scrollView).offset(-15);
        
    }];
    
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(title1);
        make.top.equalTo(title1.mas_bottom).offset(8);
        make.width.equalTo(self.coverBtn.mas_height).multipliedBy(245/175.);
        
    }];
    
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.coverBtn);
        make.top.equalTo(self.coverBtn.mas_bottom).offset(15);
        
    }];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(title1);
        make.top.equalTo(title2.mas_bottom).offset(8);
        make.width.height.equalTo(self.coverBtn);
    }];
    
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(title1);
        make.height.equalTo(@40);
        make.top.equalTo(self.videoBtn.mas_bottom).offset(15);
        make.bottom.equalTo(self.scrollView).offset(-20);
    }];
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}
- (UILabel *)orderCodeLabel {
    if (!_orderCodeLabel) {
        _orderCodeLabel = [UILabel new];
        _orderCodeLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _orderCodeLabel.textColor = HEXCOLOR(0x444444);
        _orderCodeLabel.textAlignment = NSTextAlignmentCenter;
        _orderCodeLabel.backgroundColor = HEXCOLOR(0xF9F9F9);
        _orderCodeLabel.text = [@"订单：" stringByAppendingString:OBJ_TO_STRING(self.orderModel.orderCode)];
    }
    return _orderCodeLabel;
}

- (JHUploadImageBtn *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [[JHUploadImageBtn alloc] init];
        [_coverBtn setImage:[UIImage imageNamed:@"icon_upload_image"] forState:UIControlStateNormal];
        [_coverBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];

        _coverBtn.contentMode = UIViewContentModeCenter;
        _coverBtn.tipLabel.hidden = YES;
        _coverBtn.titleLab.text = @"添加宝贝图片";
        [_coverBtn addTarget:self action:@selector(pictureAction) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.tipLabel.text = @"更换图片";
        _coverBtn.tipLabel.backgroundColor = HEXCOLORA(0x000000, 0.8);
        
    }
    
    return _coverBtn;
}

- (JHUploadImageBtn *)videoBtn {
    if (!_videoBtn) {
        _videoBtn = [[JHUploadImageBtn alloc] init];
        [_videoBtn setImage:[UIImage imageNamed:@"icon_upload_video"] forState:UIControlStateNormal];
        _videoBtn.contentMode = UIViewContentModeCenter;
        _videoBtn.tipLabel.hidden = YES;
        _videoBtn.titleLab.text = @"上传鉴定视频";
        
        [_videoBtn addTarget:self action:@selector(videoAction) forControlEvents:UIControlEventTouchUpInside];
        _videoBtn.tipLabel.text = @"上传失败";
        _videoBtn.tipLabel.backgroundColor = HEXCOLORA(0xff0000, 0.8);
        [_videoBtn setImage:[UIImage imageNamed:@"icon_video_preview"] forState:UIControlStateSelected];
        

    }
    
    return _videoBtn;
}


- (void)pictureAction {
    [self showCamaraWithType:0];
    
}

- (void)videoAction {
    if (self.videoPath) {
        [self showSheetType:1 showPreview:YES];
    }else {
        [self showSheetType:1 showPreview:NO];

    }
}

- (void)reportAction {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = [H5_BASE_STRING(@"/jianhuo/app/authenticate.html?") stringByAppendingFormat:@"orderId=%@",self.orderModel.orderId];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)showCamaraWithType:(NSInteger)type {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.tag = 0;

        if (type == 1) {
            picker.mediaTypes = @[(NSString *)kUTTypeMovie];
            picker.view.tag = 1;
            picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        }
        picker.navigationController.navigationBar.translucent = NO;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"模拟器");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.view.tag == 0) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.coverImage = image;
        [self.coverBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self uploadMediaWithType:0];
        self.coverBtn.titleLab.text = @"";
        [_coverBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

        
    }else if (picker.view.tag == 1) {
       
//        NSString *path = info[UIImagePickerControllerMediaURL];
//        self.videoPath = path;
//        [self firstFrameWithVideoURL:[NSURL fileURLWithPath:path] size:CGSizeZero];
        [SVProgressHUD show];
      
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
           JH_WEAK(self)
           [[TZImageManager manager] saveVideoWithUrl:videoUrl completion:^(PHAsset *asset, NSError *error) {
               JH_STRONG(self)
               if (!error) {
                   [self exportVideoWithAsset:asset picker:picker cover:nil];
               }
               [SVProgressHUD dismiss];
           }];
        }
    }

}

- (void)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{

        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 1000);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        self.videoImage = videoImage;
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.videoBtn setBackgroundImage:videoImage forState:UIControlStateNormal];
              });
           });


    
    
}


- (void)showImagePickerViewWithType:(NSInteger)type {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    if (type == 1)
    {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = NO;
        imagePickerVc.allowTakeVideo = YES;
        imagePickerVc.allowTakePicture = NO;
    }
    else if (type == 0)
    {
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowTakePicture = YES;
        imagePickerVc.allowTakeVideo = NO;
    }
    else
    {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowTakePicture = YES;
        imagePickerVc.allowTakeVideo = YES;
    }
    //视频时长不超过11分钟
        imagePickerVc.videoMaximumDuration = 11 * 60;
    imagePickerVc.autoDismiss = NO;
    MJWeakSelf
    __weak TZImagePickerController* weakImagePickerVc = imagePickerVc;
    imagePickerVc.imagePickerControllerDidCancelHandle = ^{
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    };
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (assets.count) {
            weakSelf.pictureAsset = assets.firstObject;
        }
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
        [weakSelf exportVideoWithAsset:asset picker:weakImagePickerVc cover:coverImage];

    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)exportVideoWithAsset:(PHAsset *)asset picker:(UINavigationController *)weakImagePickerVc cover:(UIImage *)coverImage{
    [MBProgressHUD showHUDAddedTo:self.videoBtn animated:NO];
//    [SVProgressHUD showWithStatus:@"正在导出视频"];
    JH_WEAK(self)
    [[TZImageManager manager]getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
                NSLog(@"%@",outputPath);
        JH_STRONG(self)
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];

//                [SVProgressHUD dismiss];
                unsigned long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:outputPath error:nil].fileSize;
    //            if (fileSize > 500 * 1024 * 1024) {
    //                [weakSelf.view makeToast:@"视频大小不得超过500M" duration:1 position:CSToastPositionCenter];
    //            } else
                {
                    self.videoAsset = asset;
                    self.videoPath = outputPath;
                    
                    AVURLAsset *avUrl = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:outputPath]];
                    self.videoDuring = [avUrl duration].value/[avUrl duration].timescale * 1000;
                    self.videoSize = fileSize;
                    [self.videoBtn setImage:[UIImage imageNamed:@"icon_video_preview"] forState:UIControlStateNormal];
                    self.videoBtn.titleLab.text = @"";
                    [self uploadMediaWithType:1];
                    if (coverImage) {
                        [self.videoBtn setBackgroundImage:coverImage forState:UIControlStateNormal];

                    }else {

                        [self firstFrameWithVideoURL:[NSURL fileURLWithPath:outputPath] size:CGSizeZero];
                        
                    }


                }
            } failure:^(NSString *errorMessage, NSError *error) {
//                [SVProgressHUD dismiss];
                [MBProgressHUD hideHUDForView:self.videoBtn animated:NO];

                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                [SVProgressHUD showErrorWithStatus:@"视频导出错误，稍后重试"];
            }];
}

- (void)showSheetType:(NSInteger)type showPreview:(BOOL)show{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (show) {
        [alert addAction:[UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (type == 1)
            {
                TZVideoPlayerController *videoPlayerVc = [[TZVideoPlayerController alloc] init];
                videoPlayerVc.model = [TZAssetModel modelWithAsset:self.videoAsset type:TZAssetModelMediaTypeVideo];
                [self.navigationController pushViewController:videoPlayerVc animated:YES];
            } else {
//                TZImagePickerController *perviewNav = [[TZImagePickerController alloc]initWithSelectedAssets:imgAsset selectedPhotos:imgAsset  index:indexPath.row];
//                [self presentViewController:perviewNav animated:YES completion:nil];
            }
        }]];
    }
    if (type == 1) {
        [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
//            [self showCamaraWithType:type];

        }]];

        [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickerViewWithType:type];

        }]];
    }
    
    
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)uploadMediaWithType:(NSInteger)type{
    // 视频
    if (type == 1 && self.videoPath) {
//        [MBProgressHUD showHUDAddedTo:self.videoBtn animated:NO];
        self.isUploading = YES;
        [[JHAiyunOSSManager shareInstance] uploadVideoByPath:self.videoPath returnPath:kJHAiyunAppraiseVideoPath finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.videoBtn animated:NO];

                if (isFinished) {
                              self.videoBtn.tipLabel.hidden = YES;
                              self.videoBucketKey = videoKey; 


                          } else {
                              [SVProgressHUD showErrorWithStatus:@"视频上传失败，稍后再试！"];
                              self.videoBtn.tipLabel.hidden = NO;
                          }
                          self.isUploading = NO;

            });
          
        }];
        
    }else if (type == 0 && self.coverImage) {
        //图片
        self.isUploading = YES;
        [MBProgressHUD showHUDAddedTo:self.coverBtn animated:NO];
        [[JHAiyunOSSManager shareInstance] uopladImage:@[self.coverImage] returnPath:kJHAiyunAppraiseVideoPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
            
            dispatch_async(dispatch_get_main_queue(),  ^{
                [MBProgressHUD hideHUDForView:self.coverBtn animated:NO];

                          if (isFinished && imgKeys.count) {
                              self.coverBucketKey = imgKeys.firstObject;
                              NSLog(@"%@",self.coverBucketKey);
                              self.coverBtn.tipLabel.hidden = NO;
                              self.coverBtn.tipLabel.text = @"更换图片";
                              self.coverBtn.tipLabel.backgroundColor = HEXCOLORA(0x000000, 0.8);


                          } else {
                              [SVProgressHUD showErrorWithStatus:@"上传失败"];
                              self.coverBtn.tipLabel.text = @"上传失败";
                              self.coverBtn.tipLabel.backgroundColor = HEXCOLORA(0xff0000, 0.8);
                              self.coverBtn.tipLabel.hidden = NO;

                          }
                self.isUploading = NO;

            });
            
          
        }];
    } else {
        [self.view makeToast:@"请选择图片或视频" duration:1 position:CSToastPositionCenter];
        self.coverBtn.tipLabel.hidden = NO;
        self.coverBtn.tipLabel.text = @"上传失败";
        self.coverBtn.tipLabel.backgroundColor = HEXCOLORA(0xff0000, 0.8);
        [MBProgressHUD hideHUDForView:self.coverBtn animated:NO];


    }
}

- (void)endAction {
    if (!self.coverBucketKey) {
        [self.view makeToast:@"请选择图片" duration:1. position:CSToastPositionCenter];
        return;
    }
    
    if (!self.videoBucketKey) {
        [self.view makeToast:@"请上传视频" duration:1. position:CSToastPositionCenter];
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"coverImg"] = self.coverBucketKey;
    dic[@"videoUrl"] = self.videoBucketKey;
    dic[@"orderId"] = self.orderModel.orderId;
    dic[@"orderCode"] = self.orderModel.orderCode;
    dic[@"fileSize"] = @(self.videoSize);
    dic[@"duration"] = @(self.videoDuring);
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/identification") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        if (self.finishBlock) {
            self.finishBlock(nil);
        }
        
        [self showSuccessAlert];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}


- (void)showSuccessAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交成功" message:@"是否预览鉴定报告" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:NO];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"评估报告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:NO];
        
        JHWebViewController *webView = [[JHWebViewController alloc] init];
        webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), self.orderModel.orderId];
        [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = NO;
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = YES;
    }
    
}


- (void)backActionButton:(UIButton *)sender {
    
    if (self.isUploading) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出将无法保存所编辑内容" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
      [alert addAction:[UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          [self.navigationController popViewControllerAnimated:YES];
      }]];
      [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
        // 无权限 做一个友好的提示
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        
        NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
             
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

             }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoLibiry];
                });
            }
        }];
    } else {
        [self takePhotoLibiry];
    }
}

- (void)takePhotoLibiry {
    [[TZImageManager manager] requestAuthorizationWithCompletion:^{
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
           if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined)) {
                       
                       NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
                       // 无权限 做一个友好的提示
                       NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
                       if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
                       
                       NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Allow %@ to access your album in \"Settings -> Privacy -> Photos\""],appName];

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:message preferredStyle:UIAlertControllerStyleAlert];
                      [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
                           
                      [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                           }]];
                      [self presentViewController:alert animated:YES completion:nil];

           }else {
               [self showCamaraWithType:1];
           }
    }];
   
}


@end
