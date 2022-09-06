//
//  JHOrderDetailView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/26.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

@protocol JHOrderDetailViewDelegate <NSObject>

@optional
-(void)buttonPress:(UIButton*)button;
@end
#import "BaseView.h"

@interface JHOrderDetailView : BaseView
@property(assign,nonatomic) BOOL  isSeller;
@property(strong,nonatomic)OrderMode * orderMode;
@property(strong,nonatomic)OrderMode * sellerOrderMode;
@property(weak,nonatomic)id<JHOrderDetailViewDelegate>delegate;
@property(strong,nonatomic)NSArray * friendAgentpayArr;
@property(strong,nonatomic)JHActionBlocks shareHandle;

@end


