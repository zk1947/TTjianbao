//
//  JHMyPriceListModel.h
//  TTjianbao
//  Description:用户-出价单列表-我的出价
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"
#import "JHGoodsReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyPriceDetailModel : NSObject

@property (nonatomic, strong) NSString* expireTime;// (string, optional): 失效时间 【只有offerState=2时,显示】
@property (nonatomic, strong) NSString* offerPrice;// (number, optional): 出价 ,
@property (nonatomic, assign) NSUInteger offerState;// (integer, optional): 出价状态 1-出价中(可取消)，2-待支付尾款 4-已拒绝(可重新出价) ,
@property (nonatomic, strong) NSString* stoneRestoreOfferId;// (integer, optional): 回血出价单ID

@property (nonatomic, assign) bool toPay;// true直接支付 false 确认订单

@end

@interface JHMyPriceListModel : JHGoodsRespModel

@property (nonatomic, strong) JHMyPriceDetailModel* offerDetail;// (StoneRestoreOfferDetailListMyBidResponse, optional): 出价详情 ,
@property (nonatomic, strong) NSString* seekCount;// 求看人数 ?????
@property (nonatomic, strong) NSString* salePrice;// (number, optional): 寄售价格 ,
@property (nonatomic, strong) NSString* stoneRestoreId;// (integer, optional): 回血单ID
@property (nonatomic, strong) NSString* orderId;// (integer, optional): 销售单ID ,
@property (nonatomic, strong) NSString* coverUrl;// 商品图片
@property (nonatomic, assign) NSInteger resaleFlag;//原石类型：0-原石回血、1-个人转售 TODO:Jesse add ???
@end

@interface JHMyPriceListReqModel : JHGoodsReqModel

@end

//用户-回血直播间-买家出价-拒绝
@interface JHMyCancelPriceReqModel : JHReqModel //无需返回model

@property (nonatomic, strong) NSString* stoneRestoreOfferId;// (integer): 原石回血出价单ID
@property (nonatomic, assign) NSInteger resaleFlag;//原石类型：0-原石回血、1-个人转售 TODO:Jesse add ???

+ (void)requestWithStoneModel:(JHMyPriceListModel*)stoneModel finish:(JHFailure)failure;
@end

NS_ASSUME_NONNULL_END
