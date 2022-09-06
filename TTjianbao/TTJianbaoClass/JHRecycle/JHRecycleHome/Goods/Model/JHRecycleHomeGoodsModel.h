//
//  JHRecycleHomeGoodsModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///商品图片信息
@interface JHRecycleHomeGoodsResultProductImageModel : NSObject
/** 大图 */
@property (nonatomic, copy) NSString *big;
/** 小图 */
@property (nonatomic, copy) NSString *medium;
/** 原图 */
@property (nonatomic, copy) NSString *origin;
/** 缩略图 */
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *w;
@property (nonatomic, copy) NSString *h;

@end


///商品信息
@interface JHRecycleHomeGoodsResultListModel : NSObject
/** 商品ID */
@property (nonatomic, copy) NSString *productId;
/** 商品分类ID */
@property (nonatomic, copy) NSString *productCateId;
/** 商品分类名 */
@property (nonatomic, copy) NSString *productCateName;
/** 回收价格 */
@property (nonatomic, copy) NSString *recyclePrice;
/** 回收是否成功 0否 1是 */
@property (nonatomic, assign) BOOL recycleSuccessType;
/** 图片信息 */
@property (nonatomic, strong) JHRecycleHomeGoodsResultProductImageModel *productImage;

@end


@interface JHRecycleHomeGoodsModel : NSObject

/** 生成当前页最后一条记录的信息 */
@property (nonatomic, copy) NSString *cursor;
/** 是否有下一页 */
@property (nonatomic, assign) BOOL hasMore;
/** 分页总数 */
@property (nonatomic, copy) NSString *pages;
/** 排序 默认0 */
@property (nonatomic, copy) NSString *sort;
/** 回收直播 */
@property (nonatomic, strong) NSArray<JHRecycleHomeGoodsResultListModel *> *resultList;

@end

NS_ASSUME_NONNULL_END
