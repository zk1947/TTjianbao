//
//  JHNewStoreHomeViewController.h
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreHomeViewController : JHBaseViewExtController
@property (nonatomic, assign) BOOL cannotScroll;
- (void)subScrollViewDidScrollToTop;
- (void)tableBarSelect:(NSInteger)currentIndex;
@end

NS_ASSUME_NONNULL_END
