//
//  JHC2CSetPriceAlertView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailBusiness.h"

NS_ASSUME_NONNULL_BEGIN
@class JHC2CProoductDetailModel;
@class JHC2CAuctionRefershModel;

typedef NS_ENUM(NSInteger, JHC2CSetPriceAlertViewType){
    JHC2CSetPriceAlertView_First = 0,///
    JHC2CSetPriceAlertView_ChuJia,///
    JHC2CSetPriceAlertView_SetDelegate,///
} ;

@interface JHC2CSetPriceAlertView : UIView

@property(nonatomic) BOOL  fromB2C;

/// 是否代理 1代理   0不是代理
@property(nonatomic, assign) NSInteger  isAgent;
@property(nonatomic) JHC2CSetPriceAlertViewType type;
@property(nonatomic, strong) JHC2CProoductDetailModel * model;
@property(nonatomic, strong) JHC2CAuctionRefershModel * auModel;


@property(nonatomic, copy) NSString * productSnB2C;
@property(nonatomic, strong) JHB2CAuctionRefershModel * auModelB2C;

@property(nonatomic, copy) NSString * productID;
- (void)refresWithType:(JHC2CSetPriceAlertViewType)type;

@end

NS_ASSUME_NONNULL_END
