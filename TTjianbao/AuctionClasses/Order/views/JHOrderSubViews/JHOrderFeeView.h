//
//  JHOrderFeeView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderFeeView : JHOrderSubBaseView
-(void)initFeeSubViews:(NSArray*)titles;
-(void)initTaxesFeeSubViews:(NSArray*)titles;
-(void)initC2CTaxesFeeSubViews:(NSArray*)titles;
-(NSMutableArray *)handleFeeData:(JHOrderDetailMode*)mode;
-(NSMutableArray*)handleCustomizeFeeData:(JHOrderDetailMode*)mode;
-(NSMutableArray*)handleTaxesFeeData:(JHOrderDetailMode*)mode;
-(NSMutableArray*)handleC2CTaxesFeeData:(JHOrderDetailMode*)mode;
@property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;
@property(strong,nonatomic)JHActionBlock introducePressBlock;
@end

NS_ASSUME_NONNULL_END
