//
//  JHRecycleCameraBaseViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleNomalCameraViewController.h"
#import "JHPhotoExampleViewController.h"



@interface JHRecycleNomalCameraViewController ()

/// 视频预览视图
@property (nonatomic, strong) UIView *preview;
/// 功能区
@property (nonatomic, strong) UIStackView *stackView;
/// 相册
@property (nonatomic, strong) UIButton *albumButton;
/// 手电筒
@property (nonatomic, strong) UIButton *torchButton;

/// 拍照功能区
@property (nonatomic, strong) UIView *toolbarView;



@end

@implementation JHRecycleNomalCameraViewController

#pragma mark - Life Cycle Functions
- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowTakePhone = true;
        self.allowRecordVideo = true;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindCamera];
//    [self.cameraManager startCamera];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cameraManager startCamera];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"相机-ViewController-%@ 释放", [self class]);
}

#pragma mark - Action
- (void)didClickTakePhone {
    [self.cameraManager takePhoto];
}
- (void)didClickRemakePhone {
    
}
- (void)didClickStartRecord {
    [self.cameraManager startRecordVideo];
}
- (void)didClickStopRecord {
    [self.cameraManager stopRecordVideo];
}
- (void)didClickAlbum {
    
}

- (void)didClickTorchWithAction : (UIButton *) sender {
    sender.selected = !sender.selected;
    if (sender.isSelected == true) {
        [self.cameraManager openTorch];
    }else {
        [self.cameraManager closeTorch];
    }
}
- (void)didClickExamWithAction : (UIButton *)sender {
    JHPhotoExampleViewController *vc = [[JHPhotoExampleViewController alloc] init];
    if (self.fromType == TemplateCameraFromTypeC2C) {
        vc.singleModelArr = self.singleModelArr;
        vc.useLocalData = YES;
    }
    vc.categoryId = self.categoryId;
    vc.showType = 1;
    [self presentViewController:vc animated:true completion:nil];
}
- (void)didClickExamWithAction2 : (UIButton *)sender {
    JHPhotoExampleViewController *vc = [[JHPhotoExampleViewController alloc] init];
    vc.categoryId = self.categoryId;
    vc.showType = 2;
    [self presentViewController:vc animated:true completion:nil];
}
- (void)handleAssetModel : (JHAssetModel *)assetModel {
    
}
#pragma mark - Bind
- (void)bindCamera {
    @weakify(self)
    [self.cameraManager.assetSubject subscribeNext:^(JHAssetModel * _Nullable x) {
        @strongify(self)
        if(x == nil) return;
        [self handleAssetModel:x];
    }];
}
#pragma mark - Private


