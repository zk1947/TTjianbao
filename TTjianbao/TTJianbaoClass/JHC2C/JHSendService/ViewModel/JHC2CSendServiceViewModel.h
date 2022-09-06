//
//  JHC2CSendServiceViewModel.h
//  TTjianbao
//
//  Created by hao on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSendServiceViewModel : NSObject
///上门取件
@property (nonatomic, strong) RACCommand *pickupCommand;
@property (nonatomic, strong) RACSubject *pickupSubject;
///立即预约
@property (nonatomic, strong) RACCommand *appointmentSubmitCommand;
@property (nonatomic, strong) RACSubject *appointmentSubmitSubject;

///填写快递单号-获取快递logo
@property (nonatomic, strong) RACCommand *writeOrderCommand;
@property (nonatomic, strong) RACSubject *writeOrderSubject;
///填写快递单号-取消寄件
@property (nonatomic, strong) RACCommand *cancelMailingCommand;
@property (nonatomic, strong) RACSubject *cancelMailingSubject;
///填写快递单号-确认邮寄
@property (nonatomic, strong) RACCommand *confirmMailingCommand;
@property (nonatomic, strong) RACSubject *confirmMailingSubject;

///自助寄出
@property (nonatomic, strong) RACCommand *selfMailingCommand;
@property (nonatomic, strong) RACSubject *selfMailingSubject;
///确认自助寄出
@property (nonatomic, strong) RACCommand *confirmSelfMailingCommand;
@property (nonatomic, strong) RACSubject *confirmSelfMailingSubject;

@end

NS_ASSUME_NONNULL_END
