//
//  JHRecycleLogisticsModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface JHRecycleLogisticsListModel : NSObject
/** 描述*/
@property (nonatomic, copy) NSString *context;
/** 时间*/
@property (nonatomic, copy) NSString *ftime;
@end

@interface JHRecycleLogisticsModel : NSObject
/** id*/
@property (nonatomic, copy) NSString *logisticsId;
/** 快递公司*/
@property (nonatomic, copy) NSString *com;
/** 订单号*/
@property (nonatomic, copy) NSString *nu;
/** 签收状态*/
@property (nonatomic, copy) NSString *status;
/** 列表*/
@property (nonatomic, strong) NSArray <JHRecycleLogisticsListModel *>*data;
@end

NS_ASSUME_NONNULL_END
