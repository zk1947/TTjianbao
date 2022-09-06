//
//  JHOrderInfoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderInfoView : JHOrderSubBaseView
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
-(NSMutableArray*)handleOrderData:(JHOrderDetailMode*)mode;
-(NSMutableArray*)handleOrderData:(JHOrderDetailMode*)mode andTag:(Boolean)tag;
-(void)setupOrderInfo:(NSArray*)titles;
- (void)addTitleView;
@end

NS_ASSUME_NONNULL_END
