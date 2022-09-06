//
//  JHOrderDeductionView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderDeductionView : JHOrderSubBaseView
-(void)initDeductionSubViews:(NSArray*)titles;
-(NSMutableArray *)handleDeductionwData:(JHOrderDetailMode*)mode;
-(NSMutableArray *)handleProcessDeductionwData:(JHOrderDetailMode*)mode;
@property(strong,nonatomic) NSString *orderCategory;
@end

NS_ASSUME_NONNULL_END
