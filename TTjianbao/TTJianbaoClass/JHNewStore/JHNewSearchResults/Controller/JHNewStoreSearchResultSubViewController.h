//
//  JHNewStoreSearchResultSubViewController.h
//  TTjianbao
//
//  Created by hao on 2021/8/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JXCategoryView.h"
#import "JHNewStoreSearchResultHeaderTagsView.h"
#import "JHNewStoreRecommendTagsView.h"
#import "JHNewSearchResultRecommendTagsModel.h"
#import "JHSearchViewController_NEW.h"
#import "JHSearchResultTopTextFieldView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreSearchResultSubViewControllerDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView titleTagIndex:(NSInteger)index isShowRecommendTagsView:(BOOL)isShow;

@end

@interface JHNewStoreSearchResultSubViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, weak) id<JHNewStoreSearchResultSubViewControllerDelegate> delegate;

///第几个标签 0全部, 1直播, 2一口价, 3拍卖, 4店铺, 5集市
@property (nonatomic, assign) NSInteger titleTagIndex;
///标签
@property (nonatomic,   copy) NSArray *titleArray;
///来源
@property (nonatomic, assign) JHSearchFromSource fromSource;

///搜索页：搜索字
@property (nonatomic,   copy) NSString *keyword;
///搜索页：来源
@property (nonatomic,   copy) NSString *keywordSource;
///分类页：分类id
@property (nonatomic, assign) NSInteger cateId;

@property (nonatomic, strong) JHSearchResultTopTextFieldView *searchTextfield;

///无数据说明
@property (nonatomic, strong) UILabel *nullDataLabel;

///重新加载子类数据
- (void)reloadSubViewData;

@end

NS_ASSUME_NONNULL_END
