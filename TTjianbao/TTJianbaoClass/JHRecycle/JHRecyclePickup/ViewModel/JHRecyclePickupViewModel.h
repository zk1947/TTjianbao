//
//  JHRecyclePickupViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePickupViewModel : NSObject
//未预约
@property (nonatomic, strong) RACCommand *goToAppointmentCommand;
@property (nonatomic, strong) RACSubject *goToAppointmentSubject;

//立即预约
@property (nonatomic, strong) RACCommand *appointmentSubmitCommand;
@property (nonatomic, strong) RACSubject *appointmentSubmitSubject;

//已预约
@property (nonatomic, strong) RACCommand *appointmentSuccessCommand;
@property (nonatomic, strong) RACSubject *appointSuccessSubject;


@end

NS_ASSUME_NONNULL_END
