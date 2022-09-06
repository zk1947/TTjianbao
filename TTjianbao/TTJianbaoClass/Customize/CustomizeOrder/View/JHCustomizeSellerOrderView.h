//
//  JHCustomizeSellerOrderView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderViewDelegate.h"
#import "BaseView.h"
#import "AdressMode.h"
#import "OrderMode.h"
#import "JHOrderDetailMode.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHOrderHeaderTitleView.h"
#import "JHCustomizeOrderModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JHCustomizeSellerOrderView : BaseView
@property(assign,nonatomic) BOOL  isSeller;
@property(strong,nonatomic)JHCustomizeOrderModel * orderMode;
@property(weak,nonatomic)id<JHOrderViewDelegate>delegate;
@property(strong,nonatomic)NSArray * friendAgentpayArr;
@property(strong,nonatomic)JHActionBlocks shareHandle;
@property(nonatomic,strong) UIView * contentScroll;
@property(nonatomic,strong) UIButton *chatBtn;
 @property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;
-(void)initBottomView;
@end

NS_ASSUME_NONNULL_END
