//
//  BaseTitleBarController.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "UITitleBarBackgroundView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTitleBarController : JHBaseViewExtController <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) JXCategoryBaseView *categoryView; //基类titleBar
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView; //文本titleBar
@property (nonatomic, strong) UITitleBarBackgroundView *titleCategoryBgView; //cell带背景色的titleBar
@property (nonatomic, strong) JXCategoryIndicatorLineView *indicatorView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

///首选titleBar，默认 JXCategoryBaseView
- (JXCategoryBaseView *)preferredCategoryView;

///首选titleBar高度
- (CGFloat)preferredCategoryViewHeight;

@end

NS_ASSUME_NONNULL_END
