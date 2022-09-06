//
//  UITitleInputCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  标题+输入框
//

#import "YDBaseTableViewCell.h"
#import "UIInputTextField.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_UITitleInputCell = @"UITitleInputCellIdentifier";

@interface UITitleInputCell : YDBaseTableViewCell

@property (nonatomic, copy) void(^textValueChangedBlock)(NSString *text);

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIInputTextField *textField;

+ (CGFloat)cellHeight;

- (void)setTitle:(NSString *)title
           value:(NSString * _Nullable)value
     placeholder:(NSString * _Nullable)placeholder;

@end

NS_ASSUME_NONNULL_END
