//
//  JHStoreHomeListCategoryView.h
//  TTjianbao
//
//  Created by wuyd on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  特卖商城 标签导航栏
//

#import "JXCategoryTitleView.h"
@class JHStoreHomeListCategoryView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - dataSource
@protocol JHStoreHomeListCategoryDataSource <NSObject>
@optional
//有固定标签时categoryView的标题会隐藏，显示遮罩的标题，这里需要返回实际标题的宽度
- (CGFloat)homeListCategory:(JHStoreHomeListCategoryView *)categoryView forIndex:(NSInteger)index;
@end


#pragma mark - JHStoreHomeListCategoryView
@interface JHStoreHomeListCategoryView : JXCategoryTitleView

@property (nonatomic, copy) void(^didScrollCallBack)(UIScrollView *scrollView);

@property (nonatomic, weak) id<JHStoreHomeListCategoryDataSource> categoryDataSource;

@end

NS_ASSUME_NONNULL_END
