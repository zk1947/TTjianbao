//
//  JHMallRecommendViewController.h
//  TTjianbao
//  Description:推荐
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JHMallBaseViewController.h"
#import "JXPageListView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMallRecommendViewController : JHMallBaseViewController <JXCategoryListContentViewDelegate, JXPageListViewListDelegate>
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, copy)NSString *groupName;

- (void)scrollViewToListTop;

@end

NS_ASSUME_NONNULL_END
