//
//  JHOrderDetailMode.h
//  TTjianbao
//   增加了原石回血相关信息
//  Created by jiang on 2019/12/13.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderMode.h"
@class JHGraphicalBottomModel;
NS_ASSUME_NONNULL_BEGIN
//0-初始、1-寄回、2-寄售、3-加工、4-拆单
typedef NS_ENUM(NSInteger, JHOrderTransitionState) {
    JHOrderTransitionStateNomal= 0,//0-初始
    JHOrderTransitionStateReturn,//1-寄回
    JHOrderTransitionStateSale,//2-寄售
    JHOrderTransitionStateProcess,//3-加工
    JHOrderTransitionStateSplit,//4-拆单
};

//1-图片，2-视频
typedef NS_ENUM(NSInteger, JHOrderAttachmentType) {
    JHOrderAttachmentTypePicture= 1,//图片
    JHOrderAttachmentTypeVideo,//2-视频
};

@class JHRestoreOrderAttachmentMode,JHGroDetailImageUrlModel;
@interface JHOrderDetailMode : OrderMode

@property (strong,nonatomic)NSString * rootCoverUrl;//源石头原石覆盖图
@property (strong,nonatomic)NSString * rootGoodsName;//源石头原石名称
@property (strong,nonatomic)NSString * rootGoodsUrl;//源石头视频地址
@property (strong,nonatomic)NSString * rootOrderCode;//源石头订单编码
@property (strong,nonatomic)NSString * rootPurchasePrice;//源石头购入价格
@property (strong,nonatomic)NSString * splitTime; //拆单时间
@property (assign,nonatomic)BOOL hasParent; //是否有母订单
@property (assign,nonatomic)BOOL isC2C;
@property (strong,nonatomic)NSString * unitPrice; //单价
@property (assign,nonatomic)BOOL isSelectedProtocol; //是否有母订单
@property (strong,nonatomic)NSString * stoneId;//石头id
//流转状态：0-初始、1-寄回、2-寄售、3-加工、4-拆单 = ['INIT', 'SEND', 'SALE', 'PROCESS', 'SPLIT']
@property (assign,nonatomic)JHOrderTransitionState transitionState;
@property (strong,nonatomic)NSArray <JHRestoreOrderAttachmentMode*>* attachmentList;//附件列表

@property (strong,nonatomic)NSString * offerPrice;
@property (strong,nonatomic)NSString * intentionPrice;
@property (strong,nonatomic)NSString * serviceCostPrice;

@property (strong,nonatomic)NSString *orderCategory;
@property (strong,nonatomic)NSString *shopId;
@property (strong,nonatomic)NSString *sellerName;
@property (strong,nonatomic)NSString *sellerImg;
@property (strong,nonatomic)NSString *goodsTitle;
@property (strong,nonatomic)NSString *goodsUrl;

@property (assign,nonatomic)BOOL isNewSettle;///新结算

@property (nonatomic, strong) NSString* onlyGoodsId;//

//鉴定报告是否已读
@property (assign,nonatomic)BOOL reportReadFlag;

@property (assign,nonatomic)NSInteger isDirectDelivery; //是否商家直发 0否 1是
//@property (assign,nonatomic) int orderStatus; /// 订单状态（数字）
@property (strong,nonatomic) NSString *orderStatusText;
@property (strong,nonatomic) NSString *orderStatusDesc;
//@property (strong,nonatomic) NSString *orderCode;
@property (strong,nonatomic) NSString *createTime;

@property (strong,nonatomic) NSString *expireTime;
@property (strong,nonatomic) NSString *goodsId;
@property (strong,nonatomic) NSString *appraisalCateName;
@property (strong,nonatomic) NSString *appraisalCateId;
@property (strong,nonatomic) NSString *applyTime;
@property (strong,nonatomic) NSString *appraisalFee;
//@property (strong,nonatomic) NSString *discountAmount;
//@property (strong,nonatomic) NSString *orderPrice;
@property (strong,nonatomic) NSArray<JHGroDetailImageUrlModel *> *goodsImgs;

@property (strong,nonatomic) NSDictionary *buttonsVo;
@property (strong,nonatomic) NSArray <JHGraphicalBottomModel *> *bottomButtons;

@property (strong,nonatomic) NSString *tip;

@property (strong,nonatomic) NSString * partialRefundAmount; //部分退已退金额 单位：元
@property (assign,nonatomic) BOOL partialRefundFlag; //用于表示该订单是否为部分退 true是 false 否
/// 新增，闪购图标标识
@property (assign,nonatomic)BOOL flashIcon;
@end

@interface JHRestoreOrderAttachmentMode : NSObject
@property (assign,nonatomic)JHOrderAttachmentType  attachmentType;//原石附件类型
@property (strong,nonatomic)NSString * coverUrl;//视频遮罩图
@property (strong,nonatomic)NSString * url;//地址
@end

@interface JHOrderCateMode : NSObject
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * status;
+(NSArray*)getBuyerOrderListCateArry;
+(NSArray*)getSellerOrderListCateArry;
@end


@interface JHGroDetailImageUrlModel : NSObject
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

NS_ASSUME_NONNULL_END
