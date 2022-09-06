//
//  JHNewStoreSearchResultViewController.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  商品搜索页

#import "JHNewStoreTypeModel.h"
#import "JHSearchViewController_NEW.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreSearchResultViewController : JHBaseViewController
///搜索词（必传）
@property (nonatomic,   copy) NSString *searchWord;
///搜索词来源
@property (nonatomic,   copy) NSString *searchSource;
///页面来源
@property (nonatomic, assign) JHSearchFromSource fromSource;
///分类ID
@property (nonatomic, assign) NSInteger cateId;
///搜索占位词
@property (nonatomic,   copy) NSString *searchPlaceholder;

@end

NS_ASSUME_NONNULL_END
