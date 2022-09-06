//
//  JHMsgSubListOrderTransportModel.h
//  TTjianbao
//
//  Created by Jesse on 2020/8/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListNormalModel.h"

NS_ASSUME_NONNULL_BEGIN

//订单物流-内部model
@interface JHMsgSubListNormalNoticeOrderModel : NSObject

@property (nonatomic, copy) NSString* orderCode;//  (string, optional): 订单号
@property (nonatomic, copy) NSString* sellerId;//  (string, optional): 商家ID
@property (nonatomic, copy) NSString* sellerName;//  商家名称
@property (nonatomic, copy) NSString* sellerIcon;//  商家图标
@property (nonatomic, copy) NSString* coverImg;//  new:订单图片
@end

@interface JHMsgSubListOrderTransportModel : JHMsgSubListNormalModel

@property (nonatomic, strong) JHMsgSubListNormalNoticeOrderModel* ext;//用最全的数据模型
@end

NS_ASSUME_NONNULL_END
