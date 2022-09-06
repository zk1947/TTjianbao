//
//  JHRecycleOrderDetailArbitrationViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-申请仲裁ViewModel

#import "JHRecycleOrderDetailBaseViewModel.h"
#import "JHRecycleOrderToolbarViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailArbitrationViewModel : JHRecycleOrderDetailBaseViewModel
@property (nonatomic, strong) JHRecycleOrderToolbarViewModel *toolbarViewModel;
/// 描述内容
@property (nonatomic, copy) NSString *describeText;
/// 描述内容-富文本
@property (nonatomic, copy) NSAttributedString *attDescribeText;

@property (nonatomic, copy) NSString *price;

- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo;
@end

NS_ASSUME_NONNULL_END
