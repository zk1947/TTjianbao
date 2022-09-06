//
//  JHSendOrderModel.h
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
//"anchorId": 0,
//"barCode": "string",
//"channelCategory": "string",
//"goodsImg": "string",
//"goodsName": "string",
//"goodsPrice": 0,
//"inputManual": 0,
//"manualCost": 0,
//"materialCost": 0,
//"onlyGoodsId": "string",
//"orderCancelTime": "string",
//"orderCategory": "normal",
//"orderCodePre": "string",
//"orderDesc": "string",
//"orderPrice": 0,
//"orderType": 0,
//"originOrderPrice": "string",
//"parentOrderId": 0,
//"secondOrderType": 0,
//"shopOrderPrice": 0,
//"sign": "string",
//"timestamp": 0,
//"viewerId": 0

@interface JHSendOrderModel : NSObject

@property (strong,nonatomic)NSString *channelId;
@property (strong,nonatomic)NSString *goodsImg;
@property (strong,nonatomic)NSString *orderPrice;
//0 普通订单 1社区订单 2哄场单  定制单 ： 7
@property (strong,nonatomic)NSNumber *orderType;
//Id //normal 加工单 加工服务单 赠品
@property (strong,nonatomic)NSString *orderCategory;
@property (strong,nonatomic)NSString *barCode;
@property (strong,nonatomic)NSString *viewerId;
//竞拍id
@property (strong,nonatomic)NSString *biddingId;
//是否手动输入宝卡号
@property (strong,nonatomic)NSString *inputManual;
@property (strong,nonatomic)NSString *anchorId;

@property (strong,nonatomic)NSString *channelCategory;
@property (strong,nonatomic)NSString *originOrderPrice;
@property (strong,nonatomic)NSString *orderDesc;

@property (strong,nonatomic)NSString *processingDes;//加工描述;
@property (strong,nonatomic)NSString *materialCost;//材料费
@property (strong,nonatomic)NSString *manualCost;//手工费
@property (strong,nonatomic)NSString *goodsPrice;//宝贝价格
@property (strong,nonatomic)NSString *parentOrderId;//加工服务单的父订单id
@property (strong,nonatomic)NSString *goodsCateId;//类别id
@property (strong,nonatomic)NSArray* customizeFeeList;//定制个数json串
@property (strong,nonatomic)NSString *sm_deviceId;
//定制类型：customizeType（0:不定制，1:0元定制）
@property (strong,nonatomic)NSString *customizeType;
/// 新增
@property (strong,nonatomic)NSString *anewGoodsCateId;//新飞单类别id

@end

NS_ASSUME_NONNULL_END
