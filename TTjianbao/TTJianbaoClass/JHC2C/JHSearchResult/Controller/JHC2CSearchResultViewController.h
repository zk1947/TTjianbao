//
//  JHC2CSearchResultViewController.h
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  搜索结果页

#import <UIKit/UIKit.h>
#import "ZQSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSearchResultViewController : JHBaseViewController

///带关键词来源的方法
- (void)refreshSearchResult:(NSString *)keyword from:(ZQSearchFrom)from keywordSource:(id<ZQSearchData>)keywordSource;

@end

NS_ASSUME_NONNULL_END
