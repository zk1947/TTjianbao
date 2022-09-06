//
//  JHMallWatchTrackTableViewCell.h
//  TTjianbao
//
//  Created by jiang on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMallWatchTrackTableViewCell : UICollectionViewCell
@property(nonatomic,strong) NSMutableArray<JHLiveRoomMode *> * watchTrackModes;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
