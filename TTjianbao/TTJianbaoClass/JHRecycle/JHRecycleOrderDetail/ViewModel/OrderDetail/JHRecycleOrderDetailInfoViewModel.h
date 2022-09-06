//
//  JHRecycleOrderDetailInfoViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-订单信息ViewModel

#import "JHRecycleOrderDetailBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailInfoViewModel : JHRecycleOrderDetailBaseViewModel
/// 标题
@property (nonatomic, copy) NSString *titleText;
/// 详情
@property (nonatomic, copy) NSString *detailText;
/// 是否显示复制按钮
@property (nonatomic, assign) BOOL isShowCopy;

@property (nonatomic, assign) BOOL isTopCell;
@property (nonatomic, assign) BOOL isBottomCell;
@end

NS_ASSUME_NONNULL_END
