//
//  JHStoreDetailTagItemViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCellBaseViewModel.h"

static const CGFloat TagItemTitleTextFontSize = 10.0f;
static const CGFloat TagItemTitleLeftSpace = 6.0f;
static const CGFloat TagTtemHeight = 18.0f;
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailTagItemViewModel : JHStoreDetailCellBaseViewModel
@property (nonatomic, copy) NSString *titleText;
@end

NS_ASSUME_NONNULL_END
