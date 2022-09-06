//
//  JHLinkerTableViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/12.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMicConnector.h"
#import "BaseView.h"

@interface JHLinkerTableViewCell : BaseView
@property (nonatomic, strong) NTESMicConnector *model;
@property (nonatomic, assign) BOOL selected;
@end

