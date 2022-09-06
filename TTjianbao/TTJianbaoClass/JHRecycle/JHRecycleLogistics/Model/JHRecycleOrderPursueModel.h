//
//  JHRecycleOrderPursueModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderPursueModel : NSObject
/** 回收订单id*/
@property (nonatomic, copy) NSString *recycleOrderId;
/** 回收单节点 1、订单提交 2、回收商付款 3、商家发货 4、快递已揽收 5、回收商已收货 6、回收商已出价 7、卖家确认报价 8、申请寄回 9、申请销毁 10、申请仲裁 11、确认收货 12、取消订单 13、申请退货 14、退货快递小哥已收件 15、退货完成 16、退款完成*/
@property (nonatomic, assign) NSInteger recycleNode;
/** 回收单节点描述*/
@property (nonatomic, copy) NSString *recycleNodeDesc;
/** 回收节点说明*/
@property (nonatomic, copy) NSString *recycleNodeText;
/** 操作时间*/
@property (nonatomic, copy) NSString *optTime;
/** 是否是订单完成状态节点*/
@end

NS_ASSUME_NONNULL_END
