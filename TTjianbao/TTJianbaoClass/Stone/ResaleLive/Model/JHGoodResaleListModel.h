//
//  JHGoodResaleListModel.h
//  TTjianbao
//  Description:用户-回血直播间-原石回血-列表(该列表有出价、求看、一口价操作) 
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"
#import "JHGoodsReqModel.h"

@class JHStoneResaleDetailSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodResaleOfferRecordModel : NSObject

@property (nonatomic, strong) NSString* createTime;// (string, optional): 出价时间 ,
@property (nonatomic, strong) NSString* offerCustomerIcon;// (string, optional): 出价人头像 ,
@property (nonatomic, strong) NSString* offerCustomerId;// (integer, optional): 出价人ID ,
@property (nonatomic, strong) NSString* offerCustomerName;// (string, optional): 出价人名称 ,
@property (nonatomic, strong) NSString* offerPrice;// (number, optional): 价格 ,
@property (nonatomic, strong) NSString* offerState;// (string, optional): 出价状态：0-初始化，1-出价中，2-待支付尾款，3-已成交，4-已拒绝，5-已取消，6-已退款，7-未回复超时失效，8-未支付尾款超时失效

- (JHStoneResaleDetailSubModel*)convertDetailModel;
@end

@interface JHGoodResaleListModel : JHGoodsExtModel

@property (nonatomic, strong) NSArray<JHGoodResaleOfferRecordModel*>* offerRecordList;// (Array[OfferRecordResponse], optional): 出价记录列表
@property (nonatomic, strong) NSString* saleCustomerId;// (integer, optional): 寄售人ID ,
@property (nonatomic, strong) NSString* buttonTxt; //讲解中文本
@property (nonatomic, assign) NSInteger explainingFlag;// 是否正在讲解，0否，1是 
@property (nonatomic, assign) NSUInteger selfSeek;// (boolean, optional): 表示是否是已求看 ,
@property (nonatomic, assign) NSUInteger selfOffer; //(boolean, optional): 表示是否显示砍价按钮 ,
@property (nonatomic, assign) BOOL isSimpleShow; //原石回血tab,简化显示:不划分割线,不显示出价记录

- (instancetype)initWithModel:(JHGoodResaleListModel*)model;
@end

@interface JHGoodResaleListReqModel : JHGoodsReqModel

@end

//用户-回血直播间-求看 +待完善
@interface JHGoodSeeSaveModel : JHRespModel

@property (nonatomic, strong) NSString* seekCount;// (integer, optional): 求看次数 ,
@property (nonatomic, strong) NSArray<NSString*>*seekCustomerImgList;// (Array[string], optional): 求看人头像列表
@end

@interface JHGoodSeeSaveReqModel : JHReqModel

@property (nonatomic, strong) NSString* stoneRestoreId;// (integer): 原石回血单ID

+ (void)requestWithStoneId:(NSString*)mId finish:(JHResponse)resp;
@end

//生成加工服务单，【出价】尾款支付和【一口价】生成原石回血订单和【接收出价】
@interface JHGoodOrderSaveReqModel : JHReqModel

@property (nonatomic, strong) NSString* channelCategory;// (string, optional): 直播间分类：roughOrder-原石直播间，restoreStone-回血直播间 ,
@property (nonatomic, strong) NSString* manualCost;// (number, optional): 手工费 ,
@property (nonatomic, strong) NSString* materialCost;// (number, optional): 材料费 ,
@property (nonatomic, strong) NSString* orderCategory;// (string, optional): 订单分类: processingGoods-原石加工服务订单, restoreProcessingGoods-回血加工服务订单, restoreOrder-原石回血订单, restoreIntentionOrder-原石回血意向金订单 
@property (nonatomic, strong) NSString* orderPrice;// (number, optional): 订单金额，例如原石回血意向金 ,
@property (nonatomic, strong) NSString* processingDes;// (string, optional): 加工服务单的描述 ,
@property (nonatomic, strong) NSString* stoneId;// (integer, optional): 原石单或回血单Id ,
@property (nonatomic, strong) NSString* stoneRestoreOfferId;// (integer, optional): 回血出价单Id（填空为一口价）
@property (nonatomic, strong) NSString* onlyGoodsId;//石头编号

+ (void)requestWithStoneId:(NSString*)mId price:(NSString*)price finish:(JHResponse)resp;
@end

@interface JHGoodOrderSaveModel : JHRespModel

@property (nonatomic, strong) NSString* orderId;//一口价跳转仅需要此字段
@property (nonatomic, strong) NSString* orderCode;
@property (nonatomic, strong) NSString* stoneRestoreOfferId;
@property (nonatomic, strong) NSString* errorMsg;
@end

NS_ASSUME_NONNULL_END