#pragma mark - setupUI
- (void)setupUI {
    [self.view addSubview:self.preview];
    [self.view addSubview:self.customView];
    [self.view addSubview:self.toolbarView];
    [self.view addSubview:self.examView];
    [self.toolbarView addSubview:self.stackView];
}
- (void)layoutViews {
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.customView.mas_top).offset(0);
    }];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolbarView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    [self.toolbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.height.mas_equalTo(128);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolbarView).offset(0);
        make.centerX.equalTo(self.toolbarView.mas_centerX);
        make.height.mas_equalTo(85);
    }];
    [self.takeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(85);
    }];
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(85);
    }];
    [self.torchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(85);
    }];
    [self.examView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.bottom.mas_equalTo(self.customView.mas_top).offset(-12);
//        make.size.mas_equalTo(CGSizeMake(54, 150));
        make.width.mas_equalTo(54);
    }];
    [self.examButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    [self.examButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    [self.examLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 14));
    }];
    [self.examLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 14));
    }];
}
#pragma mark - Lazy
- (void)setAllowTakePhone:(BOOL)allowTakePhone {
    _allowTakePhone = allowTakePhone;
    self.takeView.allowTakePhone = allowTakePhone;
}
- (void)setAllowRecordVideo:(BOOL)allowRecordVideo {
    _allowRecordVideo = allowRecordVideo;
    self.takeView.allowRecordVideo = allowRecordVideo;
}
- (void)setExamImageUrl:(NSString *)examImageUrl {
    _examImageUrl = examImageUrl;
    [self.examButton jh_setImageWithUrl:examImageUrl];
    [self.examButton2 jh_setImageWithUrl:examImageUrl];
}
- (JHCameraManager *)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[JHCameraManager alloc] initWithParentView:self.preview];
    }
    return _cameraManager;
}
- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:CGRectZero];
        _preview.backgroundColor = UIColor.blackColor;
    }
    return _preview;
}
- (UIView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [[UIView alloc] initWithFrame:CGRectZero];
        _toolbarView.backgroundColor = UIColor.whiteColor;
    }
    return _toolbarView;
}
- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] initWithFrame:CGRectZero];
        _customView.backgroundColor = UIColor.whiteColor;
    }
    return _customView;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.albumButton, self.takeView, self.torchButton]];
        _stackView.spacing = (ScreenW - 85 * 3) / 4 - 1;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        
    }
    return _stackView;
}
- (UIButton *)albumButton {
    if (!_albumButton) {
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setImage:[UIImage imageNamed:@"recycle_order_album_icon"] forState:UIControlStateNormal];
        [_albumButton addTarget:self action:@selector(didClickAlbum) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumButton;
}
- (UIButton *)torchButton {
    if (!_torchButton) {
        _torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_torchButton setImage:[UIImage imageNamed:@"recycle_order_torch_icon"] forState:UIControlStateNormal];
        [_torchButton addTarget:self action:@selector(didClickTorchWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _torchButton;
}
- (JHRecycleTackPhoneView *)takeView {
    if (!_takeView) {
        _takeView = [[JHRecycleTackPhoneView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _takeView.takePhone = ^{
            @strongify(self)
            [self didClickTakePhone];
        };
        _takeView.startRecord = ^{
            @strongify(self)
            [self didClickStartRecord];
        };
        _takeView.stopRecord = ^{
            @strongify(self)
            [self didClickStopRecord];
        };
        _takeView.remakePhone = ^{
            @strongify(self)
            [self didClickRemakePhone];
        };
    }
    return _takeView;
}

- (UIButton *)examButton {
    if (!_examButton) {
        _examButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_examButton jh_cornerRadius:2];
        [_examButton jh_borderWithColor:HEXCOLOR(0xf0f0f3) borderWidth:1];
        [_examButton addTarget:self action:@selector(didClickExamWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _examButton;
}
- (UILabel *)examLabel {
    if (!_examLabel) {
        _examLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _examLabel.text = @"单个示例";
        _examLabel.textColor = HEXCOLOR(0xffffff);
        _examLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _examLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _examLabel;
}

- (UIButton *)examButton2 {
    if (!_examButton2) {
        _examButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_examButton2 jh_cornerRadius:2];
        [_examButton2 jh_borderWithColor:HEXCOLOR(0xf0f0f3) borderWidth:1];
        [_examButton2 addTarget:self action:@selector(didClickExamWithAction2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _examButton2;
}
- (UILabel *)examLabel2 {
    if (!_examLabel2) {
        _examLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _examLabel2.text = @"多个示例";
        _examLabel2.textColor = HEXCOLOR(0xffffff);
        _examLabel2.font = [UIFont fontWithName:kFontNormal size:11];
        _examLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _examLabel2;
}

- (UIStackView *)examView {
    if (!_examView) {
        _examView = [[UIStackView alloc] initWithArrangedSubviews:@[self.examButton, self.examLabel,self.examButton2, self.examLabel2]];
        _examView.spacing = 4;
        _examView.axis = UILayoutConstraintAxisVertical;
        _examView.alignment = UIStackViewAlignmentCenter;
        _examView.distribution = UIStackViewDistributionFill;
    }
    return _examView;
}
@end
