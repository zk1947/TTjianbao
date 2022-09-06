//
//  JHUCOnSaleListModel.h
//  TTjianbao
//  Desription:个人中心-在售原石列表,该列表有取消寄售、进入直播间操作
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"
#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHUCOnSaleListModel;

@interface JHUCOnSalePageModel : JHRespModel

@property (nonatomic, strong) NSArray<JHUCOnSaleListModel*>* list;// (Array[ListMySaleResponse], optional): 在售原石列表 ,
@property (nonatomic, strong) NSString* total;// (integer, optional): 总数 ,
@property (nonatomic, strong) NSString* totalPrice;// (number, optional): 回血总价
@end

@interface JHUCOnSaleListModel : JHGoodsExtModel

@property (nonatomic, strong) NSString* depositoryLocationCode;// (string, optional): 货架号 ,
@property (nonatomic, strong) NSString* saleState;// (string, optional): 寄售状态：0-未定义、1-待上架、2-已上架、3-正在支付、4-支付完成、5-已下架 = ['NONE', 'INIT', 'SHELVE', 'ON_SALE', 'SOLD', 'UNSHELVE'],
@property (nonatomic, strong) NSString* anchorIcon;// (string, optional): 主播头像 ,
@property (nonatomic, strong) NSString* channelTitle;// (string, optional): 直播间标题 ,
@property (nonatomic, strong) NSString* orderStatus;// (string, optional): 订单状态 = ['CANCEL', 'BUYER_RECEIVED', 'PORTAL_SENT', 'WAIT_PORTAL_SEND', 'WAIT_PORTAL_APPRAISE', 'SELLER_SENT', 'WAIT_SELLER_SEND', 'PAYING', 'WAIT_PAY', 'WAIT_ACK', 'REFUNDING', 'REFUNDED', 'COMPLETION', 'PROBLEM', 'WAIT_SEND', 'SALE'],
@property (nonatomic, strong) NSString* stoneId;// (integer, optional): 原石回血ID
@property (nonatomic, strong) NSString* channelId;//直播间id
@property (nonatomic, strong) NSString* buttonTxt;// 讲解状态文本（开始讲解，停止讲解（观众侧展示讲解中））
@property (nonatomic, assign) NSInteger explainingFlag;// 是否正在讲解，0否，1是 

+ (NSString*)convertFronSaleState:(NSString*)state;
@end

@interface JHUCOnSaleListReqModel : JHReqModel

@property (nonatomic, assign) NSUInteger pageIndex; //第几页
@property (nonatomic, assign) NSUInteger pageSize; //每页几条
@end

NS_ASSUME_NONNULL_END
