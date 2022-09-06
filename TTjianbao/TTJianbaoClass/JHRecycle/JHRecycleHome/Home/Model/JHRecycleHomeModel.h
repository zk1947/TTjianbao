//
//  JHRecycleHomeModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//商品图片信息
@interface JHRecycleHomeProductImageModel : NSObject
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

///回收分类
@interface JHHomeRecycleCategoryListModel : NSObject
/** 商品分类名 */
@property (nonatomic, copy) NSString *btnDesc;
/** 按钮类型 */
@property (nonatomic, copy) NSString *btnType;
/** 分类对应编码 money（钱币）,gold(黄金),diamond（钻石）*/
@property (nonatomic, copy) NSString *code;
/** 类型 1 H5 2 原生 */
@property (nonatomic, copy) NSString *type;
/** 跳转链接 */
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSDictionary *baseImage;
@end


///订单信息列表
@interface JHHomeOrderInfoListModel : NSObject
/** 商品描述 */
@property (nonatomic, copy) NSString *productDesc;
/** 出价金额 */
@property (nonatomic, copy) NSString *bidPrice;
/** 商品状态 - 8:待确认报价，19:待发货 */
@property (nonatomic, assign) NSInteger productStatus;
/** 商品ID */
@property (nonatomic, copy) NSString *productId;
/** 订单ID */
@property (nonatomic, copy) NSString *orderId;
/** 商品图片 */
@property (nonatomic, strong) JHRecycleHomeProductImageModel *productImage;

@end


///运营位
@interface PositionTargetModel : NSObject
@property (nonatomic, copy)NSString *componentName;
@property (nonatomic, copy)NSString *vc;//专题专区点击返回
@property (nonatomic, strong)NSMutableDictionary *params;
@end
@interface JHHomeOperatingPositionModel : NSObject
/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrl;
/** 运营位ID */
@property (nonatomic, copy) NSString *detailsId;
/** 跳转地址 */
@property (nonatomic, copy) NSString *landingTarget;
@property (nonatomic, strong) PositionTargetModel *target;
@end


///回收直播
@interface JHHomeRecycleLiveListModel : NSObject
/** 主播名称 */
@property (nonatomic, copy) NSString *anchorName;
/** 主播头像 */
@property (nonatomic, copy) NSString *anchorImg;
/** 直播间id */
@property (nonatomic, copy) NSString *liveId;
/** 直播图片 */
@property (nonatomic, copy) NSString *liveImage;
/** 直播间状态 0：禁用； 1：空闲； 2：直播中； 3：直播录制*/
@property (nonatomic, copy) NSString *liveStatus;
/** 观看人数*/
@property (nonatomic, copy) NSString *viewers;
@property (nonatomic, copy) NSString *watchTotalString;
@end


///热门回收商品
@interface JHHomeHotRecycleProductsListModel : NSObject
/** 商品分类id */
@property (nonatomic, copy) NSString *productCateId;
/** 商品类别名称 */
@property (nonatomic, copy) NSString *productCateName;
/** 商品id */
@property (nonatomic, copy) NSString *productId;
/** 商品图片 */
@property (nonatomic, strong) JHRecycleHomeProductImageModel *productImage;
/** 商品价格 */
@property (nonatomic, copy) NSString *recycleHighPrice;
/** 回收是否成功 0否 1是 */
@property (nonatomic, assign) BOOL recycleSuccessType;
@end


///常见问题
@interface JHHomeRecycleHelpArticleListModel : NSObject
/** 问题标题 */
@property (nonatomic, strong) NSString *title;
/** 问题id */
@property (nonatomic, copy) NSString *ID;
@end



@interface JHRecycleHomeModel : NSObject

/** 回收分类 */
@property (nonatomic, strong) NSArray<JHHomeRecycleCategoryListModel *> *recycleCategoryList;
/** 订单信息列表 */
@property (nonatomic, strong) NSArray<JHHomeOrderInfoListModel *> *orderInfoList;
/** 运营位一 */
@property (nonatomic, strong) JHHomeOperatingPositionModel *operatingPositionOne;
/** 回收直播 */
@property (nonatomic, strong) NSArray<JHHomeRecycleLiveListModel *> *recycleLiveList;
/** 运营位二 */
@property (nonatomic, strong) JHHomeOperatingPositionModel *operatingPositionTwo;
/** 热门回收商品 */
@property (nonatomic, strong) NSArray<JHHomeHotRecycleProductsListModel *> *productAggVOList;
/** 运营位三 */
@property (nonatomic, strong) JHHomeOperatingPositionModel *operatingPositionThree;
/** 常见问题 */
@property (nonatomic, strong) NSArray<JHHomeRecycleHelpArticleListModel *> *recycleHelpArticleList;
//累计回收数
@property (nonatomic, strong) NSString *productCount;

@end





@interface JHRecycleHomeGetRecyclePlateModel : NSObject
/// 直播回收描述：与回收商连麦实时聊价
@property (nonatomic, copy) NSString *channelDesc;
/// 直播回收图标
@property (nonatomic, copy) NSString *channelIcon;
/// 直播回收图标标签，动效
@property (nonatomic, copy) NSString *channelIconTag;
/// 直播回收标题：直播回收
@property (nonatomic, copy) NSString *channelTitle;
/// 图文回收描述：多回收商出价，选高价卖
@property (nonatomic, copy) NSString *imageTextDesc;
///  图文回收图标
@property (nonatomic, copy) NSString *imageTextIcon;
///  图文回收图标标签，动效
@property (nonatomic, copy) NSString *imageTextIconTag;
/// 图文回收标题：图文回收
@property (nonatomic, copy) NSString *imageTextTitle;
/// 统计提示：已回收钱币、黄金、钻石543328件
@property (nonatomic, copy) NSString *statisticsTip;
/// 标题：天天回收
@property (nonatomic, copy) NSString *title;
@end






NS_ASSUME_NONNULL_END
