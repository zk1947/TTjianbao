//
//  JHDiscountCoponView.h
//  TTjianbao
//
//  Created by jiang on 2020/1/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"
@interface JHDiscountCoponListView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
@property (nonatomic, assign) BOOL isAssistant;
@property (nonatomic, assign) BOOL isAndience;
@property (nonatomic, strong) JHActionBlock cellSelect;

-(void)setDataArr:(NSArray*)arr andDefaultSelecltIndex:(NSIndexPath*)indexPath;
@end
