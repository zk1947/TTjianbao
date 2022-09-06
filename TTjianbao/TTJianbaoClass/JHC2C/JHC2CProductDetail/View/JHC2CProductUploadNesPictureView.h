//
//  JHC2CProductUploadNesPictureView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleProductPictureView.h"
#import "JHIssueGoodsEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductUploadNesPictureView : UIView

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

- (void)addNetProductPictureWithName:(JHIssueGoodsEditImageItemModel *)model andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
