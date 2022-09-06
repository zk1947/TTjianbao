//
//  JHRecyclePhotoLibraryViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImagePickerTempViewController.h"




@interface JHRecycleImagePickerTempViewController ()



@end

@implementation JHRecycleImagePickerTempViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindData];
    [self setData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNavView];
    [self.view bringSubviewToFront:self.jhNavView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.templateView scrollToItem];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"相机-图片选择器%@ 释放", [self class]);
}

#pragma mark - Action
- (void)didClickConfirmWithAction : (UIButton *)sender {
    
    if (self.templateView.viewModel.finishNum == self.templateView.viewModel.totalNum) {
        [self.assetHandle sendNext:nil];
        [self popToVC];
    }else {
        [self.navigationController popViewControllerAnimated:true];
    }
}
- (void)popToVC {
    NSMutableArray *vcs = [self.navigationController.childViewControllers mutableCopy];
    [vcs removeLastObject];
    [vcs removeLastObject];
    [self.navigationController setViewControllers:vcs animated:true];
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.selectedAssetSubject subscribeNext:^(JHRecycleImagePickerCellViewModel * _Nullable x) {
        @strongify(self)
        BOOL canSelected = [self.templateView.viewModel setupAssetModel:x.assetModel];
        if (canSelected == false) {
            x.isSelected = false;
        }else {
            
        }
    }];
    
    [self.deSelectedAssetSubject subscribeNext:^(JHRecycleImagePickerCellViewModel * _Nullable x) {
        @strongify(self)
        [self.templateView.viewModel deleteImageWithAssetModel:x.assetModel];
    }];
    [self.templateView.viewModel.deleteAssetModelSubject subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self deSelectedAsset:x];
    }];
}

#pragma mark - Private
- (void)setData {
    self.templateView.viewModel.itemList = self.itemList;
    
    NSMutableArray *list = [NSMutableArray new];
    for (JHRecycleImageTemplateCellViewModel *cell in self.itemList) {
        if (cell.templateModel.asset != nil) {
            [list appendObject:cell.templateModel.asset];
        }
    }
    [self.viewModel setupSelectedWithList:list];
}

#pragma mark - setupUI
- (void)setupUI {
    [super setupUI];
    self.jhTitleLabel.text = @"相册";
    [self.customView addSubview:self.templateView];
}
- (void)layoutViews {
    [super layoutViews];
    
    
    [self.templateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-14);
        make.left.equalTo(self.customView).offset(20);
        make.right.equalTo(self.customView).offset(-20);
        make.height.mas_equalTo(84);
    }];
    
    [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(176);
    }];
}
#pragma mark - Lazy
- (void)setItemList:(NSArray<JHRecycleImageTemplateCellViewModel *> *)itemList {
    _itemList = itemList;
    
}
- (JHRecycleImageTemplateView *)templateView {
    if (!_templateView) {
        _templateView = [[JHRecycleImageTemplateView alloc] initWithType:RecycleTemplateCellTypeAdd];
    }
    return _templateView;
}


- (RACSubject<NSArray<JHRecycleTemplateImageModel *> *> *)assetHandle {
    if (!_assetHandle) {
        _assetHandle = [RACSubject subject];
    }
    return _assetHandle;
}
@end
