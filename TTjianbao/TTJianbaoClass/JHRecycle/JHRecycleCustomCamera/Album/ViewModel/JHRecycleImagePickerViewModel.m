//
//  JHRecycleImagePickerViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImagePickerViewModel.h"
#import <Photos/Photos.h>
#import "JHRecycleImagePickerCellViewModel.h"

@implementation JHRecycleImagePickerViewModel
#pragma mark - Life Cycle Functions

- (instancetype)init{
    self = [super init];
    if (self) {
        self.pickerType = RecycleImagePickerTypeNomal;
//        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"picker-%@ 释放", [self class]);
}

- (void)setupSelectedWithList : (NSArray<PHAsset *> *) list {
    
    for (PHAsset *assetModel in list) {
        NSArray *arr = [self.itemList jh_filter:^BOOL(JHRecycleImagePickerCellViewModel * _Nonnull obj, NSUInteger idx) {
            return [obj.localIdentifier isEqualToString:assetModel.localIdentifier];
        }];
        
        JHRecycleImagePickerCellViewModel *viewModel = arr.lastObject;
        viewModel.isSelected = true;
    }
}

#pragma mark - Private Functions

- (void)getAssetData {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:false]];
    
    PHFetchResult * result;
    
    switch (self.pickerType) {
        case RecycleImagePickerTypeImage:
            result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
            break;
        case RecycleImagePickerTypeVideo:
            result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:option];
            break;
        default:
            result = [PHAsset fetchAssetsWithOptions:option];
            break;
    }
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    options.synchronous = true;
    
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

    for (PHAsset *asset in result) {
        JHRecycleImagePickerCellViewModel *viewModel = [[JHRecycleImagePickerCellViewModel alloc] init];
        if (self.maxVideoDuration != 0 && asset.duration > self.maxVideoDuration) {
            viewModel.canSelected = false;
        }else {
            viewModel.canSelected = true;
        }
        JHAssetModel *assetModel = [[JHAssetModel alloc] init];
        assetModel.asset = asset;
        assetModel.localIdentifier = asset.localIdentifier;
        viewModel.assetModel = assetModel;
        [self.itemList appendObject:viewModel];
    }
    [self.reloadData sendNext:nil];
}
#pragma mark - Action functions
#pragma mark - Lazy

- (NSMutableArray<JHRecycleImagePickerCellViewModel *> *)itemList {
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}
- (RACReplaySubject *)reloadData {
    if (!_reloadData) {
        _reloadData = [RACReplaySubject subject];
    }
    return _reloadData;
}
@end
