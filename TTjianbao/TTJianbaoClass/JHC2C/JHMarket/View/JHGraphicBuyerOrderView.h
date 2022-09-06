//
//  JHGraphicBuyerOrderView.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "AdressMode.h"
#import "OrderMode.h"
#import "JHOrderDetailMode.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHOrderHeaderTitleView.h"
#import "JHGraphiclOrderDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@interface JHGraphicBuyerOrderView : BaseView
@property(assign,nonatomic) BOOL  isSeller;
//@property(strong,nonatomic)OrderMode * orderMode;
@property(strong,nonatomic)JHOrderDetailMode *orderMode;
@property(weak,nonatomic)id<JHGraphiclOrderDelegate>delegate;
@property(strong,nonatomic)NSArray * friendAgentpayArr;
@property(strong,nonatomic)JHActionBlocks shareHandle;
@property(nonatomic,strong) UIView * contentScroll;
@property(nonatomic,strong) UIButton *chatBtn;
@property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;
-(void)initBottomView;
@end

NS_ASSUME_NONNULL_END
