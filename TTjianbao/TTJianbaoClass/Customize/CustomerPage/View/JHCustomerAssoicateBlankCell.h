//
//  JHCustomerAssoicateBlankCell.h
//  TTjianbao
//
//  Created by lihui on 2020/11/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 定制师个人页 - 当店铺或者直播间没有数据 & 是定制师或者助理号时 显示的cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kAssoicateBlankIdentifer = @"kAssoicateBlankIdentifer";

@interface JHCustomerAssoicateBlankCell : UITableViewCell

- (void)configBlankCell:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
