//
//  UITableView+JHEstimatedHeight.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UITableView+JHEstimatedHeight.h"

@implementation UITableView (JHEstimatedHeight)

+ (void)load
{
    Method estimatedHeightMethod = class_getInstanceMethod(self, @selector(setEstimatedRowHeight:));
    Method estimatedHeightExtMethod = class_getInstanceMethod(self, @selector(setEstimatedRowHeightExt:));
    method_exchangeImplementations(estimatedHeightMethod, estimatedHeightExtMethod);
        
    Method estimatedHeaderHeightMethod = class_getInstanceMethod(self, @selector(setEstimatedSectionHeaderHeight:));
    Method estimatedHeaderHeightExtMethod = class_getInstanceMethod(self, @selector(setEstimatedSectionHeaderHeightExt:));
    method_exchangeImplementations(estimatedHeaderHeightMethod, estimatedHeaderHeightExtMethod);
    
    Method estimatedFooterHeightMethod = class_getInstanceMethod(self, @selector(setEstimatedSectionFooterHeight:));
    Method estimatedFooterHeightExtMethod = class_getInstanceMethod(self, @selector(setEstimatedSectionFooterHeightExt:));
    method_exchangeImplementations(estimatedFooterHeightMethod, estimatedFooterHeightExtMethod);
}
//estimatedRowHeight
#pragma mark --- implement method
- (void)setEstimatedRowHeightExt:(CGFloat)estimatedRowHeight
{
    if(iOS(11))
    {
        [self setEstimatedRowHeightExt:estimatedRowHeight];
    }
}

- (void)setEstimatedSectionHeaderHeightExt:(CGFloat)estimatedSectionHeaderHeight
{
    if(iOS(11))
    {
        [self setEstimatedSectionHeaderHeightExt:estimatedSectionHeaderHeight];
    }
}

- (void)setEstimatedSectionFooterHeightExt:(CGFloat)estimatedSectionFooterHeight
{
    if(iOS(11))
    {
        [self setEstimatedSectionFooterHeightExt:estimatedSectionFooterHeight];
    }
}

@end
