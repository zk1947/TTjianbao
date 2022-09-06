//
//  JHRecycleArbitrationInfoView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecyclePhotoInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
///回收仲裁上传信息View
@interface JHRecycleArbitrationInfoView : UIView

/// 仲裁图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productDetailPictureArr;

/// 仲裁描述
@property(nonatomic, copy, readonly) NSString * detailString;

/// 添加仲裁图片点击回调
@property(nonatomic, copy) void (^addProductDetailBlock)(NSInteger maxCount);

/// 添加仲裁图片
/// @param name
/// @param imageName
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel*)model;


- (void)resignFirst;
@end

NS_ASSUME_NONNULL_END
