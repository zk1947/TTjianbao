//
//  JHBreakPaperTableCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@class JHPreTitleLabel;

@interface JHBreakPaperTableCell : JHBaseTableViewCell
@property (nonatomic, strong)JHPreTitleLabel *paperNumLabel;
@property (nonatomic, strong)JHPreTitleLabel *priceLabel;
@property (nonatomic, strong)id model;

@end

NS_ASSUME_NONNULL_END
