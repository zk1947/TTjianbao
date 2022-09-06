//
//  JHMainLiveRoomTabSubviewController.h
//  TTjianbao
//  Description:主播直播间tab子controller
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTableViewController.h"
#import "JHMainLiveRoomTabDataModel.h"


@protocol JHTableViewCellDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface JHMainLiveRoomTabSubviewController : JHTableViewController

@property (nonatomic, weak) id<JHTableViewCellDelegate> delegate;

- (instancetype)initWithPageType:(JHMainLiveRoomTabType)type channelId:(NSString*)mChannelId;
- (void)refreshPageBySearch:(NSString*)text;//搜索
- (void)callbackRefreshData;

@end

NS_ASSUME_NONNULL_END
