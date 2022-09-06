//
//  JHC2CProductUploadInfoView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JHRecycleUploadExampleModel.h"
#import "JHC2CProductUploadJianDingButton.h"
#import "JHIssueGoodsEditModel.h"
#import "JHC2CProductUploadNesPictureView.h"
#import "JHC2CProductUploadDetailInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHRecyclePhotoInfoModel;
@class BackAttrRelationResponse;

@interface JHC2CProductUploadInfoView : UIView

@property(nonatomic, strong) JHC2CProductUploadNesPictureView * productView;

/// 详细规格选填
@property(nonatomic, strong) JHC2CProductUploadDetailInfoView * detailInfoView;

@property(nonatomic, strong) UILabel * titleLbl;

/// 宝贝描述
@property(nonatomic, copy) NSString *productIllustration;

///属性字典， 为空字符串为未选择
@property(nonatomic, strong) NSMutableDictionary * attDic;

@property(nonatomic, strong) NSDictionary * netAttDic;

/// 宝贝图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productPictureArr;

/// 宝贝细节图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productDetailPictureArr;

/// 删除宝贝图片点击回调
@property(nonatomic, copy) void (^delProductPictureBlock)(NSInteger index);

/// 添加宝贝图片点击回调
@property(nonatomic, copy) void (^addProductPictureBlock)(NSInteger index);

/// 添加宝贝细节点击回调
@property(nonatomic, copy) void (^addProductDetailBlock)(NSInteger maxCount);


/// 加个按钮节点击回调
@property(nonatomic, copy) void (^tapPriceBlock)(NSString *currentPrice);

@property(nonatomic, strong) JHC2CProductUploadJianDingButton * jianDingBtn;

@property(nonatomic, strong) NSString * price;

/// 价格 0 一口价  1竞拍
@property(nonatomic) NSInteger priceType;

/// 邮费
@property(nonatomic, strong) NSString * postPrice;

/// 添加宝贝图片
/// @param name
/// @param imageName
- (void)addProductPictureWithName:(JHRecyclePhotoInfoModel*)model andIndex:(NSInteger)index;

/// 添加宝贝细节图片
/// @param name
/// @param imageName
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel*)model;

- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr;


- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray <JHRecycleUploadExampleModel *> * )modelArr andSeleModelArr:(NSArray <BackAttrRelationResponse *> * )seleModelArr;


- (void)showNetImage:(JHIssueGoodsEditImageItemModel *)model andIndex:(NSInteger)index;

- (void)addNetProductDetailPictureWithModelArr:(NSArray *)modelArr;

@end

NS_ASSUME_NONNULL_END
