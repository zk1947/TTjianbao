//
//  JHPostDetailVideoTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailResourceModel;

#define kPlayerViewTag 100

static NSString *const kPostDetailVideoIdentifer = @"JHPostDetailVideoTableCellIdentifer";

@interface JHPostDetailVideoTableCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *coverImageView;
@property (nonatomic, strong) JHPostDetailResourceModel *resourceModel;

@property (nonatomic, copy) void(^playCallback)(JHPostDetailVideoTableCell *videoCell);

@end

NS_ASSUME_NONNULL_END
