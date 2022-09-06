//
//  JHRecyclePriceListController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePriceHistoryListController : JHBaseViewController <JXCategoryListContentViewDelegate>
/** 出价状态：0 待用户确认出价 1 中标 2 失效*/
@property (nonatomic, copy) NSString *bidStatus;
@end

NS_ASSUME_NONNULL_END
