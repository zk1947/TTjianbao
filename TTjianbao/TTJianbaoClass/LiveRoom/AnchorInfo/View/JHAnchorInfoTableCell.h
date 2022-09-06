//
//  JHAnchorInfoTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHAnchorInfo;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHAnchorEventType) {
    JHAnchorEventTypeSetPlay,
    JHAnchorEventTypeEdit,
    JHAnchorEventTypeDelete,
};

static NSString *const kAnchorInfoIdentifer = @"JHAnchorInfoTableCellIdentifer";

@interface JHAnchorInfoTableCell : UITableViewCell

///主播信息
@property (nonatomic, strong) JHAnchorInfo *anchorInfo;
@property (nonatomic, strong) NSIndexPath *indexPath;

///是否是本直播间主播
@property (nonatomic, assign) BOOL isAnchor;
@property (nonatomic, copy) void(^eventBlock)(NSInteger selectIndex,JHAnchorInfo *anchor, JHAnchorEventType eventType);




@end

NS_ASSUME_NONNULL_END
