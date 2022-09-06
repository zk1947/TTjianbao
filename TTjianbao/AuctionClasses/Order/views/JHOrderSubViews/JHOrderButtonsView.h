//
//  JHOrderButtonsView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderButtonsView : JHOrderSubBaseView
-(void)setupBuyerButtons:(NSArray*)buttonArr;
-(void)setupSellerButtons:(NSArray*)buttonArr;
-(void)setupGraphicalButtons:(NSArray*)buttonArr;
@property(strong,nonatomic)JHActionBlock buttonHandle;
@end

NS_ASSUME_NONNULL_END
