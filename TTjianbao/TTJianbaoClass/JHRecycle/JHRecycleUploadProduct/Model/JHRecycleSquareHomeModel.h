//
//  JHRecycleSquareHomeModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleUploadSeleteTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleSquareHomeListModel : NSObject

/// 分类名称
@property(nonatomic, copy) NSString * categoryName;

/// 商品描述
@property(nonatomic, copy) NSString * productDesc;

///描述 + 分类名称
@property(nonatomic, copy) NSString * showCategoryName;

///描述 + 商品描述
@property(nonatomic, copy) NSString * showProductDesc;

/// 鉴定状态
@property(nonatomic, assign) NSInteger appraisalStatus;

/// 商品ID
@property(nonatomic, copy) NSString * productId;

/// 是否高货 0 否 1 是
@property(nonatomic, assign) NSInteger isHighQuality;

/// 来源 0 回收广场 1 直播间
@property(nonatomic, assign) NSInteger source;

/// 图片
@property(nonatomic, strong) JHRecycleUploadImageInfoModel * productImage;

/// 图片高度
@property(nonatomic, assign) CGFloat imageHeight;

/// 描述高度
@property(nonatomic, assign) CGFloat desHeight;

@end



@interface JHRecycleSquareHomeModel : NSObject

/// 生成当前页最后一条记录的信息
@property(nonatomic, copy) NSString * cursor;

/// 是否有下一页
@property(nonatomic, assign) BOOL  hasMore;

/// 每页数量
@property(nonatomic, assign) NSInteger pageSize;

/// 页码
@property(nonatomic, assign) NSInteger pageNo;

/// 分页总页数
@property(nonatomic, assign) NSInteger pages;

/// 列表
@property(nonatomic, strong) NSArray<JHRecycleSquareHomeListModel*> * resultList;

/// 排序
@property(nonatomic, assign) NSInteger sort;

@end


NS_ASSUME_NONNULL_END
