//
//  JHBillDetailTableViewCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickBlock)(BOOL showAll);

@interface JHBillDetailTableViewCell : JHWBaseTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic,   copy) ClickBlock buttonBlock;
@property (nonatomic, assign) NSInteger  cellIndex;
@property (nonatomic, assign) BOOL       multiLine;// 多行

@end

NS_ASSUME_NONNULL_END

