//
//  JHNewStoreGlobalSearchResultViewController.h
//  TTjianbao
//
//  Created by hao on 2021/8/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  全局搜索

#import "ZQSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreGlobalSearchResultViewController : JHBaseViewController
@property (nonatomic, copy) NSString *keyword;  ///关键字
@property (nonatomic, copy) NSString *keywordSource;

///带关键词来源的方法
- (void)refreshSearchResult:(NSString *)keyword from:(ZQSearchFrom)from keywordSource:(id<ZQSearchData>)keywordSource;
@end

NS_ASSUME_NONNULL_END
