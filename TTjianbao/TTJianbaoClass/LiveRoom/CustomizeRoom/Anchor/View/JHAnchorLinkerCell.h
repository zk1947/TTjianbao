//
//  JHAnchorLinkerCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTESMicConnector.h"
#import "BaseView.h"

@interface JHAnchorLinkerCell : BaseView
@property (nonatomic, strong) NTESMicConnector *model;
@property (nonatomic, assign) BOOL selected;
@end
