//
//  JHRecycleOrderCameraViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleCameraViewController.h"
#import "JHRecycleImagePickerTempViewController.h"
#import "JHRecycleBrowserViewController.h"
#import "QBImagePickerController.h"

@interface JHRecycleCameraViewController ()<QBImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JHRecycleCameraViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindData];
    self.cameraManager.isAutoSave = false;
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
- (void)didClickAlbum {
    JHRecycleImagePickerViewController *picker = [[JHRecycleImagePickerViewController alloc] init];
    picker.allowCrop = self.allowCrop;
    picker.backNum = 2;
    picker.maxVideoDuration = 60;
    picker.maxSelectedNum = self.maximum;
    if (self.allowTakePhone && self.allowRecordVideo == false) {
        picker.pickerType = RecycleImagePickerTypeImage;
    }else if (self.allowTakePhone == false && self.allowRecordVideo ) {
        picker.pickerType = RecycleImagePickerTypeVideo;
    }
    
    [self.navigationController pushViewController:picker animated:true];

    @weakify(self)
    [picker.selectAssets subscribeNext:^(NSArray<PHAsset *> * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        NSMutableArray *arr = [NSMutableArray new];
        for (PHAsset *asset in x) {
            JHRecycleTemplateImageModel *model = [[JHRecycleTemplateImageModel alloc] init];
            model.asset = asset;
            [arr appendObject:model];
        }
        [self.assetHandle sendNext:arr];
    }];
    
//    QBImagePickerController *picker = [[QBImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.mediaType = QBImagePickerMediaTypeAny;
//    picker.allowsMultipleSelection = YES;
//    picker.showsNumberOfSelectedAssets = YES;
//    picker.maximumNumberOfSelection = self.maximum;
//    picker.minimumNumberOfSelection = 1;
//    picker.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.navigationController pushViewController:picker animated:true];
}
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    NSMutableArray *arr = [NSMutableArray new];
    for (PHAsset *asset in assets) {
        JHRecycleTemplateImageModel *model = [[JHRecycleTemplateImageModel alloc] init];
        model.asset = asset;
        [arr appendObject:model];
    }
    [self.assetHandle sendNext:arr];
    [self popToVC];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController.navigationController popViewControllerAnimated:true];
}
- (void)popToVC {
    NSMutableArray *vcs = [self.navigationController.childViewControllers mutableCopy];
    [vcs removeLastObject];
    [vcs removeLastObject];
    [self.navigationController setViewControllers:vcs animated:true];
}
#pragma mark - Private Functions

#pragma mark - Bind
- (void)handleAssetModel : (JHAssetModel *)assetModel {
    if (assetModel.assetType == JHAssetTypeImage) {
        [self pushImageBrowserWithAssetModel:assetModel];
    }else if (assetModel.assetType == JHAssetTypeVideo) {
        [self pushImageBrowserWithAssetModel:assetModel];
    }
}
- (void)bindData {
    
}
- (void)pushImageBrowserWithAssetModel : (JHAssetModel *)assetModel {
    JHRecycleBrowserViewController *vc = [[JHRecycleBrowserViewController alloc] init];
    vc.assetModel = assetModel;
    vc.allowCrop = self.allowCrop;
    [self presentViewController:vc animated:true completion:nil];
    
    @weakify(self)
    [vc.assetSubject subscribeNext:^(JHAssetModel * _Nullable x) {
        @strongify(self)
        if(x == nil) return;
        JHRecycleTemplateImageModel *model = [[JHRecycleTemplateImageModel alloc] init];
        model.thumbnailImage = x.thumbnailImage;
        model.asset = x.asset;
        model.localIdentifier = x.localIdentifier;
        [self.assetHandle sendNext:@[model]];
        [self.navigationController popViewControllerAnimated:true];
    }];
}
- (void)pushVideoBrowserWithAssetModel : (JHAssetModel *)assetModel {
    
}
#pragma mark - setupUI
- (void)setupUI {
    [super setupUI];
    if (self.showTitle.length>0) {
        self.jhTitleLabel.text = self.showTitle;
    }else{
        self.jhTitleLabel.text = @"宝贝细节";
    }
    
    self.examView.hidden = true;
    [self.customView addSubview:self.descLabel];
}
- (void)layoutViews {
    [super layoutViews];
    
    [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(76);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-24);
        make.left.right.mas_equalTo(0);
    }];
}
#pragma mark - Lazy
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        NSString *desc = @"轻点拍照，按住摄像";
        if (self.allowTakePhone && self.allowRecordVideo == false) {
            desc = @"轻点拍照";
        }else if (self.allowRecordVideo && self.allowTakePhone == false) {
            desc = @"按住摄像";
        }
        
        _descLabel.text = desc;
        _descLabel.textColor = HEXCOLOR(0x666666);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _descLabel;
}

- (RACSubject<NSArray<JHRecycleTemplateImageModel *> *> *)assetHandle {
    if (!_assetHandle) {
        _assetHandle = [RACSubject subject];
    }
    return _assetHandle;
}
@end
