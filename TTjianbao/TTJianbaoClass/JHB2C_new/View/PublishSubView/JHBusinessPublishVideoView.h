//
//  JHBusinessPublishVideoView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecyclePhotoInfoModel.h"
#import "JHBusinessPublishBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishVideoView : JHBusinessPublishBaseView
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
- (void)addProductVideoDetailPictureWithName:(JHRecyclePhotoInfoModel*)model;


/// 添加宝贝细节图片
/// @param modelArr 批量添加
- (void)addProductVideoDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr;

-(void)setNetDataWithArray:(JHIssueGoodsEditImageItemModel *)modelArr;
@end

NS_ASSUME_NONNULL_END
