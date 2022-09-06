//
//  JHRecycleArbitrationPicturesView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecyclePhotoInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 回收上传仲裁信息view____图片View   9张
@interface JHRecycleArbitrationPicturesView : UIView

/// 仲裁图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productDetailPictureArr;

/// 添加仲裁图片点击回调
@property(nonatomic, copy) void (^addProductDetailBlock)(NSInteger maxCount);

/// 添加仲裁图片
/// @param name
/// @param imageName
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel*)model;

@end

NS_ASSUME_NONNULL_END
