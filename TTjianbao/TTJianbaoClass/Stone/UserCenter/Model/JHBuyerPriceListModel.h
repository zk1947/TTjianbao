//
//  JHBuyerPriceListModel.h
//  TTjianbao
//  Description:用户-回血直播间-买家出价-列表 | 个人中心-买家出价-列表 
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"
#import "JHGoodsReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBuyerPriceDetailModel : NSObject

@property (nonatomic, strong) NSString* customerImg;// (string, optional): 用户头像 ,
@property (nonatomic, strong) NSString* customerName;// (string, optional): 用户名 ,
@property (nonatomic, strong) NSString* expireTime;// (string, optional): 失效时间 ,
@property (nonatomic, strong) NSString* offerPrice;// (number, optional): 出价 ,
@property (nonatomic, strong) NSString* offerTime;// (string, optional): 出价时间 ,
@property (nonatomic, strong) NSString* stoneRestoreOfferId;// (integer, optional): 回血出价单ID
@property (nonatomic, strong) NSString* stoneRestoreId;//仅为回传值使用
@property (nonatomic, strong) NSString* offerCustomerId;//暂时没用到: (integer, optional): 出价用户ID ,
@property (nonatomic, strong) NSString* offerCustomerStatus;// (string, optional): 用户出价状态: 1 原石-正在支付，用户-非被接受的用户 ; 按钮显示，置灰 | 2 原石-正在支付，用户-被接受的用户 ; 按钮隐藏，显示支付尾款 | 3 原石-上架中，用户-卖家未接受未拒绝 ; 按钮显示，可用 | 4 原石-上架中，用户-被拒绝的用户 ; 按钮显示，置灰 
@property (nonatomic, assign) NSInteger resaleFlag;//原石类型：0-原石回血、1-个人转售, 仅用于比较外层传递
@property (nonatomic, strong) NSString* salePrice;// 寄售价格：仅用于比较出价
@end

@interface JHBuyerPriceModel : NSObject

@property (nonatomic, strong) NSString* goodsCode;// (string, optional): 商品编码 ,
@property (nonatomic, strong) NSString* goodsTitle;// (string, optional): 商品标题 ,
@property (nonatomic, strong) NSString* goodsUrl;// (string, optional): 商品图片 ,
@property (nonatomic, strong) NSArray<JHBuyerPriceDetailModel*>* customerOfferList;// (Array[StoneRestoreOfferDetailListMySaleResponse], optional): 出价详情列表 ,
@property (nonatomic, strong) NSString* salePrice;// (number, optional): 寄售价格 ,
@property (nonatomic, strong) NSString* stoneRestoreId;// (integer, optional): 回血单ID
@property (nonatomic, strong) NSString* seekCount;// 求看人数 ?????
@property (nonatomic, strong) NSString* coverUrl;// 商品图片
@property (nonatomic, assign) NSInteger resaleFlag; // 原石类型：0-原石回血、1-个人转售
@end

@interface JHBuyerPriceListModel : JHGoodsRespModel

@property (nonatomic, strong) NSArray<JHBuyerPriceModel*>* stoneDetail;// (Array[StoneRestoreOfferListMySaleResponse], optional): 出售列表 ,
@property (nonatomic, strong) NSString* totalMsg;// (string, optional): 出售统计消息（服务端组装，可选） ,
@property (nonatomic, strong) NSString* totalNum;// (integer, optional): 出售原石数 ,
@property (nonatomic, strong) NSString* totalSalePrice;// (number, optional): 出售总价

@end

@interface JHBuyerPriceListReqModel : JHGoodsReqModel

@end

//用户-回血直播间-买家出价-拒绝
@interface JHBuyerRejectPriceReqModel : JHReqModel //无需返回model

@property (nonatomic, assign) NSInteger resaleFlag;//原石类型：0-原石回血、1-个人转售  TODO:Jesse add ???
@property (nonatomic, strong) NSString* stoneRestoreOfferId;// (integer): 原石回血出价单ID

+ (void)requestWithStoneModel:(JHBuyerPriceDetailModel*)priceModel finish:(JHFailure)failure;
@end

//用户-回血直播间-买家出价-接受
@interface JHAcceptBuyerPriceReqModel : JHReqModel //无需返回model

@property (nonatomic, strong) NSString* stoneRestoreOfferId;// (integer): 原石回血出价单ID
@end

//消息：新出价的人数

//通知后台已经阅读消息

NS_ASSUME_NONNULL_END
