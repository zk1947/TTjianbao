//
//  JHAlertTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///银联签约 - 提示信息的cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kJHAlertTableViewCellIdentifer = @"kJHAlertTableViewCellIdentifer";

@interface JHAlertTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *iconName;   ///需要显示的信息
@property (nonatomic, copy) NSString *message;   ///需要显示的信息


@end

NS_ASSUME_NONNULL_END
