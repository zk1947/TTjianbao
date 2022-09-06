//
//  JHMainLiveSmartModel.h
//  TTjianbao
//  Description:主播回血直播间,小请求model~~拆单、寄售、编辑、确认等
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHReqModel.h"
#import "JHLastSaleGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

//主播-（原石）回血直播间-寄售
@interface JHMainLiveConsignReqModel : JHReqModel

@property (nonatomic, strong) NSString* channelCategory;// (string): 直播间类型：roughOrder-原石直播间、restoreStone-回血直播间 = ['NORMAL', 'ROUGH_ORDER', 'PROCESSING_ORDER', 'DAIGOU_ORDER', 'RESTORE'],
@property (nonatomic, assign) NSInteger processMode; //(string): 加工方式，值范围(1-开窗、2-扒皮、3-切片、4-成品加工) = ['NONE', 'WINDOW', 'PEEL', 'SLICE', 'PRODUCT'],
@property (nonatomic, copy) NSString *salePrice; //(NSString): 寄售价格 ,
@property (nonatomic, copy) NSString *stoneId; //(integer): 原石ID

@end

@interface JHMainLiveAttachModel : NSObject

@property (nonatomic, strong) NSString* overUrl; //(string, optional): 如果是视频，封面地址 ,
@property (nonatomic, strong) NSString* type; //(string, optional): 1-图片，2-视频 = ['NONE', 'PICTURE', 'VIDEO'],
@property (nonatomic, strong) NSString* url; //(string, optional): 地址
@end

//主播-回血直播间-编辑 ~~改为->修改价格、主播确认修改价格
@interface JHMainLiveUpdatePriceReqModel : JHReqModel

@property (nonatomic, assign) int flag;// (boolean): 标识，0表示发消息，1标识根据消息修改价格
@property (nonatomic, strong) NSString* price;// (integer): 价格 ,
@property (nonatomic, strong) NSString* stoneRestoreId;// (integer): 原石回血ID

+ (void)requestWithStoneId:(NSString*)mId price:(NSString*)price flag:(int)flag finish:(JHFailure)failure;
@end

//主播-回血直播间-助理查询上架原石商品详情 
@interface JHMainLiveFindReqModel : JHReqModel

@property (nonatomic, strong) NSString* depositoryLocationCode; //(string): 存放货架 ,
@property (nonatomic, strong) NSString* goodsDesc; //(string): 商品内容 ,
@property (nonatomic, strong) NSString* goodsTitle; //(string): 商品标题 ,
@property (nonatomic, assign) NSInteger stoneRestoreId; //(integer): 原石回血ID ,
@property (nonatomic, strong) NSMutableArray<JHMainLiveAttachModel*>* urlList; //(Array[AttachmentRequest]): 附件列表
@end

//主播-（原石）回血直播间-查看确认寄售
@interface JHMainLiveConfirmConsignReqModel : JHReqModel

@property (nonatomic, strong) NSString* channelCategory;// (string): 直播间类型：roughOrder-原石直播间、restoreStone-回血直播间 = ['NORMAL', 'ROUGH_ORDER', 'PROCESSING_ORDER', 'DAIGOU_ORDER', 'RESTORE'],
@property (nonatomic, strong) NSString *stoneId; //(integer): 原石ID
@end

//主播-（原石）回血直播间-查看确认拆单
@interface JHMainLiveConfirmSplitReqModel : JHMainLiveConfirmConsignReqModel
//两者一样
@end

//用户-（原石）回血直播间-寄回
@interface JHMainLiveSendBackReqModel : JHMainLiveConfirmConsignReqModel
//两者一样
+ (void)request:(NSString*)channelCategory stoneId:(NSString*)stoneId finish:(JHFailure)failure;
@end

//主播-回血直播间-上架
@interface JHMainLiveShelveReqModel : JHMainLiveFindReqModel
//两者一样
@end

@interface JHMainLiveSplitDetailModel : NSObject
//拆单明细
@property (nonatomic, copy) NSString *purchasePrice; //(number): 购入价格 ,
@property (nonatomic, assign) NSInteger splitMode; //(string): 拆单方式，值范围(1-寄回,2-寄售,3-加工) = ['NONE', 'SEND', 'SALE', 'PROCESS']
@property (nonatomic, copy) NSString *splitModeName;
@end

//主播-（原石）回血直播间-拆单
@interface JHMainLiveSplitReqModel : JHMainLiveConfirmConsignReqModel

@property (nonatomic, strong) NSMutableArray<JHMainLiveSplitDetailModel*>* splitStoneList; //(Array[拆单明细]): 拆单明细列表 ,

@end

//用户 取消并寄回
@interface JHUserRejectConsignReqModel : JHMainLiveConfirmConsignReqModel
//两者一样
@end

//用户 确认寄售
@interface JHUserConfirmConsignReqModel : JHMainLiveConfirmConsignReqModel
//两者一样
@end

//通知宝友
@interface JHResaleInformReqModel : JHReqModel

@property (nonatomic, strong) NSString *stoneRestoreId;// (integer): 原石回血单ID

+ (void)requestWithStoneId:(NSString*)mId finish:(JHFailure)failure;
@end

//直播间求看个数 
@interface JHResaleToSeeCountReqModel : JHReqModel

@property (nonatomic, strong) NSString *channelId;

+ (void)requestWithChannelId:(NSString*)mId finish:(JHResponse)resp;
@end

@interface JHUserAcceptPriceReqModel : JHReqModel
@property (nonatomic, strong) NSString *stoneRestoreOfferId;
@end

@interface JHUserRejectPriceReqModel : JHUserAcceptPriceReqModel
@property (nonatomic, assign) NSInteger resaleFlag;//原石类型：0-原石回血、1-个人转售 TODO:Jesse add ???
@end

@interface JHUserConfirmBreakReqModel : JHMainLiveConfirmConsignReqModel
@end

//原石直播间-打印商品编码
@interface JHStoneLivePrintCodeReqModel : JHReqModel

@property (nonatomic, strong) NSString* channelCategory;// (string): 直播间类型：roughOrder-原石直播间、restoreStone-回血直播间 
@property (nonatomic, strong) NSString* stoneId;// (integer): 原石ID
@end

@interface JHStoneLivePrintCodeModel : JHRespModel

@property (nonatomic, strong) NSString* goodsCode;

+ (void)requestWithModel:(JHLastSaleGoodsModel*)model response:(JHFailure)failure;
@end


@interface JHMainLiveSmartModel : NSObject

//成功:无需提示吧？ 失败:给个提示？？
+ (void)request:(JHReqModel*)model response:(JHResponse)response;
@end

NS_ASSUME_NONNULL_END
