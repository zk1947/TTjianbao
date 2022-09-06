//
//  JHRecycleProductPictureView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecyclePhotoInfoModel.h"
#import "JHRecycleUploadExampleModel.h"


NS_ASSUME_NONNULL_BEGIN
/// 回收上传商品填写信息view____宝贝图片 必传View
@interface JHRecycleProductPictureView : UIView

@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UIImageView * starImageView;

/// 宝贝图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productPictureArr;

/// 删除宝贝图片点击回调
@property(nonatomic, copy) void (^delProductPictureBlock)(NSInteger index);

/// 添加宝贝图片点击回调
@property(nonatomic, copy) void (^addProductPictureBlock)(NSInteger index);

@property(nonatomic, weak) NSOperationQueue * uploadQueue;
@property(nonatomic, strong) UILabel * descLabel;

/// 添加宝贝图片
/// @param name
/// @param imageName
- (void)addProductPictureWithName:(JHRecyclePhotoInfoModel*)model andIndex:(NSInteger)index;


- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray <JHRecycleUploadExampleModel *> * )modelArr;
@end

NS_ASSUME_NONNULL_END
