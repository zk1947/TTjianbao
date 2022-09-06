//
//  JHRecycleSquareSelectTableCell.h
//  TTjianbao
//
//  Created by hao on 2021/7/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleSquareSelectTableCell : UITableViewCell
//数据绑定
- (void)bindViewModel:(id)dataModel params:(NSDictionary* _Nullable )parmas;

@end

NS_ASSUME_NONNULL_END
