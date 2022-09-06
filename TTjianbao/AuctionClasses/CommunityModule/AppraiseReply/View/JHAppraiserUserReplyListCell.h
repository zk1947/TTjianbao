//
//  JHAppraiserUserReplyListCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/5/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  鉴定贴回复 - 宝友回复列表cell
//

#import "YDBaseTableViewCell.h"

@class JHAppraiserUserReplyData;

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCellId_JHAppraiserUserReplyListCell = @"JHAppraiserUserReplyListCellIdentifier";

@interface JHAppraiserUserReplyListCell : YDBaseTableViewCell

@property (nonatomic, strong) JHAppraiserUserReplyData *curData;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
