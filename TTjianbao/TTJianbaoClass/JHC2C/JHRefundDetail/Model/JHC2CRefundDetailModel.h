//
//  JHC2CRefundDetailModel.h
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///商品图
@interface JHApplyRefundImageModel : NSObject
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

///商品图
@interface JHRefundImagesModel : NSObject
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


@interface JHRefundOperationListModel : NSObject
///退款类型
@property (nonatomic, copy) NSString *refundTypeCode;
///退款类型描述
@property (nonatomic, copy) NSString *refundTypeDesc;
///退款理由
@property (nonatomic, copy) NSString *refundReasonCode;
///退款理由描述
@property (nonatomic, copy) NSString *refundReasonDesc;
///退款发起方
@property (nonatomic, copy) NSString *refundSponsor;
///退款金额
@property (nonatomic, copy) NSString *refundAmt;
///退款描述
@property (nonatomic, copy) NSString *refundDesc;
///申请退款图片地址
@property (nonatomic, copy) NSArray<JHApplyRefundImageModel *> *applyRefundImage;
///操作类型 1：买家申请退货退款  2：卖家拒绝退货  3：卖家同意退货申请  4：卖家超时未处理，系统同意退货  5：平台介入，同意退货  6：买家已退货  7：卖家收货后同意退款  8：卖家超时未处理，系统同意退款  9：卖家收货后拒绝退款  10：卖家取消交易  11：买家申请退款  12：卖家同意退款  13：卖家超时未处理，系统自动退款  14：卖家拒绝退款  15：平台提醒  16：平台介入同意退款
@property (nonatomic, copy) NSString *operationType;
///拒绝原因代码
@property (nonatomic, copy) NSString *refuseReason;
///拒绝原因
@property (nonatomic, copy) NSString *refuseReasonDesc;
///拒绝理由
@property (nonatomic, copy) NSString *refuseDesc;
///图片信息
@property (nonatomic, copy) NSArray<JHRefundImagesModel *> *images;
///卖家地址
@property (nonatomic, copy) NSString *sellerAddress;
///卖家联系人
@property (nonatomic, copy) NSString *sellerContacts;
///卖家电话
@property (nonatomic, copy) NSString *sellerPhone;
///物流订单号
@property (nonatomic, copy) NSString *logisticsOrderNo;
///物流
@property (nonatomic, copy) NSString *logisticsService;
///物流公司
@property (nonatomic, copy) NSString *logisticsServiceName;
///操作时间
@property (nonatomic, copy) NSString *optTime;
///文案1
@property (nonatomic, copy) NSString *text1;
///文案2
@property (nonatomic, copy) NSString *text2;
///文案3
@property (nonatomic, copy) NSString *text3;

@end

///退款类型
@interface JHRefundTypeModel : NSObject
///编码
@property (nonatomic, copy) NSString *code;
///描述
@property (nonatomic, copy) NSString *msg;
@end


///退款原因
@interface JHRefundReasonsModel : NSObject
///编码
@property (nonatomic, copy) NSString *code;
///描述
@property (nonatomic, copy) NSString *desc;
@end


///拒绝原因
@interface JHRefundRefuseReasonModel : NSObject
///编码
@property (nonatomic, copy) NSString *code;
///描述
@property (nonatomic, copy) NSString *msg;
@end


@interface JHRefundButtonShowModel : NSObject
///删除按钮
@property (nonatomic, copy) NSString *deleteBtn;
///修改按钮
@property (nonatomic, copy) NSString *update;
///撤销按钮
@property (nonatomic, copy) NSString *cancel;
///提醒收货
@property (nonatomic, copy) NSString *remindReceiving;
///提醒发货
@property (nonatomic, copy) NSString *remindSend;
///拒绝退货
@property (nonatomic, copy) NSString *refuseRefundGoods;
///同意退货
@property (nonatomic, copy) NSString *agreeRefundGoods;
///同意退款
@property (nonatomic, copy) NSString *agreeRefund;
///拒绝退款
@property (nonatomic, copy) NSString *refuseRefund;
///已发货拒绝退款
@property (nonatomic, copy) NSString *goodsRefuseRefund;
///平台介入结果
@property (nonatomic, copy) NSString *ardDetail;
///申请平台介入
@property (nonatomic, copy) NSString *applyArd;
///收到货,同意退款
@property (nonatomic, copy) NSString *goodsAgreeRefund;
///去退货
@property (nonatomic, copy) NSString *goRefundGoods;
///填写物流单号
@property (nonatomic, copy) NSString *addlogisticsOrderNo;

@end

@interface JHC2CRefundDetailModel : NSObject
///仲裁编号/平台介入编号
@property (nonatomic, copy) NSString *arbitrationId;
///工单编号
@property (nonatomic, copy) NSString *workOrderId;
///0 待用户预约, 1 待客服预约, 2 已预约, 3 已发货
@property (nonatomic, copy) NSString *pickupStatus;
///工单处理超时时间
@property (nonatomic, copy) NSString *workOrderTimeOut;
///退款类型
@property (nonatomic, copy) NSString *refundTypeCode;
///工单状态
@property (nonatomic, copy) NSString *workOrderStatus;
///工单状态描述
@property (nonatomic, copy) NSString *workOrderStatusDesc;
///退款金额
@property (nonatomic, copy) NSString *refundAmt;
///操作集合
@property (nonatomic, copy) NSArray<JHRefundOperationListModel *> *operationList;
///退款类型
@property (nonatomic, copy) NSArray<JHRefundTypeModel *> *refundType;
///退款原因
@property (nonatomic, copy) NSArray<JHRefundReasonsModel *> *refundReasons;
///拒绝原因
@property (nonatomic, copy) NSArray<JHRefundRefuseReasonModel *> *refuseReason;
///按钮显示
@property (nonatomic, strong) JHRefundButtonShowModel *button;

@end

NS_ASSUME_NONNULL_END
