//
//  JHBusinessPublishPictureView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessPublishBaseView.h"
#import "JHRecyclePhotoInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 回收上传商品填写信息view____宝贝细节View   20张
@interface JHBusinessPublishPictureView : JHBusinessPublishBaseView

/// 宝贝细节图片数组
@property(nonatomic, strong, readonly) NSMutableArray<JHRecyclePhotoInfoModel*> *productDetailPictureArr;

/// 添加宝贝细节点击回调
@property(nonatomic, copy) void (^addProductDetailBlock)(NSInteger maxCount);

@property(nonatomic, weak) NSOperationQueue * uploadQueue;

@property(nonatomic, strong) UILabel * descLabel;
- (instancetype)initWithFrame:(CGRect)frame maxCount:(NSInteger)maxCount;

/// 添加宝贝细节图片
/// @param name
/// @param imageName
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel*)model;


/// 添加宝贝细节图片
/// @param modelArr 批量添加
- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr;

-(void)setNetDataWithArray:(NSArray *)modelArr;
@end
NS_ASSUME_NONNULL_END
