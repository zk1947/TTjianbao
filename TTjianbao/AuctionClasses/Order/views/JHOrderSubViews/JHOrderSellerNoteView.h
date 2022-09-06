//
//  JHOrderSellerNoteView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderSellerNoteView : JHOrderSubBaseView
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
-(void)initSellerNoteSubViews;

@property(strong,nonatomic)JHCustomizeOrderModel * customizeOrderMode;
-(void)initCustomizeSellerNoteSubViews;
@end

NS_ASSUME_NONNULL_END
