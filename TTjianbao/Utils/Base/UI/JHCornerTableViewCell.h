//
//  JHCornerTableViewCell.h
//  TTjianbao
//  Description:圆角带背景cell
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRestoneTableViewCell.h"

#define kCellMargin 10.0

NS_ASSUME_NONNULL_BEGIN

@interface JHCornerTableViewCell : JHRestoneTableViewCell

@property (nonatomic, strong) UIView* background;
@end

NS_ASSUME_NONNULL_END
