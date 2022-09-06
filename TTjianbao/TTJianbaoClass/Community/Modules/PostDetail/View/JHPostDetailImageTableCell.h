//
//  JHPostDetailImageTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/9/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kJHPostDetailImageIdentifer = @"JHPostDetailImageIdentifer";


@interface JHPostDetailImageTableCell : UITableViewCell
///需要展示的详细信息
@property (nonatomic, copy) NSString *detailString;

@property (nonatomic, copy) void(^imageBlock)(NSArray *imageViews, NSIndexPath *selectIndexPath);
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
