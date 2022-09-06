//
//  JHSegmentView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/18.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^jh_indexBlock)(NSInteger index);
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSegmentView : BaseView
- (instancetype)initWithFrame:(CGRect)frame withVC:(UIViewController*)vc;
- (instancetype)initWithFrame:(CGRect)frame ViewControllersArr:(NSArray *)viewControllersArr TitleArr:(NSArray *)titleArr  ParentViewController:(UIViewController *)parentViewController ReturnIndexBlock: (jh_indexBlock)indexBlock ;
- (void)setSelectedItemAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
