//
//  JHRecycleCameraBaseViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCameraManager.h"
#import "JHRecycleTackPhoneView.h"
#import "JHRecycleUploadExampleModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    TemplateCameraFromTypeRecycle,
    TemplateCameraFromTypeC2C,
} TemplateCameraFromType;


@interface JHRecycleNomalCameraViewController : JHBaseViewController
/// 摄像机
@property (nonatomic, strong) JHCameraManager *cameraManager;
/// 类别ID
@property (nonatomic, assign) NSString *categoryId;
/// 自定义视图区
@property (nonatomic, strong) UIView *customView;
/// 是否允许拍照
@property (nonatomic, assign) BOOL allowTakePhone;
/// 是否允许录像
@property (nonatomic, assign) BOOL allowRecordVideo;

/// 是否允许裁剪
@property (nonatomic, assign) BOOL allowCrop;
/// 示例图-url
@property (nonatomic, copy) NSString *examImageUrl;
/// 示例图
@property (nonatomic, strong) UIStackView *examView;
/// 拍照/录像
@property (nonatomic, strong) JHRecycleTackPhoneView *takeView;

/// 示例
@property (nonatomic, strong) UIButton *examButton;
@property (nonatomic, strong) UILabel *examLabel;

@property (nonatomic, strong) UIButton *examButton2;
@property (nonatomic, strong) UILabel *examLabel2;

/// 来源类型
@property (nonatomic, assign) TemplateCameraFromType fromType;
/// 单图示例
@property(nonatomic, strong) NSArray <JHRecycleUploadExampleModel *> * singleModelArr;
/// 多图示例
@property(nonatomic, strong) NSArray <JHRecycleUploadExampleModel *> * multiImgModelArr;

- (void)setupUI;
- (void)layoutViews;

- (void)didClickAlbum;
- (void)didClickRemakePhone;
- (void)handleAssetModel : (JHAssetModel *)assetModel;
@end

NS_ASSUME_NONNULL_END
