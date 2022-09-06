//
//  JHMarketHomeModel.h
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMarketHomeKingKongItemModel;
@class JHMarketHomeKingKongTargetModel;
@class JHMarketHomeSpecialItemModel;

@interface JHMarketHomeModel : NSObject

@property (nonatomic, strong) NSArray <JHMarketHomeKingKongItemModel *>*operationSubjectList;
@property (nonatomic, strong) NSArray <JHMarketHomeSpecialItemModel *>*operationPosition;

@end

@interface JHMarketHomeSearchWordListItemViewModel : NSObject

@property (nonatomic, copy) NSString *productName;///

@end

/**
 金刚位model
 */
@interface JHMarketHomeKingKongItemModel : NSObject

@property (nonatomic, strong) JHMarketHomeKingKongTargetModel *target;///落地页数据

@property (nonatomic, copy) NSString *corner;///角标图片

@property (nonatomic, assign) int isShow;

@property (nonatomic, assign) int code;///编码

@property (nonatomic, copy) NSString *landingName;/// 类型

@property (nonatomic, copy) NSString *operationSubjectId; ///专题Id

@property (nonatomic, copy) NSString *name;///专题名称

@property (nonatomic, copy) NSString *icon;///图标

@end

/**
 金刚位target
 */
@interface JHMarketHomeKingKongTargetModel : NSObject

@property (nonatomic, copy) NSString *vc;

@property (nonatomic, assign) int componentType;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *componentName;

@end


/**
 专题model
 */
@interface JHMarketHomeSpecialItemModel : NSObject

@property (nonatomic, copy) NSString *moreHotImgProportion;//图片占比 A:B:C 总和为10

@property (nonatomic, assign) int definiLocation;//直播列表展示位置 0 不展示

@property (nonatomic, copy) NSString *operationDefiniId;//运营位主题id

@property (nonatomic, copy) NSString *moreHotImgUrl;//多触点图片地址

@property (nonatomic, assign) int definiType;//运营位类型：1:单图 2:多图平铺 3:轮播图 4:背景图 5:单图多触点

@property (nonatomic, assign) int definiSerial;//运营位序号

@property (nonatomic, assign) int interSpace;//是否留白 0 否；1 是

@property (nonatomic, assign) int height;//高

@property (nonatomic, assign) int width;//宽

@property (nonatomic, strong) NSArray *definiDetails;//落地页集合

@end

/**
 专题子一级model
 */
@interface JHMarketHomeSpecialSubItemModel : NSObject

@property (nonatomic, copy) NSString *landingTarget;//落地页目标

@property (nonatomic, copy) NSString *targetName;//落地页类型名称

@property (nonatomic, copy) NSString *detailsId;//运营位栏位id

@property (nonatomic, copy) NSString *imageUrl;//图片素材地址

@property (nonatomic, copy) NSString *landingId;//落地页关联参数

@end

/**
 专题子二级model
 */
@interface JHMarketHomeSpecialSubTowItemModel : NSObject

@property (nonatomic, assign) int componentType;

@property (nonatomic, copy) NSString *vc;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *componentName;

@end

/**
 商品model
 */
@interface JHMarketHomeGoodsListItemModel : NSObject



@end

/**
 社区讨论model
 */
@interface JHMarketHomeHotTopItemModel : NSObject

@property (nonatomic, copy) NSString *item_id;//帖子id

@property (nonatomic, copy) NSString *title;//标题

@property (nonatomic, copy) NSString *item_type;//帖子类型 30 文章 20 动态 40 视频

@property (nonatomic, copy) NSString *image;//图片

@end

/**
 竞拍、收藏状态
 */
@interface JHMarketHomeLikeStatusModel : NSObject

@property (nonatomic, assign) int auctionResult;

@property (nonatomic, assign) int num;

@end

NS_ASSUME_NONNULL_END
