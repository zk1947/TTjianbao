//
//  JHRecycleImagePickerBaseViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHRecycleImagePickerViewModel.h"
#import "UIView+JHGradient.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleImagePickerViewController : JHBaseViewController
@property (nonatomic, strong) JHRecycleImagePickerViewModel *viewModel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *contentView;
/// 资源 -图片、视频
@property (nonatomic, strong) RACSubject<JHRecycleImagePickerCellViewModel *> *selectedAssetSubject;
/// 资源 -图片、视频
@property (nonatomic, strong) RACSubject<JHRecycleImagePickerCellViewModel *> *deSelectedAssetSubject;
/// 自定义视图区
@property (nonatomic, strong) UIView *customView;
/// 选中asset
@property (nonatomic, strong) RACSubject<NSArray<PHAsset *> *> *selectAssets;
/// 最大选中数量
@property (nonatomic, assign) NSUInteger maxSelectedNum;
/// 视频最大长度
@property (nonatomic, assign) NSUInteger maxVideoDuration;
/// 资源类型-视频、图片、all
@property (nonatomic, assign) RecycleImagePickerType pickerType;
/// 返回上级vc - 回退数
@property (nonatomic, assign) int backNum;

@property (nonatomic, assign) BOOL allowCrop;//允许裁剪

- (void)setupUI;
- (void)layoutViews;
- (void)deSelectedAsset : (NSString *)localId;
- (void)didClickConfirmWithAction : (UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
