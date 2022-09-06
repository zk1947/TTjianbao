//
//  JHCustomizeOrderModel.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHOrderDetailMode.h"
//订单详情和列表底部按钮限制显示的个数
#define   buttonLimitCount 4
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, JHCustomizeOrderButtonType)
{
    JHCustomizeOrderButtonGoPay  = 0,//用户去支付
    JHCustomizeOrderButtonAppraiseReport,//鉴定报告
    JHCustomizeOrderButtonCancelMade ,//取消定制(没了)
    JHCustomizeOrderButtonCancelOrder ,//用户取消订单
    JHCustomizeOrderButtonCompleteInfo ,//完善信息
    JHCustomizeOrderButtonConfirmAccept ,//确认接单 （没了）
    JHCustomizeOrderButtonConfirmMade ,//主播确认定制
    JHCustomizeOrderButtonConfirmPay ,//确认支付
    JHCustomizeOrderButtonConfirmPlan ,//确认方案/提交方案
    JHCustomizeOrderButtonConfirmReceipt ,//确认收货
    JHCustomizeOrderButtonConfirmSend ,//确认发货
    JHCustomizeOrderButtonConnectMic ,//申请连麦
    JHCustomizeOrderButtonModifyInfo ,//修改信息
    JHCustomizeOrderButtonPrintCard ,//打印宝卡
    JHCustomizeOrderButtonRefundDetail ,//退款详情
    JHCustomizeOrderButtonReturnGoods ,//退货到平台
    JHCustomizeOrderButtonViewExpress ,//查看物流
    JHCustomizeOrderButtonCompleteGoods ,//主播制作完成
    JHCustomizeOrderButtonContactPlatform ,//联系平台
    JHCustomizeOrderButtonContactService ,//联系客服
    JHCustomizeOrderButtonUpdateRemark ,//更新备注
    JHCustomizeOrderButtonComment ,//用户评价
    JHCustomizeOrderButtonHasComment ,//用户已评价
    JHCustomizeOrderButtonNewSettle ,//新结算
    JHCustomizeOrderButtonDelete ,//删除
    JHCustomizeOrderButtonUpLoadPlan ,//提交方案
    JHCustomizeOrderStatusConfirmOrder ,//用户确认订单
    
    JHCustomizeOrderButtonAlterAddress ,//用户修改地址
    JHCustomizeOrderButtonApplyReturnGoods ,//用户申请退款退款
    JHCustomizeOrderButtonAppraiseIssue ,//鉴定问题处理
    JHCustomizeOrderButtonRemindSend ,//提醒发货
    JHCustomizeOrderButtonStoneReselling ,//转售中
    JHCustomizeOrderButtonStoneResell ,//转售
    JHCustomizeOrderButtonApplyCustomize ,//申请定制
    
    JHCustomizeOrderButtonMore ,//更多按钮
};

typedef NS_ENUM(NSInteger, JHCustomizeOrderStatus) {
    JHCustomizeOrderStatusWaitOrder= 0,//待接单
    JHCustomizeOrderStatusWaitCharge,//待支付预付款状态（定制师接完单）
    JHCustomizeOrderStatusWaitUserSend,//待用户发货（用户支付完）
    JHCustomizeOrderStatusWaitPlatReceive,//待平台收货（用户发货后）
    JHCustomizeOrderStatusWaitPlatAppraiseGoods,//待平台验大师（平台收到货）
    JHCustomizeOrderStatusWaitPlatSendToSeller,//待平台寄送（平台已验货）
    JHCustomizeOrderStatusWaitCustomizerReceive,//待定制师收货（平台已验货）
    JHCustomizeOrderStatusWaitCustomizerAck,//待定制确认（定制师已收货）
    JHCustomizeOrderStatusCustomizerPlanning ,//定制方案中（定制师确认定制）
    JHCustomizeOrderStatusWaitCustomerAckPlan,//待用户确认方案（定制师提交方案）
    JHCustomizeOrderStatusCustomizing ,//定制中（用户确认方案）
    JHCustomizeOrderStatusWaitCustomizerSend,//待定制师发货（制作完成）
    JHCustomizeOrderStatusWaitPlatReceiveGoods ,//待平台收货（定制师发货了）
    JHCustomizeOrderStatusWaitPlatAppraise,//待平台验货用户（平台收货）
    JHCustomizeOrderStatusPlatSent ,//待用户收货（平台发货给用户）
    JHCustomizeOrderStatusBuyerReceived,//已完成（用户收到货了）
    JHCustomizeOrderStatusCancel ,//订单取消（取消订单）
    JHCustomizeOrderStatusRefunded ,//退款完成
   
    
};

