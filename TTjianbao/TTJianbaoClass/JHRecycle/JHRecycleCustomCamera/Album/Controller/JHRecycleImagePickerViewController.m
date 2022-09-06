//
//  JHRecycleImagePickerBaseViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImagePickerViewController.h"
#import "JHRecycleImagePickerImageCell.h"
#import "JHStoreDetailBaseFlowLayout.h"
#import "MBProgressHUD.h"
#import "CommAlertView.h"
#import "JHPictureBrowserCropViewController.h"

@interface JHRecycleImagePickerViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
/// 选中asset
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAssets;
@end

@implementation JHRecycleImagePickerViewController
#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerCells];
    [self checkPhotoLibraryAuthority];
    [self showProgressHUD];
    [self.viewModel getAssetData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.viewModel.itemList.count <= 0) {
        [self checkPhotoLibraryAuthority];
        [self.viewModel getAssetData];
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"相机-图片选择器ViewController-%@ 释放", [self class]);
}

#pragma mark - Action
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleImagePickerCellViewModel *model = self.viewModel.itemList[indexPath.item];
    if (model.canSelected == false) return;
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        if (self.maxSelectedNum == 0) {
            [self.selectedAssetSubject sendNext:model];
        }else if (self.selectedAssets.count < self.maxSelectedNum) {
            [self.selectedAssets appendObject:model.assetModel.asset];
        }else {
            model.isSelected = false;
        }
        
    }else {
        if (self.selectedAssets.count > 0) {
            [self deleteAsset:model.assetModel.asset];
        }
        [self.deSelectedAssetSubject sendNext:model];
    }
}
- (void)deSelectedAsset : (NSString *)localId {
    NSArray<JHRecycleImagePickerCellViewModel *> *list = [self.viewModel.itemList jh_filter:^BOOL(JHRecycleImagePickerCellViewModel * _Nonnull obj, NSUInteger idx) {
        return [obj.assetModel.asset.localIdentifier isEqualToString: localId];
    }];
   
    if (list.count > 0) {
        for (JHRecycleImagePickerCellViewModel *model in list) {
            model.isSelected = false;
        }
    }
}
- (void)deleteAsset : (PHAsset *)asset {
    [self.selectedAssets removeObject:asset];
}
#pragma mark - Bind
- (void)bindBaseData {
    @weakify(self)
    [self.viewModel.reloadData subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self hideProgressHUD];
        [self.collectionView jh_reloadDataWithEmputyView];
    }];
}

#pragma mark - Private

- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}
// 相册权限
- (void)checkPhotoLibraryAuthority {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusNotDetermined) {
        @weakify(self)
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            @strongify(self)
            if (status != PHAuthorizationStatusAuthorized) {
                [self showAlertWithDesc:@"无相册权限请前往设置"];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.viewModel.itemList.count <= 0) {
                        [self.viewModel getAssetData];
                    }
                });
            }
        }];
    }
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
- (void)didClickConfirmWithAction : (UIButton *)sender {
    if (self.selectedAssets.count==0) {
        return;
    }
    if (self.allowCrop) {
        JHPictureBrowserCropViewController *crop = [[JHPictureBrowserCropViewController alloc] init];
        [self.navigationController pushViewController:crop animated:YES];
        crop.assetModel = [self.selectedAssets firstObject];
    }else{
        [self.selectAssets sendNext:self.selectedAssets];
        if (self.backNum > 0) {
            [self popToVC];
        }else {
            [self.navigationController popViewControllerAnimated:true];
        }
    }
}
- (void)popToVC {
    NSMutableArray *vcs = [self.navigationController.childViewControllers mutableCopy];
    for (int i = 1; i <= self.backNum; i++) {
        [vcs removeLastObject];
    }
    [self.navigationController setViewControllers:vcs animated:true];
}
#pragma mark - setupUI
- (void)setupUI {
    self.jhTitleLabel.text = @"相册";
    [self.customView addSubview:self.confirmButton];
    [self.contentView addSubview:self.collectionView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.customView];
}
- (void)layoutViews {
    [self.confirmButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xfed73a), HEXCOLOR(0xfecb33)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.customView.mas_top).offset(0);
    }];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-UI.bottomSafeAreaHeight);
        make.height.mas_equalTo(68);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.customView).offset(-8);
        make.left.equalTo(self.customView).offset(20);
        make.right.equalTo(self.customView).offset(-20);
        make.height.mas_equalTo(50);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(ItemSpace, ItemSpace, 0, ItemSpace));
    }];
}

- (void) registerCells {
    [self.collectionView registerClass:[JHRecycleImagePickerImageCell class] forCellWithReuseIdentifier:@"JHRecycleImagePickerImageCell" ];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleImagePickerCellViewModel *model = self.viewModel.itemList[indexPath.item];
    
    JHRecycleImagePickerImageCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHRecycleImagePickerImageCell" forIndexPath:indexPath];
    item.viewModel = model;
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleImagePickerCellViewModel *model = self.viewModel.itemList[indexPath.item];
    return model.itemSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ItemSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ItemSpace;
}

#pragma mark - Lazy
- (JHRecycleImagePickerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHRecycleImagePickerViewModel alloc] init];
        [self bindBaseData];
    }
    return _viewModel;
}
- (void)setPickerType:(RecycleImagePickerType)pickerType {
    _pickerType = pickerType;
    self.viewModel.pickerType = pickerType;
}
- (void)setMaxVideoDuration:(NSUInteger)maxVideoDuration {
    _maxVideoDuration = maxVideoDuration;
    self.viewModel.maxVideoDuration = maxVideoDuration;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = HEXCOLOR(0xf5f5f5);
    }
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _collectionView.showsVerticalScrollIndicator = false;
    }
    return _collectionView;
}
- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] initWithFrame:CGRectZero];
        _customView.backgroundColor = UIColor.whiteColor;
    }
    return _customView;
}

- (RACSubject<JHRecycleImagePickerCellViewModel *> *)selectedAssetSubject {
    if (!_selectedAssetSubject) {
        _selectedAssetSubject = [RACSubject subject];
    }
    return _selectedAssetSubject;
}
- (RACSubject<JHRecycleImagePickerCellViewModel *> *)deSelectedAssetSubject {
    if (!_deSelectedAssetSubject) {
        _deSelectedAssetSubject = [RACSubject subject];
    }
    return _deSelectedAssetSubject;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        [_confirmButton jh_cornerRadius:5];
        [_confirmButton addTarget:self action:@selector(didClickConfirmWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
- (NSMutableArray<PHAsset *> *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}
- (RACSubject<NSArray<PHAsset *> *> *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [RACSubject subject];
    }
    return _selectAssets;
}
@end
