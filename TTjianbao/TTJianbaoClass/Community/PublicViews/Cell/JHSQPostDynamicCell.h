//
//  JHSQPostDynamicCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  帖子列表cell：动态（文本+多图）
//

#import "JHSQBasePostCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPostDynamicCell : JHSQBasePostCell

@property (nonatomic, copy) void (^inputBarClickedBlock)(NSIndexPath *indexPath, JHPostData *data);

@end

NS_ASSUME_NONNULL_END
