//
//  JHAudienceLiveTableViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/8/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomDetailView.h"
#import "JHAndienceInnerView.h"
#import "JHLiveRoomMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAudienceLiveTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong)  JHLiveRoomMode*channelMode;
@end

NS_ASSUME_NONNULL_END

