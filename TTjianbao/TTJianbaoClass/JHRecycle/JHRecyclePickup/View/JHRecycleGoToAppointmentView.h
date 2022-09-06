//
//  JHRecycleGoToAppointmentView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressMode.h"
#import "JHRecyclePickupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleGoToAppointmentView : UIView
@property (nonatomic, strong) JHRecyclePickupAppointmentPickAddressModel *pickupAddressModel;//取件地址
@property (nonatomic, strong) AdressMode *addressModel;//取件地址
@property (nonatomic, strong) UILabel *nameLabel;//联系方式
@property (nonatomic, copy) NSString *startTime;//预约时间段
@property (nonatomic, copy) NSString *endTime;//预约时间段
//数据绑定
- (void)bindViewModel:(id)dataModel params:(NSDictionary* _Nullable )parmas;
@end

NS_ASSUME_NONNULL_END
