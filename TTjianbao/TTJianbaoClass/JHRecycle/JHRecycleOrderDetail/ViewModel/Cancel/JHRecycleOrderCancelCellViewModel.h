//
//  JHRecycleOrderCancelCellViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBaseViewModel.h"
static const CGFloat CancelCellHeight = 50.f;
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderCancelCellViewModel : JHRecycleOrderDetailBaseViewModel
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
