//
//  JHAuctionOrderConfirmView.h
//  TTjianbao
//
//  Created by zk on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "AdressMode.h"
#import "OrderMode.h"
#import "JHStoneOfferModel.h"
#import "JHOrderDetailMode.h"
#import "PayMode.h"
#import "TTjianbaoMarcoEnum.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHOrderConfirmViewDelegate <NSObject>

@optional
-(void)Complete:(JHOrderConfirmReqModel*)reqMode;
@end

@interface JHAuctionOrderConfirmView : BaseView

@property(strong,nonatomic) JHOrderDetailMode* orderConfirmMode;

@property(strong,nonatomic) JHStoneIntentionInfoModel* intentionMode;
@property(strong,nonatomic) AdressMode * addressMode;
@property(weak,nonatomic)id<JHOrderConfirmViewDelegate>delegate;
@property(assign,nonatomic) BOOL activeConfirmOrder;
@property (nonatomic, copy) JHActionBlock goodsCountAction;

- (Boolean)isSelectedProtocol;

- (void)dispayMarketView;

@end

NS_ASSUME_NONNULL_END
