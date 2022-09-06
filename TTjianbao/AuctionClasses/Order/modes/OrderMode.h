//
//  OrderMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/26.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoponPackageMode.h"
#import "TTjianbaoMarcoEnum.h"
#import "JHCustomizeFlyOrderCountCategoryModel.h"

@class OrderNoteMode;
@class OrderParentModel;
@class JHCustomizePackageCustomizeOrder;

@interface OrderMode : NSObject

//买家用户ID ,
@property (strong,nonatomic)NSString * buyerCustomerId;
//买家头像
@property (strong,nonatomic)NSString * buyerImg;
//买家 买家昵称
@property (strong,nonatomic)NSString * buyerName;

@property (strong,nonatomic)NSString * buyerReceivedTime;
@property (strong,nonatomic)NSString * goodsTitle;
@property (strong,nonatomic)NSString * goodsUrl;
@property (strong,nonatomic)NSString * orderCode;
@property (strong,nonatomic)NSString * onlyGoodsId;
@property (strong,nonatomic)NSString * payBatchLimit;
@property (strong,nonatomic)NSString * payBatchMin;
@property (strong,nonatomic)NSString * payedMoney;

@property (strong,nonatomic)NSString * orderCreateTime;
@property (strong,nonatomic)NSString * orderId;
@property (strong,nonatomic)NSString * orderPrice;
@property (strong,nonatomic)NSString * originOrderPrice;
@property (strong,nonatomic)NSString * appraisalGuidePrice;//指导价
@property (assign,nonatomic)NSInteger goodsCount;

@property (assign,nonatomic)NSInteger stock;///库存
///  秒杀商品最大购买数量
@property (assign,nonatomic)NSInteger seckillMaxNum;
/// 商品类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀
@property (assign,nonatomic)NSInteger showType;
@property (assign,nonatomic)BOOL isNewuGoods;///新人专区商品订单
//加工单优惠后金额
@property (strong,nonatomic)NSString * priceAfterDiscount;
//卖家券
@property (strong,nonatomic)NSString * sellerDiscountAmount;
//红包
@property (strong,nonatomic)NSString * discountAmount;

//津贴抵扣
@property (strong,nonatomic)NSString * bountyAmount;

//折扣活动抵扣
@property (strong,nonatomic)NSString * discountCouponAmount;

//现金津贴
@property (strong,nonatomic)NSString * usableBountyAmount;

@property (assign,nonatomic)BOOL haveReport;

@property (assign,nonatomic)CGFloat height;
//现金限额
@property (strong,nonatomic)NSString * limitBountyAmount;

//默认选中的券
@property (strong,nonatomic)NSString * sellerCouponId;
@property (strong,nonatomic)NSString * couponId;
@property (strong,nonatomic)NSString * discountCouponId;

//cancel 取消订单, buyerreceived 买家确认收货, portalsent 平台已发货（买家待收货） , waitportalsend 平台已鉴定（待发货） , waitportalappraise待鉴定（平台已收货） , sellersent卖家已发货（待平台收货）,waitsellersend 待卖家发货给平台（已支付）, paying 用户支付中（分次支付）
@property (strong,nonatomic)NSString * orderStatus;
@property (strong,nonatomic)NSString * orderStatusStr;
@property (assign,nonatomic)JHOrderStatus orderStatusType;

@property (strong,nonatomic)NSString * channelLocalId;
@property (assign,nonatomic)JHOrderType  orderType;//0是直播。1是社区 2是哄场订单  4是特卖
@property (strong,nonatomic)NSString * payExpireTime;
@property (strong,nonatomic)NSString * sellerSentExpireTime;

@property (strong,nonatomic)NSString * payTime;
@property (strong,nonatomic)NSString * portalSentTime;
@property (strong,nonatomic)NSString * sellerCustomerId;//卖家用户id
@property (strong,nonatomic)NSString * sellerImg;
@property (strong,nonatomic)NSString * sellerName;
@property (strong,nonatomic)NSString * sellerSentTime;
//价格前标签文案（专享价等）
@property (strong,nonatomic)NSString * priceTagName;

//平台收货时间
@property (strong,nonatomic)NSString * portalReceivedTime;

@property (assign,nonatomic)BOOL commentStatus;
//绑定保卡
@property (strong,nonatomic)NSString * barCode;
//地址
@property (strong,nonatomic)NSString * shippingProvince;
@property (strong,nonatomic)NSString * shippingCity;
@property (strong,nonatomic)NSString * shippingCounty;
@property (strong,nonatomic)NSString * shippingDetail;
@property (strong,nonatomic)NSString * shippingPhone;
@property (strong,nonatomic)NSString * shippingReceiverName;
@property (strong,nonatomic)NSString * channelStatus;//直播间装间直播间状态: 0：禁用； 1：空闲； 2：直播中； 3：直播录制


