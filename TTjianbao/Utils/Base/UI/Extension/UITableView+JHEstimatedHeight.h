//
//  UITableView+JHEstimatedHeight.h
//  TTjianbao
//  Description:预估高问题
//  Created by Jesse on 2020/8/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *在iOS11以下版本调用
 * estimatedRowHeight
 * estimatedSectionHeaderHeight
 * estimatedSectionFooterHeight
 *的时候高度会返回负数，
 *所以在iOS11及以上版本再调用
 */
@interface UITableView (JHEstimatedHeight)

@end

NS_ASSUME_NONNULL_END
