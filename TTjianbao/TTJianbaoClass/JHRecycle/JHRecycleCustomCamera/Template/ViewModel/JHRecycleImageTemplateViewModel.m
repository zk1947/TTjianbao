//
//  JHRecycleImageTemplateViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImageTemplateViewModel.h"

@interface JHRecycleImageTemplateViewModel ()

@end
@implementation JHRecycleImageTemplateViewModel

#pragma mark - Life Cycle Functions
- (instancetype)initWithType : (RecycleTemplateCellType)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)dealloc {
    NSLog(@"picker-%@ 释放", [self class]);
}
- (BOOL)setupAssetModel : (JHAssetModel *)assetModel {
    if (self.finishNum < self.totalNum) {
        [self.currentViewModel addImageWithAssetModel:assetModel];
        [self setupNextViewModel];
//        self.finishNum += 1;
        [self setupFinishNum];
        return true;
    }
    return false;
}

- (void)deleteImageWithAssetModel : (JHAssetModel *)assetModel {
    JHRecycleImageTemplateCellViewModel *cellViewModel = [self getCellViewModelWithAssetModel:assetModel];
    [self setDeleteModel:cellViewModel];
}

- (void)setDeleteModel : (JHRecycleImageTemplateCellViewModel *)viewModel {
    self.currentViewModel.isSelected = false;
    [viewModel deleteImage];
    self.currentViewModel = viewModel;
//    self.finishNum -= 1;
    [self setupFinishNum];
}
- (JHRecycleImageTemplateCellViewModel *)getCellViewModelWithAssetModel : (JHAssetModel *)assetModel {
    for (JHRecycleImageTemplateCellViewModel *viewModel in self.itemList) {
        if ([viewModel.templateModel.localIdentifier isEqualToString: assetModel.localIdentifier]) {
            return viewModel;
        }
    }
    return nil;
}
#pragma mark - Private Functions
- (void)setupData {
    self.finishNum = 0;
    if (self.itemList == nil) return;
    int i = 0;
    for (JHRecycleImageTemplateCellViewModel *viewModel in self.itemList) {
        viewModel.index = i;
        viewModel.cellType = self.type;
        if (viewModel.isSelected) {
            self.currentViewModel = viewModel;
        }
        if (viewModel.templateModel.asset != nil) {
            self.finishNum += 1;
        }
        [self bindDataWithModel:viewModel];
        i += 1;
    }
    if (self.currentViewModel == nil && self.finishNum < self.totalNum) {
        self.currentViewModel = self.itemList[0];
        self.currentViewModel.isSelected = true;
    }
    [self.reloadData sendNext:nil];
}

- (void)bindDataWithModel : (JHRecycleImageTemplateCellViewModel *)viewModel {
    @weakify(self)
    [viewModel.selectedEvent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.currentViewModel.isSelected = false;
        viewModel.isSelected = true;
        if (viewModel.templateModel.thumbnailImage) {
            [self.showRemake sendNext:@(1)];
        }else {
            [self.showRemake sendNext:@(0)];
        }
    }];
    
    [viewModel.deleteEvent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.deleteAssetModelSubject sendNext:viewModel.templateModel.localIdentifier];
        [self setDeleteModel:viewModel];
    }];
    
    [RACObserve(viewModel, isSelected)
    subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        BOOL selected = [x boolValue];
        if (selected) {
            self.currentViewModel = viewModel;
        }
    }];
    
}

- (void)setupNextViewModel {
    for (JHRecycleImageTemplateCellViewModel *viewModel in self.itemList) {
        if (viewModel.templateModel.thumbnailImage == nil) {
            viewModel.isSelected = true;
            self.currentViewModel = viewModel;
            return;
        }
    }
}
- (void)setupFinishNum {
    self.finishNum = 0;
    NSArray *list = [self.itemList jh_filter:^BOOL(JHRecycleImageTemplateCellViewModel * _Nonnull obj, NSUInteger idx) {
        return obj.templateModel.asset != nil;
    }];
    self.finishNum = list.count;
//    for (JHRecycleImageTemplateCellViewModel *viewModel in self.itemList) {
//        if (viewModel.templateModel.asset != nil) {
//            self.finishNum += 1;
//        }
//    }
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setCurrentViewModel:(JHRecycleImageTemplateCellViewModel *)currentViewModel {
    _currentViewModel = currentViewModel;
    self.currentIndex = currentViewModel.index;
}
- (void)setItemList:(NSArray<JHRecycleImageTemplateCellViewModel *> *)itemList {
    _itemList = itemList;
    self.totalNum = itemList.count;
    self.finishNum = 0;
    [self setupData];
}

- (RACSubject *)reloadData {
    if (!_reloadData) {
        _reloadData = [RACSubject subject];
    }
    return _reloadData;
}
- (RACSubject<NSNumber *> *)showRemake {
    if (!_showRemake) {
        _showRemake = [RACSubject subject];
    }
    return _showRemake;
}
- (RACSubject<NSString *> *)deleteAssetModelSubject {
    if (!_deleteAssetModelSubject) {
        _deleteAssetModelSubject = [RACSubject subject];
    }
    return _deleteAssetModelSubject;
}
@end
