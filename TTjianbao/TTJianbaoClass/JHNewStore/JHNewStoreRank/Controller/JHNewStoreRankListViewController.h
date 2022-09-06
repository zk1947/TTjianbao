//
//  JHNewStoreRankListViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreRankListViewController : JHBaseViewController <JXCategoryListContentViewDelegate>
/** id*/
@property (nonatomic, copy) NSString *tagId;
@end

NS_ASSUME_NONNULL_END
