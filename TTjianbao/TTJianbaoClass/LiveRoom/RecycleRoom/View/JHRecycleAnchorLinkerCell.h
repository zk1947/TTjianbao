//
//  JHRecycleAnchorLinkerCell.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTESMicConnector.h"
#import "BaseView.h"

@interface JHRecycleAnchorLinkerCell : BaseView
@property (nonatomic, strong) NTESMicConnector *model;
@property (nonatomic, assign) BOOL selected;
@end
