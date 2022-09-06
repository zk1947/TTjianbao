//
//  JHRecycleOrderDetailBaseCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-BaseCell

#import <UIKit/UIKit.h>
#import "JHRecycleOrderDetail.h"
#import "JHRecycleOrderDetailBaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailBaseCell : UITableViewCell
/// 内部自定义视图
@property (nonatomic, strong) UIImageView *content;

///
- (void)setupCornerRadiusWithRect : (RecycleOrderDetailCornerType) rectCorner;
- (RecycleOrderDetailCornerType)getCornerTypeWithValue : (NSInteger)value;
@end

NS_ASSUME_NONNULL_END
