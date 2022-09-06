//
//  JHOrderBuyerNoteView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderBuyerNoteView : JHOrderSubBaseView
-(void)initBuyerNoteSubViews:(JHOrderDetailMode*)mode;
-(void)initCustomizeBuyerNoteSubViews:(JHCustomizeOrderModel*)mode;
@end

NS_ASSUME_NONNULL_END
