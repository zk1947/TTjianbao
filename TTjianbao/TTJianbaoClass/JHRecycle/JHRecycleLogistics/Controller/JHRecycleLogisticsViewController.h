//
//  JHRecycleLogisticsViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleLogisticsViewController : JHBaseViewController
/** 订单id*/
@property (nonatomic, copy) NSString *orderId;
/** 电话号码 该物流对应的收货人手机号,type为7时需要传*/
//@property (nonatomic, copy) NSString *phone;
/** type 0:商家-平台，1:平台-用户，3：用户退货到平台，5：平台退货给商家，6：回收用户发货给商家，7：回收商家退货给用户,详情可参考这个枚举*/
@property (nonatomic, assign) NSInteger type;  // 6 一般   7退货传

/// 是否是商家直发
@property (nonatomic, assign) BOOL isBusinessZhiSend;
/// 是否是商家直发卖家
@property (nonatomic, assign) BOOL isZhifaSeller;
/// 是否是已完成，已完成不显示修改按钮
@property (nonatomic, assign) BOOL isZhifaOrderComplete;

@end

NS_ASSUME_NONNULL_END
