//
//  JHIMHeader.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#ifndef JHIMHeader_h
#define JHIMHeader_h

#import <NIMSDK/NIMSDK.h>


static CGFloat const iconTop = 1.f;
static CGFloat const leftSpace = 12.f;
static CGFloat const iconWidth = 40.f;
static CGFloat const contentMaxWidth = 247.f;
static CGFloat const contentBottomSpace = 34.f;
static CGFloat const msgLabelFontSize = 15.f;
static CGFloat const contentInset = 10.f;
static CGFloat const IMTextMessagefontSize = 15.f;
static NSInteger const audioRecordMaxDuration = 60;


static NSInteger const PageSize = 20;

static NSString * const IsShowEvaluate = @"isShowEvaluate";

typedef enum : NSUInteger {
    /// 日期
    JHChatCustomTypeDate = 9000,
    /// 商品
    JHChatCustomTypeGoods = 9001,
    /// 订单
    JHChatCustomTypeOrder = 9002,
    /// 优惠券
    JHChatCustomTypeCoupon = 9003,
    /// 提示消息
    JHChatCustomTypeTip = 9004,
    
} JHChatCustomType;

typedef enum : NSUInteger {
    JHIMSourceTypeSessionCenter,
    JHIMSourceTypeGoodsDetail,
    JHIMSourceTypeOrderDetail,
    JHIMSourceTypeShop,
    JHIMSourceTypeLive,
    JHIMSourceTypeC2CGoodsDetail,
    JHIMSourceTypeC2COrderDetail,
} JHIMSourceType;
#endif /* JHIMHeader_h */
