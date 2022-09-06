//
//  JHMarketPublishListViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketPublishListViewController : JHBaseViewController <JXCategoryListContentViewDelegate>
/** 0=出售中, 1=已下架*/
@property (nonatomic, copy) NSString *itemIndex;
@end

NS_ASSUME_NONNULL_END