//认领订单增加字段
@property (strong,nonatomic)NSString *expressNumber;
@property (strong,nonatomic)NSString * goodsImg;
@property (assign,nonatomic)NSInteger isClaimed;
//🧧
@property (strong,nonatomic)NSArray <CoponMode*>*myCouponVoList;
//代金券
@property (strong,nonatomic)NSArray <CoponMode*>*mySellerCouponVoList;
//折扣活动
@property (strong,nonatomic)NSArray <CoponMode*>*discountAllCouponVoList;

//退货过期时间
@property (strong,nonatomic)NSString * refundExpireTime;
//退货状态描述
@property (strong,nonatomic)NSString * workorderDesc;
//退货至平台按钮是否显示
@property (assign,nonatomic)BOOL refundButtonShow;

//退货退款按钮是否显示
@property (assign,nonatomic)BOOL couldRefundShow;
//问题单按钮是否显示
@property (assign,nonatomic)BOOL problemShow;

@property (assign,nonatomic)BOOL problemBtn;

//申请定制按钮
@property (assign,nonatomic)BOOL customizedFlag;

//可定制订单标识
@property (assign,nonatomic)BOOL canCustomize;

@property (strong,nonatomic)NSString *orderDesc;//买家订单备注  在定制单中,变为定制个数描述
//发货提醒按钮是否显示
@property (assign,nonatomic)BOOL sendRemindButtonShow;
//修改地址按钮是否显示
@property (assign,nonatomic)BOOL changeCustomerAddressShow;

@property (strong,nonatomic)NSString *materialCost;//材料费
@property (strong,nonatomic)NSString *manualCost;//手工费
@property (strong,nonatomic)NSString *goodsPrice;//宝贝价格
@property (strong,nonatomic)NSString *parentOrderId;//加工服务单的父订单id

///订单分类normal("常规订单"),processingOrder("加工订单"),processingGoods("加工服务订单"),roughOrder("原石订单"),giftOrder("福利单"),daiGouOrder("代购订单"); mallAuctionOrder  的是b2c拍卖单
@property (strong,nonatomic)NSString *orderCategory;
//订单分类字符串
@property (strong,nonatomic)NSString *orderCategoryString;
//订单分类枚举
@property (assign,nonatomic)JHOrderCategory orderCategoryType;

/// 直播间品类 normal("常规直播间") roughOrder("原石直播间")
@property (strong,nonatomic)NSString *channelCategory;

/// 原石是否超额
@property (assign,nonatomic)BOOL overAmountFlag;
//评价按钮是否显示
@property (assign,nonatomic)BOOL commentStatusShow;
//删除按钮是否显示
@property (assign,nonatomic)BOOL deleteFlag;

@property (assign,nonatomic)BOOL resaling;///原石转售状态 0是未转售 1是转售中

@property (assign,nonatomic)BOOL resaleSupportFlag;//是否支持转售

@property (strong,nonatomic)OrderNoteMode *complementVo;

@property (strong,nonatomic)OrderParentModel *parentOrder;

@property (strong,nonatomic)NSString *processingDes;//加工描述;

@property (copy, nonatomic)NSString *subtractPrice;//  优惠金额
@property (copy, nonatomic)NSArray *couponValueList;//飞单推荐优惠券描述列表

@property (copy, nonatomic)NSString *price;//  飞单接收端显示的优惠后的实付价格

@property (copy, nonatomic)NSArray *buttons; ///底部按钮

@property (assign, nonatomic)BOOL isSeller; ///区分买家订单和卖家订单
@property (strong,nonatomic)NSString * orderStatusString;



@property (copy,nonatomic)NSString *goodsCateName;//原料类别
//定制类型：customizeType（0:不定制，1:0元定制） 2代表常规定制套餐类型
@property (assign,nonatomic)int customizeType;
@property (copy,nonatomic)NSString  *customizeTypeOrderRemark;//关联订单提示

@property (copy,nonatomic)NSString *downExpiredTime;//倒计时到期时间
@property (copy,nonatomic)NSString *downExpiredCopy;//倒计时结束文案
@property (assign, nonatomic)BOOL isDownExpired; //倒计时时间是否过期

/** 支付成功展示类型 0 普通支付成功展示 1 引导定制展示 2 需要上门取件展示 3 组合订单展示*/
@property (nonatomic, copy)NSString *paymentSuccessShowType;
/** 平台呼出客服电话*/
@property (nonatomic, copy)NSString *platformServiceDialTelStr;
/** 平台客服电话*/
@property (nonatomic, copy)NSString *platformServiceTelStr;
/** 平台客服工作时间段*/
@property (nonatomic, copy)NSString *platformServiceWorkTimeStr;
/** 防疫提示内容*/
@property (nonatomic, copy)NSString *keepEpidemicWarnDesc;
/** 定制套餐中原料单支付成功提示*/
@property (nonatomic, copy)NSString *onlyNormalPayedDesc;
/** 接下来将要支付的订单id*/
@property (nonatomic, copy)NSString *nextOrderId;

