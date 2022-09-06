//
//  JHBlankPostTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///帖子列表中 原贴被删除时的布局cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPostData;

@interface JHBlankPostTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) JHPostData *postData;
@property (nonatomic, copy) void(^deleteBlock)(NSInteger index);


@end

NS_ASSUME_NONNULL_END
