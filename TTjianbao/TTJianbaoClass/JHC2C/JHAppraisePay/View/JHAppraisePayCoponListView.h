//
//  JHAppraisePayCoponListView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface JHAppraisePayCoponListView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
@property (nonatomic, assign) BOOL isAssistant;
@property (nonatomic, assign) BOOL isAndience;
@property (nonatomic, strong) JHActionBlock cellSelect;

-(void)setDataArr:(NSArray*)arr andDefaultSelecltIndex:(NSIndexPath*)indexPath;
@end
