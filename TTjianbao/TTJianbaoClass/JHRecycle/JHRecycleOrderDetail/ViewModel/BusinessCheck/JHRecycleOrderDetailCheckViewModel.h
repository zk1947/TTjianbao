//
//  JHRecycleOrderDetailCheckViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-商家验证ViewModel

#import "JHRecycleOrderDetailBaseViewModel.h"
#import "JHRecycleOrderDetailModel.h"
#import "JHRecycleOrderToolbarViewModel.h"

static const NSUInteger RecycleOrderDescribeNumberOfLines = 3;

static const CGFloat RecycleOrderCheckToolbarTopSpace = 15.0f;
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailCheckViewModel : JHRecycleOrderDetailBaseViewModel
@property (nonatomic, strong) JHRecycleOrderToolbarViewModel *toolbarViewModel;
/// 描述内容
@property (nonatomic, copy) NSString *describeText;
/// 描述内容-富文本
@property (nonatomic, copy) NSAttributedString *attDescribeText;
/// 订单状态
@property (nonatomic, assign) JHRecycleOrderButtonInfo *buttonInfoModel;

- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo;
@end

NS_ASSUME_NONNULL_END
