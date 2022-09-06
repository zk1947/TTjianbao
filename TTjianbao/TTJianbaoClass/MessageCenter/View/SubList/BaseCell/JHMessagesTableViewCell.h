//
//  JHMessagesTableViewCell.h
//  TTjianbao
//  Description:消息中心cell基类,统一设置背景样式
//  Created by Jesse on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMessagesTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView* backgroundsView;

//子类重写
- (void)updateData:(id)model;

- (void)changeCellStyle:(BOOL)isYES;

@end

NS_ASSUME_NONNULL_END