@class JHCustomizeOrderMaterialModel;
@class JHCustomizeOrderMediaAttachModel;
@class JHCustomizeOrderPicInfoVoModel;
@class JHCustomizeOrderStatusLogVosModel;
@class JHCustomizeOrderpayRecordVosModel;
@class JHCustomizeOrderPlanModel;
@class JHCustomizeOrderCompleteModel;
@class JHCustomizeOrderButtonModel;
@class JHCustomizeOrderShowButtonVoModel;
@class JHCustomizeOrderImageModel;

@interface JHCustomizeOrderModel : JHOrderDetailMode

@property (strong,nonatomic)NSString * advanceValue;//预付款
@property (strong,nonatomic)NSString * shouldPayAdvanceValue;//应付预付款
@property (strong,nonatomic)NSString * shouldPayValue;//应付差额

@property (strong,nonatomic)NSString * praiseNum;//点赞数
@property (strong,nonatomic)NSString * sellerId;//定制师id
@property (strong,nonatomic)NSString * sellerImg;//定制师头像
@property (strong,nonatomic)NSString * sellerName;//定制师名称

@property (strong,nonatomic)NSString * totalValue;//总金额
@property (strong,nonatomic)NSString * updateTime;//更新时间
@property (strong,nonatomic)NSString * userRemark;//用户备注
@property (strong,nonatomic)NSString * customizeOrderId;//定制订单id
@property (strong,nonatomic)NSString * createTime;//订单创建时间
@property (strong,nonatomic)NSString * customerId;//用户id
@property (strong,nonatomic)NSString * customerImg;//用户头像
@property (strong,nonatomic)NSString * customerName; //用户名称
@property (strong,nonatomic)NSString * customizeOrderCode;//定制订单编号
@property (strong,nonatomic)NSString * customizeOrderName;//定制名字
@property (strong,nonatomic)NSString * goodsTitle;//商品标题
@property (strong,nonatomic)NSString * goodsUrl;//商品图片

@property (strong,nonatomic)NSString * customizeRemark;//大师备注
@property (strong,nonatomic)NSString * customizedFee;//分类id
@property (strong,nonatomic)NSString * customizedFeeName;//分类名字
@property (strong,nonatomic)NSArray * customizeFeeNames;//分类名字,数组
@property (strong,nonatomic)NSString * diffValue;//差价款
@property (strong,nonatomic)NSString * orderCode;//订单id 对应t_order
@property (strong,nonatomic)NSString * orderId;//订单id 对应t_order
@property (strong,nonatomic)NSString * status;//定制订单状态
@property (strong,nonatomic)NSString * statusName;//定制订单状态名称
@property (strong,nonatomic)NSString * icon;//定制订单状态icon
@property (strong,nonatomic)NSString * orderCopy;//定制订单状态描述文案

//@property (assign,nonatomic) int orderStatus; /// 订单状态（数字）
@property (strong,nonatomic) NSString *orderStatusText;
@property (strong,nonatomic) NSString *expireTime;
@property (strong,nonatomic) NSString *goodsId;
@property (strong,nonatomic) NSString *appraisalCateName;
@property (strong,nonatomic) NSString *appraisalCateId;
@property (strong,nonatomic) NSString *applyTime;
@property (strong,nonatomic) NSDictionary *buttonsVo;
@property (nonatomic, assign) BOOL directDelivery;//是否直发

@property (assign,nonatomic)JHCustomizeOrderStatus customizeOrderStatusType;
@property (strong,nonatomic)NSString * factValue;//定制订单状态
//差价退款状态，0：无需退差价，1：正在退差价，2：差价退款完成
@property (assign,nonatomic)int  refundDiffStatus;
//原料来源：0 平台原料 1 自有原料
@property (assign,nonatomic)int  materialSource;
//制作详情提示是否显示
@property (assign,nonatomic)BOOL  customizeDetailBtnFlag;
//是否直播中
@property (assign,nonatomic)BOOL  liveFlag;

//制作完成信息集合 现在只取第一个
@property (strong,nonatomic)NSArray <JHCustomizeOrderCompleteModel*>* completions;

