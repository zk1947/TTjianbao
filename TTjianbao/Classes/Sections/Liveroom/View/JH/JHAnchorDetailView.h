//
//  JHAnchorDetailView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/28.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAnchorInfoModel.h"
#import "BaseView.h"

@interface JHAnchorDetailView : BaseView
@property (nonatomic, strong) JHAnchorInfoModel *model;
- (void)setSaleAnchor;
@end
