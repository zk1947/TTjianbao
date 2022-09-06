//
//  JHRecycleGoodsInfoViewModel.h
//  TTjianbao
//
//  Created by user on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleGoodsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, JHRecycleGoodsInfoCellStyle) {
    JHRecycleGoodsInfoCellStyle_PictsBanner = 888, /// 图片
    JHRecycleGoodsInfoCellStyle_Info,              /// 用户信息
    JHRecycleGoodsInfoCellStyle_Desc,              /// 描述
    JHRecycleGoodsInfoCellStyle_PictName,          /// 图片标题
    JHRecycleGoodsInfoCellStyle_PictAndVideo       /// 图、视频
};

@interface JHRecycleGoodsInfoCellStyle_PictsBannerViewModel : NSObject
@property (nonatomic, assign) JHRecycleGoodsInfoCellStyle cellStyle;
/// 宝贝图片地址
@property (nonatomic, strong) NSArray<JHRecycleDetailInfoProductImgUrlsModel *> *productImgUrls;
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model;
@end






@interface JHRecycleGoodsInfoShowViewModel : NSObject
/// 回收商品 ---- 已成交
@property (nonatomic,   copy) NSString *productPrice;
/// 用户头像
@property (nonatomic,   copy) NSString *customerImg;
/// 用户昵称
@property (nonatomic,   copy) NSString *customerName;
/// 商品名称
@property (nonatomic,   copy) NSString *productName;
@end


@interface JHRecycleGoodsInfoCellStyle_InfoViewModel : NSObject
@property (nonatomic, strong) JHRecycleGoodsInfoShowViewModel *infoModel;
@property (nonatomic, assign) JHRecycleGoodsInfoCellStyle cellStyle;
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model;
@end

/// 宝贝描述
@interface JHRecycleGoodsInfoCellStyle_DescViewModel : NSObject
@property (nonatomic,   copy) NSString *productDesc;
@property (nonatomic, assign) JHRecycleGoodsInfoCellStyle cellStyle;
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model;
@end

@interface JHRecycleGoodsInfoCellStyle_PictNameViewModel : NSObject
@property (nonatomic,   copy) NSString *pictTitleName;
@property (nonatomic, assign) JHRecycleGoodsInfoCellStyle cellStyle;
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model;
@end


/// 宝贝细节地址(带视频)
@interface JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel : NSObject
@property (nonatomic, strong) JHRecycleDetailInfoProductDetailUrlsModel *detailUrlsModel;
@property (nonatomic, strong) NSArray<NSString *> *productDetailMedium;
@property (nonatomic, strong) NSArray<NSString *> *productDetailOrigin;
@property (nonatomic, assign) JHRecycleGoodsInfoCellStyle cellStyle;
+ (instancetype)viewModel:(JHRecycleDetailInfoProductDetailUrlsModel *)model;
@end


@interface JHRecycleGoodsInfoViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic,   copy) NSString *navName;
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
