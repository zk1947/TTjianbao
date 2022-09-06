//
//  JHLiveSearchResultVC.h
//  TTjianbao
//
//  Created by lihang on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveSearchResultVC : JHBaseListPlayerViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, copy)NSString *keyword;
///关键词来源
@property (nonatomic, copy) NSString *keywordSource;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
