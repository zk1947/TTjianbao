//
//  JHHotListTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/6/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHPostData;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kHotListCellIdentifer = @"JHHotListTableViewCellIdentifer";

@interface JHHotListTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic, strong) JHPostData *postData;

@property (nonatomic, assign) NSInteger sortNum;

@end

NS_ASSUME_NONNULL_END
