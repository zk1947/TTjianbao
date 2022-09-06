//
//  JHRecycleOrderDetailStatusDescribeViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-订单状态描述ViewModel

#import "JHRecycleOrderDetailBaseViewModel.h"
#import "NSAttributedString+YYText.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailStatusDescribeViewModel : JHRecycleOrderDetailBaseViewModel
/// 描述内容
@property (nonatomic, copy) NSString *describeText;
/// 描述内容-富文本
@property (nonatomic, copy) NSAttributedString *attDescribeText;
/// 倒计时时间
@property (nonatomic, assign) NSInteger countdownTime;

- (void)setupDataWithDesc : (NSString *) desc time : (NSInteger) time;
@end

NS_ASSUME_NONNULL_END
