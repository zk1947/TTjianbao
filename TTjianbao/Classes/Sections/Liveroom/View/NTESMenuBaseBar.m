//
//  NTESMenuBaseBar.m
//  NTES_Live_Demo
//
//  Created by zhanggenning on 17/1/20.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#define UISreenHeightScale   ScreenH/667.0

#import "NTESMenuBaseBar.h"

@implementation NTESMenuBaseBar

- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = HEXCOLORA(0x0, .8f);
        
        self.selectedIndex = -1;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex != _selectedIndex)
    {
        _selectedIndex = selectedIndex;
        
        [self doSetSelectedIndex];
    }
}

#pragma mark - 子类重载
- (void)doSetSelectedIndex {};

- (CGFloat)barHeight
{
    return 110.0 * UISreenHeightScale;
}

@end
