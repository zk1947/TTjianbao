//
//  JHShopInfoHeaderTableCell.h
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
///店铺信息 - 头部显示头像信息

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopInfoHeaderTableCell : JHWBaseTableViewCell
+ (CGFloat)cellHeight;
- (void)title:(NSString *)title desc:(NSString *)desc;
@end

NS_ASSUME_NONNULL_END
