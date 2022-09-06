//
//  JHBusinessPubishInfoView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleUploadExampleModel.h"
#import "JHC2CProductUploadJianDingButton.h"
#import "JHBusinessPubishNomalModel.h"
#import "JHBusinesspublishModel.h"
NS_ASSUME_NONNULL_BEGIN
@class JHRecyclePhotoInfoModel;
@class BackAttrRelationResponse;
@interface JHBusinessPubishInfoView : UIView
@property(nonatomic, strong) JHBusinesspublishModel * publishModle;

@property(nonatomic, strong) UILabel * titleLbl;

/// 宝贝描述
@property(nonatomic, copy, readonly) NSString *productIllustration;

///属性字典， 为空字符串为未选择
@property(nonatomic, strong) NSMutableDictionary * attDic;

/// 宝贝图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productPictureArr;

/// 宝贝细节图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productDetailPictureArr;
/// 视频
@property(nonatomic, strong, readonly) JHRecyclePhotoInfoModel *selectVideoModel;

/// 删除宝贝图片点击回调
@property(nonatomic, copy) void (^delProductPictureBlock)(NSInteger index);

/// 添加宝贝图片点击回调
@property(nonatomic, copy) void (^addProductPictureBlock)(NSInteger index);

/// 添加视频点击回调
@property(nonatomic, copy) void (^addProductVideoBlock)(NSInteger index);

/// 添加宝贝细节点击回调
@property(nonatomic, copy) void (^addProductDetailBlock)(NSInteger maxCount);
/// 添加宝贝细节点击回调
@property(nonatomic, copy) void (^addProductDetailBlock2)(NSInteger maxCount);
//视频
@property(nonatomic, copy) void (^addProductDetailBlock3)(NSInteger maxCount);

/// 加个按钮节点击回调
@property(nonatomic, copy) void (^tapPriceBlock)(NSString *currentPrice);

@property(nonatomic, strong) JHC2CProductUploadJianDingButton * jianDingBtn;

@property(nonatomic, strong) JHBusinessPubishNomalModel * normalModel;

@property(nonatomic, strong) NSMutableArray * attributeArray;

/// 添加宝贝图片
/// @param name
/// @param imageName
- (void)addProductPictureWithName:(JHRecyclePhotoInfoModel*)model andIndex:(NSInteger)index;

/// 添加宝贝细节图片
/// @param name
/// @param imageName
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel*)model;
- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr;

- (void)addProductDetailPictureWithName2:(JHRecyclePhotoInfoModel *)model;
- (void)addProductDetailPictureWithModelArr2:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr;
//添加视频
- (void)addProductVideoDetailPictureWithName:(JHRecyclePhotoInfoModel *)model;




- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray <JHRecycleUploadExampleModel *> * )modelArr andSeleModelArr:(NSArray <BackAttrRelationResponse *> * )seleModelArr andPubModel:(JHBusinesspublishModel*)pubmodel andPublishType:(JHB2CPublishGoodsType)type;

//网络数据回显
- (void)showNetData:(JHBusinesspublishModel *)model;
@end

NS_ASSUME_NONNULL_END
