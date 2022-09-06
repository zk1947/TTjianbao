//
//  JHArbitramentListCell.h
//  TTjianbao
//
//  Created by lihui on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
/// 带※的列表cell

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHArbitramentListCell : JHWBaseTableViewCell

@property (nonatomic, copy) void (^actionBlock)(void);

+ (CGFloat)cellHeight;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
