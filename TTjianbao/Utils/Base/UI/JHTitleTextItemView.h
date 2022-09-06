//
//  JHTitleTextItemView.h
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTitleTextItemView : BaseView
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *actionBtn;
@property (assign, nonatomic) BOOL isCarryTwoDote;//textfield支持两位小数点

@property (strong, nonatomic) UIView *line;
- (instancetype)initWithTitle:(NSString *)title textPlace:(NSString *)placeHolder isEdit:(BOOL)isEdit isShowLine:(BOOL)isShowLine;

- (void)openClickActionRightArrowWithTarget:(id)target action:(SEL)action;

//正则表达式（只支持两位小数）
- (BOOL)isValid:(NSString*)checkStr;
@end

NS_ASSUME_NONNULL_END
