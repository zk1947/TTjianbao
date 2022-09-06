//
//  JHRecycleImageInfoTableViewCell.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  宝贝信息-图片

#import "JHRecycleDetailBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleImageInfoTableViewCell : JHRecycleDetailBaseTableViewCell
@property (nonatomic, copy) void(^selectImageBlack)(JHRecycleImageInfoTableViewCell *imageCell);

@end

NS_ASSUME_NONNULL_END
