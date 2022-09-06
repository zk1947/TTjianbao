//
//  JHPlateSelectCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseTableViewCell.h"

@class JHPlateSelectData;

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateSelectCell : YDBaseTableViewCell

@property (nonatomic, strong) JHPlateSelectData *curData;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
