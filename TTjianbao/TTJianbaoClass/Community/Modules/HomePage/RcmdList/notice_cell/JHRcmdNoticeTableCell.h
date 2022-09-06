//
//  JHRcmdNoticeTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/11/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///社区推荐页面 - 公告cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BannerCustomerModel;

static NSString *const kNoticeTableCellIdentifer = @"kNoticeTableCellIdentifer";

@interface JHRcmdNoticeTableCell : UITableViewCell

@property (nonatomic, assign) BOOL showLine;

@property (nonatomic, strong) BannerCustomerModel *noticeInfo;

@end

NS_ASSUME_NONNULL_END
