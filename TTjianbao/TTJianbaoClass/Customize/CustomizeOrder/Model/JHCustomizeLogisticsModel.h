//
//  JHCustomizeLogisticsModel.h
//  TTjianbao
//
//  Created by user on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCustomizeLogisticsUserExpressInfoModel;
@interface JHCustomizeLogisticsModel : NSObject
/// 用户发货信息
@property (nonatomic, strong) JHCustomizeLogisticsUserExpressInfoModel *userExpressInfo;
/// 用户发货标题
@property (nonatomic,   copy) NSString *userExpressTitle;
/// 用户收货时间
@property (nonatomic,   copy) NSString *userReceiveTime;
/// 用户发货时间
@property (nonatomic,   copy) NSString *userSendTime;


/// 平台发货信息
@property (nonatomic, strong) JHCustomizeLogisticsUserExpressInfoModel *platformExpressInfo;
/// 平台发货标题
@property (nonatomic,   copy) NSString *platformExpressTitle;
/// 平台收货时间
@property (nonatomic,   copy) NSString *platformReceiveTime;
/// 平台发货时间
@property (nonatomic,   copy) NSString *platformSendTime;


/// 商家发货信息
@property (nonatomic, strong) JHCustomizeLogisticsUserExpressInfoModel *sellerExpressInfo;
/// 商家发货标题
@property (nonatomic,   copy) NSString *sellerExpressTitle;
/// 商家收货时间
@property (nonatomic,   copy) NSString *sellerReceiveTime;
/// 商家发货时间
@property (nonatomic,   copy) NSString *sellerSendTime;
@end


@class JHCustomizeLogisticsDataModel;
@interface JHCustomizeLogisticsUserExpressInfoModel :NSObject
@property (nonatomic,   copy) NSString *message;
@property (nonatomic,   copy) NSString *ischeck;
@property (nonatomic,   copy) NSString *condition;
@property (nonatomic,   copy) NSString *nu;
@property (nonatomic,   copy) NSString *com;
@property (nonatomic,   copy) NSString *status;
@property (nonatomic,   copy) NSString *state;
@property (nonatomic, strong) NSArray<JHCustomizeLogisticsDataModel *> *data;
@end

@interface JHCustomizeLogisticsDataModel :NSObject
@property (nonatomic,   copy) NSString *time;
@property (nonatomic,   copy) NSString *ftime;
@property (nonatomic,   copy) NSString *context;
@end


@interface JHCustomizeLogisticsFinalModel :NSObject
@property (nonatomic, strong) NSArray *dataArr;
+ (NSArray<JHCustomizeLogisticsFinalModel *>*)setViewModelImpl:(JHCustomizeLogisticsModel *)model;

@end






NS_ASSUME_NONNULL_END
