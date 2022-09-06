//
//  JHNewStoreKillActivityTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/9/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHNewStoreHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreKillActivityTableViewCell : UITableViewCell
/// 0标题、1倒计时、2商品、3查看更多
@property (nonatomic, copy) void(^updateKillActivityCell) (NSInteger index, NSString *productId);
- (void)setViewModel:(JHNewStoreHomeKillActivityModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
