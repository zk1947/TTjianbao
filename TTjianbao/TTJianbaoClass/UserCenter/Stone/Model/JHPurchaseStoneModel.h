//
//  JHPurchaseStoneModel.h
//  TTjianbao
//  Description:用户-个人中心-买入原石列表、寄回订单、原石订单
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"
#import "JHReqModel.h"

typedef NS_ENUM(NSUInteger, JHPurchaseType)
{
    JHPurchaseTypeDefault,
    JHPurchaseTypeCut,
    JHPurchaseTypeSplit,
};

typedef NS_ENUM(NSUInteger, JHStonePageType) {
    JHStonePageTypePurchase, //买入原石
    JHStonePageTypeStoneOrder,//原石订单
    JHStonePageTypeSendOrder,//寄回订单
};

NS_ASSUME_NONNULL_BEGIN

@interface JHPurchaseStoneListAttachmentModel : NSObject

@property (nonatomic, strong) NSString* attachmentType;// (string): 附件类型：0-未定义，1-图片，2-视频 ,
@property (nonatomic, strong) NSString* coverUrl;// (string, optional): 图片或视频显示用的覆盖图
@property (nonatomic, strong) NSString* url;// (string): 观看图片或视频的地址
@end

@interface JHPurchaseStoneListModel : JHGoodsRespModel

@property (nonatomic, strong) NSArray<JHPurchaseStoneListAttachmentModel*>* attachmentList;// (Array[原石附件返回], optional): 附件列表 ,
@property (nonatomic, strong) NSArray<JHPurchaseStoneListModel*>* children;// (Array[StoneRestoreOrderResponse], optional): 子订单，只有当加工方式是已拆单的时候才有子订单 ,
@property (nonatomic, strong) NSString* orderStatus;// (string, optional): 订单状态：cancel 取消订单, buyerreceived 买家确认收货, portalsent 平台已发货（买家待收货）, waitportalsend 平台已鉴定（待发货） , waitportalappraise待鉴定（平台已收货） , sellersent卖家已发货（待平台收货）,waitsellersend 待卖家发货给平台（已支付）, paying 用户支付中（分次支付） , waitpay 待用户支付，waitack 待用户确认,refunding 退货退款中 refunded 退货完成，completion 订单完成，onsale 待寄售，sale 寄售
@property (nonatomic, strong) NSString* processMode;// (string, optional): 拆单方式：0-无定义、1-寄回、2-寄售、3-加工 = ['NONE', 'WINDOW', 'PEEL', 'SLICE', 'PRODUCT'],
@property (nonatomic, strong) NSString* salePrice;// (number, optional): 寄售价格 ,
@property (nonatomic, strong) NSString* stoneId;// (integer, optional): 回血原石ID ,
@property (nonatomic, strong) NSString* transitionState;// (string, optional): 流转状态：0-初始、1-寄回、2-寄售、3-加工、4-拆单 = ['INIT', 'SEND', 'SALE', 'PROCESS', 'SPLIT']
@property (nonatomic, strong) NSString* workorderDesc;//refunding 退货退款中 refunded 退货完成 ,这两种状态时，转成此字段
@property (nonatomic, strong) NSString* orderId;
@property (nonatomic, strong) NSString* orderCategory;//订单类别,订单详情使用
@property (nonatomic, strong) NSString* splitMode;//拆单方式：0-无定义、1-寄回、2-寄售、3-加工
@property (nonatomic, strong) NSString* resaleButtonText;// 转售按钮文本：转售/转售中 ,
@property (nonatomic, assign) NSInteger resaleFlag;//原石类型：0-原石回血、1-个人转售 TODO:Jesse add ???
@property (nonatomic, assign) NSInteger resaleStatus;//转售状态[除了2都是转售状态]：1-待转售，2-转售中，2-已售出 ,
@end

@interface JHPurchaseStoneListReqModel : JHReqModel

@property (nonatomic, assign) NSUInteger pageIndex; //第几页
@property (nonatomic, assign) NSUInteger pageSize; //每页几条
@end

//原石订单
@interface JHStoneOrderListModel : JHPurchaseStoneListModel

@property (nonatomic, strong) NSString* buyerIcon;// (string, optional): 买家头像 ,
@property (nonatomic, strong) NSString* buyerName;// (string, optional): 买家名称 ,
@property (nonatomic, strong) NSString* sellerIcon;// (string, optional): 卖家头像 ,
@property (nonatomic, strong) NSString* sellerName;// (string, optional): 卖家名称 ,

@end

//原石订单
@interface JHStoneOrderListReqModel : JHPurchaseStoneListReqModel

@end

//寄回订单
@interface JHSendOrderListModel : JHPurchaseStoneListModel

@property (nonatomic, strong) NSString* buyerIcon;// (string, optional): 买家头像 ,
@property (nonatomic, strong) NSString* buyerName;// (string, optional): 买家名称 ,
@property (nonatomic, strong) NSString* depositoryLocationCode;// (string, optional): 货架号 ,

@end

//寄回订单
@interface JHSendOrderListReqModel : JHPurchaseStoneListReqModel

@end

@protocol JHPurchaseStoneModelDelegate <NSObject>

@optional
- (void)responseData:(NSArray*)dataArray error:(NSString*)errorMsg;

@end

@interface JHPurchaseStoneModel : NSObject

@property (nonatomic, weak) id <JHPurchaseStoneModelDelegate>delegate;
@property (nonatomic, strong) NSMutableArray* dataArray;

- (void)requestWithType:(JHStonePageType)pageType pageIndex:(NSUInteger)pageIndex;

//类型转换
+ (NSString*)typeFromOrderStatus:(NSString*)status;
+ (NSString*)typeFromTransitionState:(NSString*)state;
+ (NSString*)typeFromSplitState:(NSString*)state;
//根据state转成JHPurchaseType
+ (JHPurchaseType)PurchaseTypeFromState:(NSString*)transitionState;
@end

NS_ASSUME_NONNULL_END
