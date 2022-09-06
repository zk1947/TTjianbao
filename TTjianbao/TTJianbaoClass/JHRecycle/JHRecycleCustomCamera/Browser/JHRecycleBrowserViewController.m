//
//  JHRecycleImageBrowserViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/4/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleBrowserViewController.h"
#import "MBProgressHUD.h"
#import "JHPlayerViewController.h"
#import "CommAlertView.h"
#import "JHPictureBrowserCropViewController.h"

@interface JHRecycleBrowserViewController ()
/// 预览图
@property (nonatomic, strong) UIImageView *imagePreview;
/// 底部工具条
@property (nonatomic, strong) UIView *toolbar;
/// 重拍
@property (nonatomic, strong) UIButton *reMakeButton;
/// 使用照片
@property (nonatomic, strong) UIButton *useButton;

/// 视频预览图
@property (nonatomic, strong) UIView *videoPreview;
/// 播放按钮
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) JHPlayerViewController *playerController;
@end

@implementation JHRecycleBrowserViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
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
    if (self.allowCrop) {
        JHPictureBrowserCropViewController *crop = [[JHPictureBrowserCropViewController alloc] init];
        [JHRootController.navigationController pushViewController:crop animated:YES];
        crop.originImage = self.assetModel.originalImage;
        UIImageOrientation ori = crop.originImage.imageOrientation ;
        [self back];
        return;
    }
    [self showProgressHUD];
    if ([self checkPhotoLibraryAuthority] == false) {
        [self hideProgressHUD];
        return;
    }
    @weakify(self)
    if (self.assetModel.assetType == JHAssetTypeImage) {
        [self.assetModel saveImageWithCompletion:^(BOOL success, NSError * _Nullable error) {
            @strongify(self)
            [self hideProgressHUD];
            [self.assetSubject sendNext:self.assetModel];
            [self back];
        }];
    }else {
        [self.assetModel saveVideoWithCompletion:^(BOOL success, NSError * _Nullable error) {
            @strongify(self)
            [self hideProgressHUD];
            [self.assetSubject sendNext:self.assetModel];
            [self back];
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
- (void)didClickPlay : (UIButton *)sender {

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
#pragma mark - Bind
- (void)setupData {
    if (self.assetModel == nil) return;
    
    if (self.assetModel.assetType == JHAssetTypeVideo) {
        [self setupVideoUI];
        [self setupPlay];
    }else {
        [self setupImageUI];
        self.imagePreview.image = self.assetModel.originalImage;
    }
}
- (void)setupPlay {
    [self.view layoutIfNeeded];
    [self.videoPreview addSubview:self.playerController.view];
    self.playerController.view.frame = self.videoPreview.bounds;
    self.playerController.urlString = [NSString stringWithFormat:@"%@", self.assetModel.videoPath];
    [self.playerController setSubviewsFrame];
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
    [self.view addSubview:self.toolbar];
    [self.toolbar addSubview:self.reMakeButton];
    [self.toolbar addSubview:self.useButton];
}
- (void)setupImageUI {
    [self.view addSubview:self.imagePreview];
    [self.imagePreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.toolbar.mas_top).offset(0);
    }];
}
- (void)setupVideoUI {
    [self.view addSubview:self.videoPreview];
    [self.videoPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.toolbar.mas_top).offset(0);
    }];
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
- (void)setAssetModel:(JHAssetModel *)assetModel {
    _assetModel = assetModel;
    [self setupData];
}
- (RACSubject<JHAssetModel *> *)assetSubject {
    if (!_assetSubject) {
        _assetSubject = [RACSubject subject];
    }
    return _assetSubject;
}
- (UIImageView *)imagePreview {
    if (!_imagePreview) {
        _imagePreview = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imagePreview.backgroundColor = UIColor.blackColor;
        _imagePreview.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imagePreview;
}
- (UIView *)videoPreview {
    if (!_videoPreview) {
        _videoPreview = [[UIView alloc] initWithFrame:CGRectZero];
        _videoPreview.backgroundColor = UIColor.blackColor;
    }
    return _videoPreview;
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
        _reMakeButton = [self getButtonWithTitle:@"重拍"];
        _reMakeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_reMakeButton addTarget:self action:@selector(didClickRemakeWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reMakeButton;
}
- (UIButton *)useButton {
    if (!_useButton) {
        _useButton = [self getButtonWithTitle:@"使用照片"];
        _useButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_useButton addTarget:self action:@selector(didClickUseWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.jh_imageName(@"newStore_play_icon")
        .jh_action(self, @selector(didClickPlay:));
    }
    return _playButton;
}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.looping = true;
        _playerController.alwaysPlay = true;
//        _playerController.fullScreenView = self.view;
        [self addChildViewController:_playerController];
    }
    return _playerController;
}
@end
