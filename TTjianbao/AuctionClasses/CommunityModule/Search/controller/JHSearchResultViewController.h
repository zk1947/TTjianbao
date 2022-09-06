//
//  JHSearchResultViewController.h
//  TTjianbao
//
//  Created by mac on 2019/6/18.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "BaseTitleBarController.h"
#import "ZQSearchViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSearchResultViewController : BaseTitleBarController

///带关键词来源的方法
- (void)refreshSearchResult:(NSString *)keyword from:(ZQSearchFrom)from keywordSource:(id<ZQSearchData>)keywordSource;

@end

NS_ASSUME_NONNULL_END
