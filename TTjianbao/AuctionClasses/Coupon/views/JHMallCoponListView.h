//
//  JHCouponListView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/3/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "BaseView.h"

@interface JHMallCoponListView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
@property (nonatomic, assign) BOOL isAssistant;
@property (nonatomic, assign) BOOL isAndience;
@property (nonatomic, strong) JHActionBlock cellSelect;

-(void)setDataArr:(NSArray*)arr andDefaultSelecltIndex:(NSIndexPath*)indexPath;
@end
