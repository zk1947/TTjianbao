//
//  JHLiveRoomInfoTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHLiveRoomModel;

static CGFloat const roomDesHeight = 75.f;

static NSString *const kLiveRoomIdentifer = @"JHLiveRoomInfoTableCellIdentifer";

@interface JHLiveRoomInfoTableCell : UITableViewCell

@property (nonatomic, strong) JHLiveRoomModel *roomInfo;
@property (nonatomic, copy) void(^editBlock)(void);
@property (nonatomic, copy) void(^updateBlock)(CGFloat allHeight);

@end

NS_ASSUME_NONNULL_END
