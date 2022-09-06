//
//  YDBaseTitleBarController.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "YDBaseViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDBaseTitleBarController : YDBaseViewController <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) JXCategoryBaseView *categoryView; //基类titleBar
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView; //文本titleBar
@property (nonatomic, strong) JXCategoryIndicatorLineView *indicatorView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

///首选titleBar，默认 JXCategoryBaseView
- (JXCategoryBaseView *)preferredCategoryView;

///首选titleBar高度
- (CGFloat)preferredCategoryViewHeight;

@end

NS_ASSUME_NONNULL_END
