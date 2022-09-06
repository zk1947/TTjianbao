//
//  JHOrderConfirmPayView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
#import "JHSwitch.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmPayView : JHOrderSubBaseView
//@property(nonatomic,strong)    UIView *mallCoponView;
//@property(nonatomic,strong)    UIView *coponView;
//@property(nonatomic,strong)    UIView *discountCoponView;
//@property (strong, nonatomic)  UILabel *mallDesc;
//@property (strong, nonatomic)  UILabel *desc;
//@property (strong, nonatomic)  UILabel *discountdDesc;
@property (strong, nonatomic)  UILabel *shoulPayPrice;
@property (strong, nonatomic)   UILabel *cashPacket;
@property(nonatomic,strong) UIView *cashPacketView;
@property (strong, nonatomic)   UITextField  *cash;
@property (strong, nonatomic)   JHSwitch *switchView;
@property(strong,nonatomic)JHOrderDetailMode * orderConfirmMode;
@property(strong,nonatomic)JHActionBlock mallCoponHandle;
@property(strong,nonatomic)JHActionBlock coponHandle;
@property(strong,nonatomic)JHActionBlock discountCoponHandle;
@property(strong,nonatomic)JHActionBlock switchViewHandle;
@property(strong,nonatomic)JHActionBlock cashEndEditingHandle;
-(void)initSubViews;
//-(void)hiddenCoponView;
-(void)updateBlanceView:(BOOL)isSwitch;
- (void)displayMarket;
- (void)auctionDisplayMarket;
@end

NS_ASSUME_NONNULL_END
