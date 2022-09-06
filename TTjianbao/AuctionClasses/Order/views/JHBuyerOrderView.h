//
//  JHBuyerOrderView.h
//  TTjianbao
//
//  Created by jiang on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "AdressMode.h"
#import "OrderMode.h"
#import "JHOrderDetailMode.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHOrderHeaderTitleView.h"
@protocol JHBuyerOrderViewDelegate <NSObject>
@optional
-(void)buttonPress:(UIButton *_Nullable)button;
@end
NS_ASSUME_NONNULL_BEGIN
@interface JHBuyerOrderView : BaseView
@property(assign,nonatomic) BOOL  isSeller;
//@property(strong,nonatomic)OrderMode * orderMode;
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
@property(weak,nonatomic)id<JHBuyerOrderViewDelegate>delegate;
@property(strong,nonatomic)NSArray * friendAgentpayArr;
@property(strong,nonatomic)JHActionBlocks shareHandle;
@property(nonatomic,strong) UIView * contentScroll;
@property(nonatomic,strong) UIButton *chatBtn;
@property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;
-(void)initBottomView;
@property(strong,nonatomic) NSString *orderCategory;
@end

NS_ASSUME_NONNULL_END
