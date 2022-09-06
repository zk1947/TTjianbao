//
//  CStoneDetailModel.h
//  TTjianbao
//  原石详情数据模型
//  Created by wuyd on 2019/12/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
//

#import "YDBaseModel.h"

@class CAttachmentListData;
@class COfferRecordListData;
@class CStoneChangeListData;
@class CStoneTreeData;

NS_ASSUME_NONNULL_BEGIN
/// 原石详情数据模型
@interface CStoneDetailModel : YDBaseModel

@property (nonatomic,   copy) NSString *channelId;

/// (string, optional): 商品编号
@property (nonatomic,   copy) NSString *goodsCode;

/// (string, optional): 商品标题
@property (nonatomic,   copy) NSString *goodsTitle;

/// (string, optional): 商品描述
@property (nonatomic,   copy) NSString *goodsDesc;

/// (number, optional): 金额
@property (nonatomic, strong) NSNumber *price;

/// (integer, optional): 原石货主ID
@property (nonatomic,   copy) NSString *saleCustomerId;

/// (string, optional): 原石货主头像
@property (nonatomic,   copy) NSString *saleCustomerImg;

/// (string, optional): 原石货主姓名
@property (nonatomic,   copy) NSString *saleCustomerName;

/// (integer, optional): 买家ID
@property (nonatomic, copy) NSString *buyerId;

/// (string, optional): 买家头像
@property (nonatomic,   copy) NSString *buyerImg;

/// (string, optional): 买家姓名
@property (nonatomic,   copy) NSString *buyerName;

/// (number, optional): 交易价格
@property (nonatomic, assign) CGFloat dealPrice;

/// (integer, optional): 第几次交易
@property (nonatomic, assign) NSInteger dealSequence;

/// (number, optional): 已回血总额
@property (nonatomic, assign) CGFloat actualPrice;

/// (number, optional): 预估回血总额
@property (nonatomic, assign) CGFloat expectPrice;

/// (number, optional): 原石初始成交价 <initPrice>
@property (nonatomic, assign) CGFloat oriPrice;

/// (integer, optional): 出价人数
@property (nonatomic, assign) NSInteger offerCount;

/// (integer, optional): 求看次数
@property (nonatomic, assign) NSInteger seekCount;

@property (nonatomic, assign) BOOL selfSeek;

/// (integer, optional): 寄回（块）
@property (nonatomic, assign) NSInteger sendCount;

/// (boolean, optional): 是否展示一口价和出价按钮
@property (nonatomic, assign) BOOL showOfferButton;

///附件列表
@property (nonatomic, strong) NSMutableArray<CAttachmentListData *> *attachmentList;

///出价记录列表
@property (nonatomic, strong) NSMutableArray<COfferRecordListData *> *offerRecordList;

///求看人头像列表，最多返回7个头像<存了一堆头像url>
@property (nonatomic, strong) NSMutableArray<NSString *> *seekCustomerImgList;

///原石换手记录<原石溯源>
@property (nonatomic, strong) NSMutableArray<CStoneChangeListData *> *stoneChangeList;

///原石族谱树
@property (nonatomic, strong) NSMutableArray<CStoneTreeData *> *stoneTree;


/// 原订单ID
@property (nonatomic, copy) NSString *sourceOrderId;


/// 原订单ID
@property (nonatomic, copy) NSString *stoneResaleId;

- (NSString *)toUrl;

- (NSDictionary *)toParamWithStoneId:(NSInteger)stoneId;

@end

/// <附件：图片、视频>
@interface CAttachmentListData : NSObject

/// 附件类型：0-未定义，1-图片，2-视频 = ['NONE', 'PICTURE', 'VIDEO']
@property (nonatomic, assign) NSInteger attachmentType;

///(string, optional): 视频覆盖图
@property (nonatomic, copy) NSString *coverUrl;

@property (nonatomic, copy) NSString *originUrl;
///地址
@property (nonatomic, copy) NSString *url;

@end

///<出价记录列表>
@interface COfferRecordListData : NSObject

///出价人ID
@property (nonatomic, assign) NSInteger offerCustomerId;

///出价人名称
@property (nonatomic, copy) NSString *offerCustomerName;

///出价人头像
@property (nonatomic, copy) NSString *offerCustomerIcon;

///出价时间
@property (nonatomic, copy) NSString *handleTime;
@property (nonatomic, copy) NSString *createTime;

///价格
@property (nonatomic, copy) NSString *offerPrice;
///出价状态： 0-初始化，1-出价中，2-待支付尾款，3-已成交，4-已拒绝，5-已取消，6-已退款，7-未回复超时失效，8-未支付尾款超时失效
/// = ['INIT',  'OFFER',  'FINAL_PAY',  'DEAL',  'REJECT',  'CANCEL',  'REFUND',  'REPLY_EXPIRED',  'PAY_EXPIRED']
@property (nonatomic, assign) NSInteger offerState;
@end


/// <原石换手记录>
@interface CStoneChangeListData : NSObject

/// 是否在列表顶部
@property (nonatomic, assign) BOOL isTop;

///加工方式，例：第一刀：开窗，可以为空，为空时候代表在原石直播间，还没有经过加工
@property (nonatomic,   copy) NSString *processMode;

///原石标题
@property (nonatomic,   copy) NSString *goodsTitle;

/// 编码
@property (nonatomic,   copy) NSString *goodsCode;

///(integer, optional): 原石货主ID
@property (nonatomic, assign) NSInteger saleCustomerId;

///(string, optional): 原石货主头像
@property (nonatomic,   copy) NSString *saleCustomerImg;

///(string, optional): 原石货主名称，加密过
@property (nonatomic,   copy) NSString *saleCustomerName;

///(number, optional): 出售价格
@property (nonatomic, assign) CGFloat price;

///换手次序？？？？啥用？？？
@property (nonatomic, assign) NSInteger sequence;

///附件列表
@property (nonatomic, strong) NSMutableArray<CAttachmentListData *> *attachmentList;

@end


/// <原石族谱树>
@interface CStoneTreeData : NSObject
@property (nonatomic, assign) BOOL restore;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger parentStoneId;
@property (nonatomic, assign) NSInteger stoneId;
@property (nonatomic,   copy) NSString *coverUrl;
@property (nonatomic,   copy) NSString *goodsCode;
@property (nonatomic,   copy) NSString *state;
@property (nonatomic, strong) NSArray<CStoneTreeData *> *children;
@end


NS_ASSUME_NONNULL_END
