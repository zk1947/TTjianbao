//
//  JHRefreshNormalFooter.h
//  TTjianbao
//
//  Created by jiangchao on 2019/6/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRefreshNormalFooter : MJRefreshAutoNormalFooter

- (void)showStateTitle:(NSString*)title state:(MJRefreshState)state hidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
