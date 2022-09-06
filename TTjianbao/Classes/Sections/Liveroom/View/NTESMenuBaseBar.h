//
//  NTESMenuBaseBar.h
//  NTES_Live_Demo
//
//  Created by zhanggenning on 17/1/20.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NTESMenuSelectBlock)(NSInteger index);

#import "BaseView.h"

@interface NTESMenuBaseBar : BaseView

@property (nonatomic, assign) NSInteger selectedIndex; //选择

@property (nonatomic, copy) NTESMenuSelectBlock selectBlock; //选择回调

#pragma mark - 子类重载
- (void)doSetSelectedIndex;

- (CGFloat) barHeight;

@end
