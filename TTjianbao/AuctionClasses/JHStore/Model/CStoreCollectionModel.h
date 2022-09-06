//
//  CStoreCollectionModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  我的收藏数据
//

#import "YDBaseModel.h"

@class CStoreCollectionData;
@class CStoreCollectionCoverImageInfo;

NS_ASSUME_NONNULL_BEGIN

@interface CStoreCollectionModel : YDBaseModel

@property (nonatomic, strong) NSMutableArray<CStoreCollectionData *> *list;

- (NSString *)toUrl;
- (NSString *)toSearchUrl;
- (void)configModel:(CStoreCollectionModel *)model;

@end


#pragma mark -
#pragma mark - CStoreCollectionData

@interface CStoreCollectionData : NSObject
@property (nonatomic, copy) NSString *goods_id; //商品id
@property (nonatomic, copy) NSString *original_goods_id; //新接口商品id 仅用于统计 add 2020.06.05
@property (nonatomic, assign) NSInteger seller_id; //int 商家ID
@property (nonatomic, assign) NSInteger status; //商品状态 【0 待发布 2 已上架 3 已下架 4 已售出】
@property (nonatomic,   copy) NSString *name; //string 商品名字
@property (nonatomic,   copy) NSString *desc; //商品描述
@property (nonatomic,   copy) NSString *store_name; //店铺名称
@property (nonatomic,   copy) NSString *orig_price; //原价
@property (nonatomic,   copy) NSString *market_price; //售价
@property (nonatomic,   copy) NSString *discount; //折扣
@property (nonatomic,   copy) NSString *flash_sale_tag; //限时购标签
@property (nonatomic, assign) BOOL has_video; //是否有视频
@property (nonatomic, strong) CStoreCollectionCoverImageInfo *coverImgInfo; //商品封面图（对应接口参数：cover_img）
///自定义属性：图片高度
@property (nonatomic, assign) CGFloat imgHeight;
@end


#pragma mark -
#pragma mark - CStoreCollectionCoverImageInfo

@interface CStoreCollectionCoverImageInfo : NSObject
@property (nonatomic, assign) NSInteger type; ///封面类型，1图片 2视频
@property (nonatomic, assign) CGFloat width; ///图片宽度
@property (nonatomic, assign) CGFloat height; ///图片高度
@property (nonatomic,   copy) NSString *imgUrl; ///图片或视频 ，封面图地址（对应服务端接口返回参数：url）
@end

NS_ASSUME_NONNULL_END