//订单支付状态记录时间集合
@property (strong,nonatomic)NSArray<JHCustomizeOrderStatusLogVosModel*>* orderStatusLogVos;
//订单支付记录信息集合
@property (strong,nonatomic)NSArray <JHCustomizeOrderpayRecordVosModel*>* payRecordVos;
//定制方案列表
@property (strong,nonatomic)NSArray <JHCustomizeOrderPlanModel*>* plans;
//定制详情区域展示：附件列表和更新时间
@property (strong,nonatomic)JHCustomizeOrderPicInfoVoModel *picInfoVo;
//原料信息
@property (strong,nonatomic)JHCustomizeOrderMaterialModel * materialVo;
//按钮状态显示
@property (strong,nonatomic)JHCustomizeOrderShowButtonVoModel * customizeShowBtnVo;
///底部按钮
@property (strong, nonatomic)NSArray <JHCustomizeOrderButtonModel*>*customizeButtons;
@property (assign,nonatomic)CGFloat cellHeight;

@property (strong,nonatomic) JHCustomizeOrderImageModel *goodsImg;
/// 新增闪购标识
@property (assign,nonatomic) BOOL flashIcon;

+(NSArray*)getCustomizeOrderListCateArry:(BOOL)isSeller;
+(NSArray*)getNewOrderListCateArry:(BOOL)isSeller;
@end

@interface JHCustomizeOrderMediaAttachModel : NSObject
@property (strong,nonatomic)NSString * coverUrl;//封面图片
@property (assign,nonatomic)int type;//类型 0图片 1视频
@property (strong,nonatomic)NSString * url;//资源地址
@end

@interface JHCustomizeOrderStatusLogVosModel : NSObject
@property (strong,nonatomic)NSString * createTime;//
@property (strong,nonatomic)NSString * currentStatus;//当前状态
@property (strong,nonatomic)NSString * currentStatusName;//当前状态名称
@end

@interface JHCustomizeOrderMaterialModel : NSObject
@property (strong,nonatomic)NSString * createTime;//创建时间
@property (strong,nonatomic)NSString * customizeFeeId;//分类id
@property (strong,nonatomic)NSString * customizeFeeName;//分类名字
@property (strong,nonatomic)NSString * customizeOrderId;//定制订单id
@property (strong,nonatomic)NSString * deliveryTime;//发货时间
@property (strong,nonatomic)NSString * logisticsCode;//物流单号
@property (strong,nonatomic)NSString * logisticsCompany;//物流公司
@property (strong,nonatomic)NSString * materialDesc;//原料信息
@property (strong,nonatomic)NSString * materialImgs;//原料影像 附件id 也可以多个逗号分开
@property (strong,nonatomic)NSString * materialName;//原料名称
@property (strong,nonatomic)NSString * receiveTime;//平台收货时间
@property (strong,nonatomic)NSString * url;//资源地址
@property (strong,nonatomic)NSString * sourceOrderId;//来源订单id
@property (assign,nonatomic)int materialSource;///原料来源：0 平台原料 1 自有原料
@end

@interface JHCustomizeOrderpayRecordVosModel : NSObject
@property (strong,nonatomic)NSString * money;//支付金额
@property (strong,nonatomic)NSString * payTime;//支付时间
@property (assign,nonatomic)int payType;//支付方式
@property (strong,nonatomic)NSString * payTypeName;//支付方式名称
@end

@interface JHCustomizeOrderPlanModel : NSObject
@property (strong,nonatomic)NSString * createTime;//创建时间
@property (strong,nonatomic)NSString * customizeFeeId;//分类id
@property (strong,nonatomic)NSString * customizeFeeName;//分类名字
@property (strong,nonatomic)NSString * customizeOrderId;//定制订单id
@property (assign,nonatomic)int delFlag;//删除标识 0 未删除 1 已删除
@property (strong,nonatomic)NSString * extPrice;//额外原料金额
@property (strong,nonatomic)NSString * planDesc;//方案说明
@property (strong,nonatomic)NSString * planPrice;//方案金额 ,
@property (strong,nonatomic)NSString * totalPrice;//方案金额+额外原料金额 ,
@property (assign,nonatomic)int status;//状态 0待提交 1待确认 2 已确认 3 拒绝
@property (strong,nonatomic)NSString * customizePlanId;//id ,
//附件列表
@property (strong,nonatomic)NSArray <JHCustomizeOrderMediaAttachModel*>* attachmentVOs;
@end


