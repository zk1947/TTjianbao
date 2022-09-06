//
//  JHSellerOrderView.h
//  TTjianbao
//
//  Created by jiang on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "AdressMode.h"
#import "OrderMode.h"
#import "JHOrderDetailMode.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoMarcoKeyword.h"
@protocol JHSellerOrderViewDelegate <NSObject>
@optional
-(void)buttonPress:(UIButton *_Nullable)button;
@end
NS_ASSUME_NONNULL_BEGIN
@interface JHSellerOrderView : BaseView
@property(assign,nonatomic) BOOL  isSeller;
//@property(strong,nonatomic)OrderMode * orderMode;
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
@property(weak,nonatomic)id<JHSellerOrderViewDelegate>delegate;
@property(strong,nonatomic)NSArray * friendAgentpayArr;
@property(strong,nonatomic)JHActionBlocks shareHandle;
@property(assign,nonatomic) BOOL  isProblem;
@property(nonatomic,strong) UIView * contentScroll;
@property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;
-(void)initBottomView;
@end

NS_ASSUME_NONNULL_END
