//
//  CGoodsDetailModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  商品详情数据
//

#import "YDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CGoodsInfo;
@class CGoodsImgInfo; //图片资源信息
@class CGoodsAttrData; //商品参数
@class CShopInfo; //商家店铺信息
@class JHShareInfo; //分享信息

/*!
 * header  - CGodsInfo：头部轮播图<headImgList>、钱数/倒计时、商品名、商品描述
 *       - CShopInfo：店铺信息
 *       - safeHeadImgInfo：店铺信息下面的保障图
 */

#pragma mark -
#pragma mark - 详情数据模型
@interface CGoodsDetailModel : YDBaseModel

@property (nonatomic, strong) CGoodsInfo *goodsInfo; //商品信息 <goods_info>
@property (nonatomic, strong) CShopInfo *shopInfo; //店铺信息 <seller_info>
@property (nonatomic, strong) NSMutableArray *pay_msg; //弹幕信息<字符串数组>

@end

/*
 商品状态 [0待发布 1待上架 2 已上架 3 已下架 4 已售出 5待审核 6特卖中]
 活动状态 [ 11 提醒我，12 已设提醒, 13 已结束]

 */
typedef NS_ENUM(NSInteger, JHGoodsStatus) {
    JHGoodsStatusWaitPublish = 0,           ///待发布
    JHGoodsStatusWaitGrounding = 1,         ///待上架
    JHGoodsStatusAlreadyGrounding = 2,      ///已上架
    JHGoodsStatusOutOfStock = 3,            ///已下架
    JHGoodsStatusSelled = 4,                ///已售出 已结缘
    JHGoodsStatusRemindMe = 11,             ///提醒我
    JHGoodsStatusSetReminded = 12,          ///已设提醒
    JHGoodsStatusSellEnd = 13,              ///已结束
};


#pragma mark -
#pragma mark - 商品信息
@interface CGoodsInfo : NSObject
@property (nonatomic,   copy) NSString *goods_id;       //商品id
@property (nonatomic,   copy) NSString *original_goods_id; //新接口商品id 仅用于统计 add 2020.06.05
@property (nonatomic,   copy) NSString *name;           //商品名
@property (nonatomic,   copy) NSString *desc;           //商品描述
@property (nonatomic,   copy) NSString *tag_name;       //标签名称
@property (nonatomic, assign) NSInteger seller_id;      //商家id
@property (nonatomic, assign) NSInteger sell_stat;      //售卖状态 [1下单购买 , 2 咨询购买]
@property (nonatomic, assign) NSInteger sell_type;      //商品类型 0非特卖(普通商品)，1限时特卖
@property (nonatomic, assign) JHGoodsStatus status;     //商品状态
@property (nonatomic,   copy) NSString *provider;       //供应商
@property (nonatomic, assign) BOOL is_collected;        //是否已收藏
@property (nonatomic,   copy) NSString *orig_price;     //原始价格
@property (nonatomic,   copy) NSString *market_price;   //当前市场价
@property (nonatomic,   copy) NSString *discount;       //打几折
@property (nonatomic, strong) NSNumber *server_at;      //服务器当前时间戳
@property (nonatomic, strong) NSNumber *offline_at;     //倒计时结束时间戳
///2.5新增字段
@property (nonatomic, strong) NSNumber *online_at;     //倒计时开始时间戳
@property (nonatomic,   copy) NSString *flash_sale_tag; //限时购标签
@property (nonatomic, assign) NSInteger item_type;
@property (nonatomic, assign) NSInteger layout;

///新人专享属性
@property (nonatomic, assign) NSInteger act_is_sale; //1 可购买 2 不可购买
@property (nonatomic,   copy) NSString *act_sale_msg; //非新用户不可购买
@property (nonatomic, assign) NSInteger act_type; //1新人专享，其他值-非新人专享

@property (nonatomic, strong) CGoodsImgInfo *coverImgInfo; //封面图 <cover_img>
@property (nonatomic, strong) CGoodsImgInfo *safeHeadImgInfo; //店铺信息<进店>底部4个横向排列保障图 <safeguard_head>
@property (nonatomic, strong) CGoodsImgInfo *safeBottomImgInfo; //底部保障图 <safeguard_bottom>
@property (nonatomic, strong) JHShareInfo *shareInfo; //分享信息 <share_info>
@property (nonatomic, strong) NSMutableArray<CGoodsImgInfo *> *headImgList; //头部轮播图数据 <head_res>
@property (nonatomic, strong) NSMutableArray<CGoodsAttrData *> *attrList; //商品参数列表 <attr>
@property (nonatomic, strong) NSMutableArray<CGoodsImgInfo *> *detailImgList; //参数列表下面的图片 <detail_res>

///2.5新增字段
@property (nonatomic, copy) NSString *flash_sale_tips;  //价格标签右侧显示的文字 购买状态
@property (nonatomic, copy) NSString *order_goods_id;   //下单使用的id
@property (nonatomic, copy) NSString *stock;            //商品库存

///2.5新增的自定义属性
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat descHeight;
@property (nonatomic, assign) BOOL isBeginSeckill;   ///默认没有


@end

#pragma mark -
#pragma mark - 图片资源信息
@interface CGoodsImgInfo : NSObject
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic,   copy) NSString *url; //视频封面或图片地址<缩略图>
@property (nonatomic,   copy) NSString *orig_image; //视频封面或图片地址<原图>
@property (nonatomic,   copy) NSString *video_url; //视频地址
///资源类型 [1 图片 , 2 视频]
@property (nonatomic, assign) NSInteger type;

- (CGFloat)imageHeight;
@end


#pragma mark -
#pragma mark - 商品参数
@interface CGoodsAttrData : NSObject
@property (nonatomic,   copy) NSString *name;   //参数名
@property (nonatomic,   copy) NSString *value;  //参数值
@end


#pragma mark -
#pragma mark - 商家店铺信息
@interface CShopInfo : NSObject
@property (nonatomic, assign) NSInteger seller_id; //商家id
@property (nonatomic,   copy) NSString *like_num; //点赞数
@property (nonatomic,   copy) NSString *fans_num; //粉丝数
@property (nonatomic, assign) NSInteger fans_num_int; //粉丝数 int型
@property (nonatomic,   copy) NSString *name; //店铺名
@property (nonatomic,   copy) NSString *head_img; //店铺logo
@property (nonatomic,   copy) NSString *bg_img; //《没用到》
@property (nonatomic,   copy) NSString *desc; //店铺简介《没用到》
@property (nonatomic,   copy) NSString *onsale_desc; //在售商品0件
@property (nonatomic,   copy) NSString *publish_num; //在售商品数（100件）《没用到》

@end


NS_ASSUME_NONNULL_END
