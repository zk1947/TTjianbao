//
//  JHSQPostVideoCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  帖子列表cell：短视频
//

#import "JHSQBasePostCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPostVideoCell : JHSQBasePostCell

@property (nonatomic, copy) void (^enterDetailBlock)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
