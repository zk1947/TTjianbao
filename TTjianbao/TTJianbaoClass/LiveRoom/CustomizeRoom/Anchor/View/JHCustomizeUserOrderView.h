//
//  JHCustomizeUserCardView.h
//  TTjianbao
//
//  Created by apple on 2020/9/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPopBaseView.h"
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JHCustomizeUserOrderType){
    JHCustomizeUserOrderTypeIntent, //意向单
    JHCustomizeUserOrderTypeSure,//定制单
    JHCustomizeUserOrderTypeIntentUser, //用户侧意向单
    JHCustomizeUserOrderTypeSureUser,//用户侧定制单
};
@interface JHCustomizeUserOrderView : JHPopBaseView
@property (nonatomic, assign) JHCustomizeUserOrderType orderType;
@property (nonatomic, copy) NSString *imageUrl;

//发送订单用
@property (nonatomic, copy) NSString *orderCategory;
@property (nonatomic, copy) NSString *anchorId;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *parentOrderId;

@property (nonatomic, strong) OrderMode *model;
@end

NS_ASSUME_NONNULL_END
