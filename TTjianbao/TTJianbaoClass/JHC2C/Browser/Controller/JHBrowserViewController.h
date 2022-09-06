//
//  JHBrowserViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBrowserViewController : JHBaseViewController
@property (nonatomic, strong) NSArray<JHBrowserModel *> *dataSource;
@property (nonatomic, assign) NSInteger currentIndex;

+ (void)showBrowser : (NSArray<JHBrowserModel *> *)dataSource currentIndex : (NSInteger)currentIndex from : (UIViewController *)fromVc ;
@end

NS_ASSUME_NONNULL_END
