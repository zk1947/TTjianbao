//
//  JHMyPriceTableViewCell.h
//  TTjianbao
//  Description:我的出价
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneCommonTableViewCell.h"

#define kMyPriceTableCellHeight (182+10) //我的出价cell高度
#define kMyPriceTableCellRetainTimeHeight 22

NS_ASSUME_NONNULL_BEGIN

@interface JHMyPriceTableViewCell : JHStoneCommonTableViewCell

@property (nonatomic, strong) NSString* retainTimeText;

- (void)setCellThemeType:(JHCellThemeType)type;
@end

NS_ASSUME_NONNULL_END
