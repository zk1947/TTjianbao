//
//  JHMarketOrderViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketOrderViewController : JHBaseViewController <JXCategoryListContentViewDelegate>
/** 是否是买家*/
@property (nonatomic, assign) BOOL isBuyer;
@end

NS_ASSUME_NONNULL_END
