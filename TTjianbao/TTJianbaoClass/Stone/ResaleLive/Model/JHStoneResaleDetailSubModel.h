//
//  JHStoneResaleDetailSubModel.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHStoneOfferStatus) {
    JHStoneOfferStatusDefault,
    JHStoneOfferStatusInit = JHStoneOfferStatusDefault, //-初始化
    JHStoneOfferStatusOffering, //-出价中 =1 v =>出价中
    JHStoneOfferStatusWillOffer, //-待支付尾款 =2 v =>出价中
    JHStoneOfferStatusFinished, //-已成交
    JHStoneOfferStatusReject, //-已拒绝 =4 v
    JHStoneOfferStatusCancel, //-已取消
    JHStoneOfferStatusRefund, //-已退款
    JHStoneOfferStatusNotReplyTimeout, //-未回复超时失效 =7 v
    JHStoneOfferStatusNotOfferTimeout //-未支付尾款超时失效 =8 v
};

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneResaleDetailSubModel : NSObject

@property (nonatomic, strong) NSString* headImg;
@property (nonatomic, strong) NSString* name; //超过4个显示
@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSString* price;
@property (nonatomic, assign) NSUInteger offerStatus;

@end

NS_ASSUME_NONNULL_END
