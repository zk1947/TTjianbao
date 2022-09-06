//
//  JHNewStoreHomeGoodsCagetoryView.h
//  TTjianbao
//
//  Created by user on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryTitleView.h"
@class JHNewStoreHomeGoodsCagetoryView;
NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreHomeListCategoryDataSource <NSObject>
@optional
//有固定标签时categoryView的标题会隐藏，显示遮罩的标题，这里需要返回实际标题的宽度
- (CGFloat)newStoreListCategory:(JHNewStoreHomeGoodsCagetoryView *)categoryView forIndex:(NSInteger)index;
@end


@interface JHNewStoreHomeGoodsCagetoryView : JXCategoryTitleView
@property (nonatomic, copy) void(^didScrollCallBack)(UIScrollView *scrollView);
@property (nonatomic, weak) id<JHNewStoreHomeListCategoryDataSource> categoryDataSource;
@end

NS_ASSUME_NONNULL_END
