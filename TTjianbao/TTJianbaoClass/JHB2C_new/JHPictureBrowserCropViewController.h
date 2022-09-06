//
//  JHPictureBrowserCropViewController.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHRecycleTemplateImageModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface JHPictureBrowserCropViewController : JHBaseViewController
@property (nonatomic, strong) PHAsset *assetModel; //相册图片
@property (nonatomic, strong) UIImage *originImage;//拍照原图
@property (nonatomic, copy) void (^surebtnClickedBlock)(UIImage *image);
//@property (nonatomic, strong) RACSubject<JHAssetModel *> *assetSubject;
@end

NS_ASSUME_NONNULL_END
