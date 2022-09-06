//
//  UITitleValueMoreCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  标题+可选内容
//

#import "YDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_UITitleValueMoreCell = @"UITitleValueMoreCellIdentifier";

@interface UITitleValueMoreCell : YDBaseTableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel, *valueLabel;

+ (CGFloat)cellHeight;

- (void)setTitle:(NSString *)title
           value:(NSString * _Nullable)value
     placeholder:(NSString * _Nullable)placeholder;

@end

NS_ASSUME_NONNULL_END
