//
//  JHOrderConfirmView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressMode.h"
#import "OrderMode.h"
#import "JHStoneOfferModel.h"
#import "JHOrderDetailMode.h"
#import "PayMode.h"
#import "TTjianbaoMarcoEnum.h"
@protocol JHOrderConfirmViewDelegate <NSObject>

@optional
-(void)Complete:(JHOrderConfirmReqModel*)reqMode;
@end
#import "BaseView.h"

@interface JHOrderConfirmView : BaseView
@property(strong,nonatomic) JHOrderDetailMode* orderConfirmMode;

@property(strong,nonatomic) JHStoneIntentionInfoModel* intentionMode;
@property(strong,nonatomic) AdressMode * addressMode;
@property(weak,nonatomic)id<JHOrderConfirmViewDelegate>delegate;
@property(assign,nonatomic) BOOL activeConfirmOrder;
@property (nonatomic, copy) JHActionBlock goodsCountAction;

- (instancetype)initWithFrameForC2C:(CGRect)frame;

- (Boolean)isSelectedProtocol;

- (void)dispayMarketView;
//@property(copy,nonatomic)JHFinishBlock addressChooseAction;
@end

