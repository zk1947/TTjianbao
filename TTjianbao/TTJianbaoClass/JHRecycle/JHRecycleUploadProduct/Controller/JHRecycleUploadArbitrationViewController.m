//
//  JHRecycleUploadArbitrationViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadArbitrationViewController.h"
#import "BaseNavViewController.h"
#import "JHRecycleSureButton.h"
#import "JHRecycleArbitrationInfoView.h"
#import <IQKeyboardManager.h>
#import "TZImagePickerController.h"
#import "JHRecycleUploadProductBusiness.h"
#import "SVProgressHUD.h"


@interface JHRecycleUploadArbitrationViewController ()<TZImagePickerControllerDelegate>
@property(nonatomic, strong) JHRecycleSureButton * bottomBtn;
@property(nonatomic, strong) JHRecycleArbitrationInfoView * infoView;


@end

@implementation JHRecycleUploadArbitrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请仲裁";
    [self setItems];
    [self layoutItems];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refreshButtonStatus) name:JHNotificationRecycleUploadImageInfoChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager.sharedManager setShouldResignOnTouchOutside:YES];
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = YES;
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager.sharedManager setShouldResignOnTouchOutside:NO];
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = NO;
    }
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:JHNotificationRecycleUploadImageInfoChanged object:nil];
}

- (void)setItems{
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.bottomBtn];

}

- (void)layoutItems{
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@0).inset(UI.bottomSafeAreaHeight + 10);
        make.size.mas_equalTo(CGSizeMake(230, 40));
    }];
}


#pragma mark -- <Action>
- (BOOL)checkDataChange{
    return (self.infoView.productDetailPictureArr.count||
            self.infoView.detailString.length);
}

- (void)arbitrationBtnActionWithSender:(UIButton*)sender{
    self.bottomBtn.enabled = NO;
    if ([self checkAliyunosImageUrl]) {
        [SVProgressHUD dismiss];
        [self finishAliossAndUploadServer];
    }else{
        dispatch_after(1, dispatch_get_main_queue(), ^{
            [self arbitrationBtnActionWithSender:nil];
        });
    }
}

- (void)finishAliossAndUploadServer{
    [SVProgressHUD show];
    NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productDetailPictureArr.count];
    [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageUrlArr addObject:obj.aliossUrl];
    }];
    [JHRecycleUploadProductBusiness requestRecycleArbitrationUploadOrderId:self.orderId andDesc:self.infoView.detailString andImgUrls:imageUrlArr andCompletion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        self.bottomBtn.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (BOOL)checkAliyunosImageUrl{
    __block BOOL finish = YES;
    __block NSInteger finishCount = 0;
    [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.aliossUrl){
            finish = NO;
        }else{
            finishCount += 1;
        }
    }];
    if (!finish) {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传图片中%ld/%ld", finishCount, self.infoView.productDetailPictureArr.count]];
    }
    return finish;
}

- (void)refreshButtonStatus{
    //待完善
    if (self.infoView.detailString.length &&
        self.infoView.productDetailPictureArr.count) {
        self.bottomBtn.enabled = YES;
    }else{
        self.bottomBtn.enabled = NO;
    }
}

- (void)backActionButton:(UIButton *)sender{
    if ([self checkDataChange]) {
        [self showAlert];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showAlert{
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:@"仲裁尚未完成，是否继续。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:nil];
    [alertV addAction:deleteAction];
    [alertV addAction:cancelAction];
    [JHRootController.currentViewController presentViewController:alertV animated:YES completion:nil];

}
- (void)addProductDetailPictureWithMaxCount:(NSInteger)count{
    [self.infoView resignFirst];
    [self openPhotoLibraryWithMaxCount:count];
}

- (void)openPhotoLibraryWithMaxCount:(NSInteger)count{
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    picker.alwaysEnableDoneBtn = NO;
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
    picker.sortAscendingByModificationDate = NO;
    picker.allowPreview = YES;
    picker.showSelectedIndex = NO;
    picker.allowTakePicture = NO;
    picker.allowPickingImage = YES;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    picker.allowPickingGif = YES;
    picker.allowPickingOriginalPhoto = YES;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark -- <TZImagePickerControllerDelegate>
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    for (int i = 0; i< photos.count; i++) {
        JHRecyclePhotoInfoModel *model = [JHRecyclePhotoInfoModel photoInfoModelWithImage:photos[i] andAsset:assets[i]];
        [self.infoView addProductDetailPictureWithName:model];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- <set and get>

- (JHRecycleSureButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [JHRecycleSureButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.layer.cornerRadius = 20;
        [_bottomBtn setTitle:@"提交仲裁" forState:UIControlStateNormal];
        _bottomBtn.enabled = NO;
        [_bottomBtn addTarget:self action:@selector(arbitrationBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (JHRecycleArbitrationInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[JHRecycleArbitrationInfoView alloc] init];
        @weakify(self);
        [_infoView setAddProductDetailBlock:^(NSInteger maxCount) {
            @strongify(self);
            [self addProductDetailPictureWithMaxCount:maxCount];
        }];
    }
    return _infoView;
}

@end
