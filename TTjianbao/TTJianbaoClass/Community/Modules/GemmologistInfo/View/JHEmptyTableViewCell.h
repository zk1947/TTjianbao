//
//  JHEmptyTableViewCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHEmptyTableViewCell : UITableViewCell
// 响应事件
@property (nonatomic, copy) void(^buttonClickActionBlock)(void);
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyLabel;
/** 响应按钮*/
@property (nonatomic, strong) UIButton *emptyButton;
@end

NS_ASSUME_NONNULL_END
