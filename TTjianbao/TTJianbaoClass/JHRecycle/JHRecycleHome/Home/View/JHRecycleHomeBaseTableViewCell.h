//
//  JHRecycleHomeBaseTableViewCell.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleHomeBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) JHRecycleHomeModel *recycleHomeModel;
@property (nonatomic, strong) RACSubject *loginSuccessSubject;
//数据绑定
- (void)bindViewModel:(id)dataModel;
@end

NS_ASSUME_NONNULL_END