//税费
@property (nonatomic, copy)NSString *taxes;
//运费
@property (nonatomic, copy)NSString *freight;

//是否跳转优先支付订单
@property (nonatomic, assign)BOOL isSkipBeforeOrderId;
//优先支付订单状态
@property (nonatomic, copy)NSString *beforeOrderStatus;
//优先支付订单id
@property (nonatomic, copy)NSString *beforeOrderId;

/// 新增定制套餐相关
@property (nonatomic,   copy) NSString *customizePackageExplain;
@property (nonatomic, strong) JHCustomizePackageCustomizeOrder *customizeOrder;

/// 新增直发
@property (nonatomic, assign) BOOL directDelivery;
// 商家直发 订单动态文案
@property (nonatomic, copy)NSString *orderStatusTips;
/// 新增直发查看物流按钮显示逻辑
@property (nonatomic, assign) BOOL viewExpressBtnFlag;

@property (strong,nonatomic)NSString *source;//3-福袋福利单、非3其他单

/// 订单状态
/// @param orderStatus orderStatus description
+(NSString*)orderStatusStrExt:(NSString*)orderStatus;
+(NSString*)orderStatusExt:(NSString*)orderStatus isBuyer:(BOOL)isBuyer;

- (NSString*)orderStatusExt:(NSString*)orderStatus isBuyer:(BOOL)isBuyer;
/// 订单类型字符串 转 枚举
/// @param orderCategory orderCategory description
+(JHOrderCategory)orderCategoryTypeConvert:(NSString*)orderCategory;
@end


/**
 备注
 */
@interface OrderNoteMode : NSObject

@property (strong,nonatomic)NSArray * pics;
@property (strong,nonatomic)NSString * remark;
@property (strong,nonatomic)NSString * goodsCateId;//种类
@property (strong,nonatomic)NSString * goodsCateValue;//
@property (strong,nonatomic)NSString * goodsTypeId;//品类
@property (strong,nonatomic)NSString * goodsTypeValue;//
@property (strong,nonatomic)NSString * giftCount;//赠品数量
@property (strong,nonatomic)NSString * mainCount;// 主品数量
@property (strong,nonatomic)NSArray * statement;// 特别声明
@property (strong,nonatomic)NSString * goodsName;
@end

/**
 传备注照片mode
 */
@interface OrderPhotoMode : NSObject
@property (strong,nonatomic)NSString * url;
@property (strong,nonatomic)UIImage * image;
@property (assign,nonatomic)BOOL showAddButton;
@end

/**
 订单搜索
 */
@interface OrderSearchParamMode : NSObject
@property (strong,nonatomic)NSString * orderCode;
@property (strong,nonatomic)NSString * customerName;
@property (strong,nonatomic)NSString * startTime;
@property (strong,nonatomic)NSString * endTime;
@property (strong,nonatomic)NSString * searchStatus;
@property (strong,nonatomic)NSString * minPrice;
@property (strong,nonatomic)NSString * maxPrice;

@end
/**
 订单代付分享信息
 */
@interface OrderAgentPayShareMode : NSObject
@property (strong,nonatomic)NSString * pic;
@property (strong,nonatomic)NSString * summary;
@property (strong,nonatomic)NSString * targetUrl;
@property (strong,nonatomic)NSString * title;
@end

/**
 好友代付信息
 */
@interface OrderFriendAgentPayMode : NSObject
@property (strong,nonatomic)NSString * cash;
@property (strong,nonatomic)NSString * createTime;
@property (strong,nonatomic)NSString * expireTime;
@property (assign,nonatomic)int  payResult;//支付结果 //0 初始化，1 成功，2 失效 
@property (strong,nonatomic)NSString * payTime; //支付时间
@property (strong,nonatomic)NSString * payChannelName; //支付渠道 ,

@property (strong,nonatomic)NSString * pic;
@property (strong,nonatomic)NSString * summary;
@property (strong,nonatomic)NSString * targetUrl;
@property (strong,nonatomic)NSString * title;
@end

@interface OrderParentModel : JHResponseModel
@property (strong,nonatomic)NSString *Id;

@property (strong,nonatomic)NSString *orderCode;
@property (strong,nonatomic)NSString *orderCreateTime;
/** 商品标题*/
@property (strong,nonatomic)NSString *goodsTitle;

/** 商品图片*/
@property (strong,nonatomic)NSString *goodsUrl;
@property (strong,nonatomic)NSString * goodsImg;

@property (strong,nonatomic)NSString *originOrderPrice;
/**
 * 订单状态
 */
@property (strong,nonatomic)NSString *orderStatus;
@end



/// 定制套餐相关
@interface JHCustomizePackageCustomizeOrder : NSObject
@property (nonatomic,   copy) NSString *orderCode;
@property (nonatomic,   copy) NSString *originOrderPrice;
@property (nonatomic,   copy) NSString *goodsTitle;
@property (nonatomic, assign) NSInteger IDD;

@end
