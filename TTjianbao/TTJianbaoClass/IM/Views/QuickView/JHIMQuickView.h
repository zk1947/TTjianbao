//
//  JHIMQuickView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  快捷回复

#import <UIKit/UIKit.h>
#import "JHIMQuickModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^QuickHandler)(JHIMQuickModel *model);
@interface JHIMQuickView : UIView
@property (nonatomic, strong) NSArray<JHIMQuickModel *> *dataSource;
@property (nonatomic, copy) QuickHandler handler;
@end

NS_ASSUME_NONNULL_END
