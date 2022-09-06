//
//  JHPictureBrowserCropViewController.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPictureBrowserCropViewController.h"
#import "MBProgressHUD.h"
#import "CommAlertView.h"
#import "TZPhotoPreviewCell.h"
#import "TZAssetModel.h"
#import "TZImageCropManager.h"
#import "TZImageManager.h"
#import "JHAssetModel.h"
#import "JHBusinessPublishGoodsController.h"

@interface JHPictureBrowserCropViewController ()
/// 预览图
@property (nonatomic, strong) TZPhotoPreviewView *previewView;
/// 底部工具条
@property (nonatomic, strong) UIView *toolbar;
/// 取消
@property (nonatomic, strong) UIButton *reMakeButton;
/// 确定
@property (nonatomic, strong) UIButton *useButton;

@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property(nonatomic, strong) JHAssetModel * model;
@property(nonatomic, assign) CGRect cropRect;
@end

@implementation JHPictureBrowserCropViewController


#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat cropViewWH = kScreenWidth -40;
    self.cropRect = CGRectMake((kScreenWidth - cropViewWH) / 2, (self.view.height - cropViewWH) / 2, cropViewWH, cropViewWH);
    [self setupUI];
}

- (void)creatUI{
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"相机-ViewController-%@ 释放", [self class]);
}

#pragma mark - Action
- (void)didClickRemakeWithAction : (UIButton *)sender {
    [self back];
}
- (void)didClickUseWithAction : (UIButton *)sender {
    [TZImageManager manager].shouldFixOrientation = YES;
    UIImage *cropedImage = [TZImageCropManager cropImageView:self.previewView.imageView toRect:self.cropRect zoomScale:self.previewView.scrollView.zoomScale containerView:self.view];
//    UIImageOrientation ori = cropedImage.imageOrientation ;
//    self.previewView.originImage = cropedImage;
//    return;
//    if (self.surebtnClickedBlock) {
//        self.surebtnClickedBlock(cropedImage);
//    }
//    [self back];
    self.model = [[JHAssetModel alloc] init];
    @weakify(self);
    [self.model saveImageWithImage:cropedImage completion:^(BOOL success, NSError * _Nullable error) {
        @strongify(self);
        if (success) {
            [self postPHAsset];
        }else{
            JHTOAST(@"保存图片失败");
        }
    }];
}

- (void)postPHAsset{
    if (self.model.asset) {
        [NSNotificationCenter.defaultCenter postNotificationName:@"NSNotifacation_JHPictureBrowserCropViewController_Asset" object:nil userInfo:@{@"Asset":self.model.asset}];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:JHBusinessPublishGoodsController.class]) {
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
        
    }
}


- (void)back {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:true];
    }else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - Private
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}

#pragma mark - setupUI
- (void)setupUI {
    [self setupImageUI];
    [self.view addSubview:self.toolbar];
    [self.toolbar addSubview:self.reMakeButton];
    [self.toolbar addSubview:self.useButton];
}
- (void)setupImageUI {
    [self.view addSubview:self.previewView];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    self.previewView.allowCrop = YES;
    self.previewView.cropRect = self.cropRect;
}

- (void)layoutViews {
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(72 + UI.bottomSafeAreaHeight);
    }];
    [self.reMakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 72));
    }];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.top.width.height.equalTo(self.reMakeButton);
    }];
    
}
#pragma mark - Lazy
- (void)setAssetModel:(PHAsset *)assetModel {
    
    self.previewView.model = [TZAssetModel modelWithAsset:assetModel type:TZAssetModelMediaTypePhoto];
    [self configCropView];
}
- (void)setOriginImage:(UIImage *)originImage{
//    originImage
    [TZImageManager manager].shouldFixOrientation = YES;
    _originImage = [[TZImageManager manager] fixOrientation:originImage];
    self.previewView.originImage = _originImage;
    [self configCropView];
}
- (TZPhotoPreviewView *)previewView {
    if (!_previewView) {
        _previewView = [[TZPhotoPreviewView alloc] initWithFrame:CGRectZero];
        _previewView.backgroundColor = UIColor.blackColor;
//        _previewView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _previewView;
}

- (UIView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIView alloc] initWithFrame:CGRectZero];
        _toolbar.backgroundColor = HEXCOLOR(0x131313);
    }
    return _toolbar;
}
- (UIButton *)getButtonWithTitle : (NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:18];
    return button;
}
- (UIButton *)reMakeButton {
    if (!_reMakeButton) {
        _reMakeButton = [self getButtonWithTitle:@"取消"];
        _reMakeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_reMakeButton addTarget:self action:@selector(didClickRemakeWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reMakeButton;
}
- (UIButton *)useButton {
    if (!_useButton) {
        _useButton = [self getButtonWithTitle:@"确定"];
        _useButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_useButton addTarget:self action:@selector(didClickUseWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}
- (void)configCropView {
        [_cropView removeFromSuperview];
        [_cropBgView removeFromSuperview];
        
        _cropBgView = [UIView new];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.frame = self.view.bounds;
        _cropBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_cropBgView];
    

        [TZImageCropManager overlayClippingWithView:_cropBgView cropRect:self.cropRect containerView:self.view needCircleCrop:NO];
        
        _cropView = [UIView new];
        _cropView.userInteractionEnabled = NO;
        _cropView.frame = self.cropRect;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
  
        [self.view addSubview:_cropView];

}

@end
