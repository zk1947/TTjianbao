//
//  JHRecycleMeAttentionModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleUploadSeleteTypeModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface JHRecycleMeAttentionListModel : NSObject

/// 分类名称
@property(nonatomic, copy) NSString * categoryName;

/// 商品三级分类id
@property(nonatomic, assign) NSInteger categoryThirdId;

/// 商品ID
@property(nonatomic, copy) NSString *productId;

/// 图片
@property(nonatomic, strong) NSArray<JHRecycleUploadImageInfoModel*> * images;

/// 商品名称
@property(nonatomic, copy) NSString * productName;

/// 商品成交价格
@property(nonatomic, strong) NSNumber * productPrice;

/// 商品编码
@property(nonatomic, copy) NSString * productSn;

/// 商品状态
@property(nonatomic, assign) NSInteger productStatus;

/// 商品状态名称
@property(nonatomic, copy) NSString * productStatusDesc;

/// 小贴士
@property(nonatomic, copy) NSString * tips;

/// 商品状态名称
@property(nonatomic, copy) NSString * productDesc;

@end



@interface JHRecycleMeAttentionModel : NSObject

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
@property(nonatomic, strong) NSArray<JHRecycleMeAttentionListModel*> * resultList;

/// 排序
@property(nonatomic, assign) NSInteger sort;

@end

NS_ASSUME_NONNULL_END
