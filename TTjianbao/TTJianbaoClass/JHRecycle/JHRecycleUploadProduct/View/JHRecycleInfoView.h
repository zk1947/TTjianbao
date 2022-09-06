//
//  JHRecycleInfoView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleUploadExampleModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHRecyclePhotoInfoModel;

/// 回收上传商品填写信息view
@interface JHRecycleInfoView : UIView

/// 宝贝图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productPictureArr;

/// 宝贝细节图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productDetailPictureArr;

/// 宝贝描述
@property(nonatomic, copy, readonly) NSString *productIllustration;

/// 期望价格
@property(nonatomic, copy, readonly) NSString *expectPrice;

/// 删除宝贝图片点击回调
@property(nonatomic, copy) void (^delProductPictureBlock)(NSInteger index);

/// 添加宝贝图片点击回调
@property(nonatomic, copy) void (^addProductPictureBlock)(NSInteger index);

/// 添加宝贝细节点击回调
@property(nonatomic, copy) void (^addProductDetailBlock)(NSInteger maxCount);

/// 添加宝贝图片
/// @param name
/// @param imageName
- (void)addProductPictureWithName:(JHRecyclePhotoInfoModel*)model andIndex:(NSInteger)index;

/// 添加宝贝细节图片
/// @param name
/// @param imageName
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel*)model;


- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr;

/// 刷新顶部类型和图片
/// @param name
/// @param imageName
- (void)refreshTopTypeViewWithName:(NSString*)name andImageName:(NSString*)imageName andmodle:(JHRecycleUploadExampleTotalModel *)model;


- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray <JHRecycleUploadExampleModel *> * )modelArr;

@end

NS_ASSUME_NONNULL_END
