//
//  JHRecyclePhotoSeletedView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHIssueGoodsEditModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHRecyclePhotoSeletedViewType) {
    JHRecyclePhotoSeletedViewType_Product = 0,///商品上传图片
    JHRecyclePhotoSeletedViewType_Arbitration,///仲裁上传图片
    JHRecyclePhotoSeletedViewType_C2CProduct,///C2C上传图片
    JHRecyclePhotoSeletedViewType_B2CVideo,//b2c 发布视频
};
@class JHRecyclePhotoInfoModel;
/// 回收长传图片选中view
@interface JHRecyclePhotoSeletedView : UIView

@property(nonatomic, assign) JHRecyclePhotoSeletedViewType  type;
@property(nonatomic, copy) void (^deleteBlock)(JHRecyclePhotoSeletedView* photoView) ;
@property(nonatomic, copy) void (^tapImageBlock)(JHRecyclePhotoSeletedView* photoView) ;

@property(nonatomic, strong) JHRecyclePhotoInfoModel * model;

@property(nonatomic, strong)JHIssueGoodsEditImageItemModel *editModel;

@property(nonatomic, weak) NSOperationQueue * uploadQueue;

@end

NS_ASSUME_NONNULL_END