@interface JHCustomizeOrderCompleteModel : NSObject
//附件列表
@property (strong,nonatomic)NSArray <JHCustomizeOrderMediaAttachModel*>* attachmentList;
@end

@interface JHCustomizeOrderPicInfoVoModel : NSObject
@property (strong,nonatomic)NSString * lastUpdateDesc;//距离上次更新时间
@property (strong,nonatomic)NSArray <JHCustomizeOrderMediaAttachModel*>* attachmentVOS;
@end

@interface JHCustomizeOrderButtonModel : NSObject
@property (strong,nonatomic)NSString * title;
//样式 0是灰色  1是黄色  2是透明
@property (assign,nonatomic)int style;
@property (assign,nonatomic)JHCustomizeOrderButtonType buttonType;
@end


@interface JHCustomizeOrderShowButtonVoModel : NSObject
//@property (strong, nonatomic)NSArray <JHCustomizeOrderButtonModel*>*buttons; ///底部按钮
//鉴定报告是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  haveReport;
//取消定制是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  cancelMadeBtnFlag;
//取消订单按钮是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  cancelOrderBtnFlag;
//制作完成是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  completeGoodsBtnFlag;
//完善信息是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  completeInfoBtnFlag;
//确认接单是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  confirmAcceptOrderBtnFlag;
//确认定制是否展示
@property (assign,nonatomic)BOOL  confirmMadeBtnFlag;
//确认支付按钮 是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  confirmPaymentBtnFlag;
//确认方案/提交方案按钮是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  confirmPlanBtnFlag;
//确认收货是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  confirmReceiptBtnFlag;
//确认发货是否展示 0不展示1展示
@property (assign,nonatomic)BOOL  confirmSendBtnFlag;
//申请连麦按钮是否展示
@property (assign,nonatomic)BOOL  connectMicBtnFlag;
//联系平台是否展示
@property (assign,nonatomic)BOOL  contactPlatformBtnFlag;
//联系客服是否展示
@property (assign,nonatomic)BOOL  contactServiceBtnFlag;
//评价是否展示 是否展示 0不展示1展示 (**废弃)
@property (assign,nonatomic)BOOL  evaluateBtnFlag;
//评价按钮
@property (assign,nonatomic)BOOL  commentStatusShow;
//去支付按钮是否展示
@property (assign,nonatomic)BOOL  goPayBtnFlag;
@property (assign,nonatomic)BOOL  toPayBtnFlag;
@property (assign,nonatomic)BOOL  cancelAppraisalBtnFlag;
@property (assign,nonatomic)BOOL  seeReportBtnFlag;
@property (assign,nonatomic)BOOL  deleteOrderBtnFlag;
//修改信息是否展示
@property (assign,nonatomic)BOOL  modifyInfoBtnFlag;
//打印宝卡是否展示
@property (assign,nonatomic)BOOL  printCardInfoBtnFlag;
//退款详情是否展示
@property (assign,nonatomic)BOOL  refundDetailBtnFlag;
//退货到平台是否展示
@property (assign,nonatomic)BOOL  returnGoodsBtnFlag;
//查看物流是否展示
@property (assign,nonatomic)BOOL  viewExpressBtnFlag;
//更新备注
@property (assign,nonatomic)BOOL  updateRemarkBtnFlag;
//新结算
@property (assign,nonatomic)BOOL  isNewSettle;
//是否能点击制作完成按钮
@property (assign,nonatomic)BOOL  clickCompleteBtn;

//是否显示删除按钮
@property (assign,nonatomic)BOOL  deleteFlag;

//是否显示提交方案按钮
@property (assign,nonatomic)BOOL  uploadPlanBtnFlag;

//是否显示确认订单按钮
@property (assign,nonatomic)BOOL  userConfirmBtnFlag;

//鉴定报告是否已读
@property (assign,nonatomic)BOOL  reportReadFlag;

//修改地址按钮是否显示
@property (assign,nonatomic)BOOL  changeCustomerAddressBtnFlag;



@end

@interface JHCustomizeOrderImageModel : NSObject
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *medium;
@property (nonatomic, copy) NSString *big;
@property (nonatomic, copy) NSString *origin;

@end
NS_ASSUME_NONNULL_END
