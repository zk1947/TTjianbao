//
//  JHMallWatchTrackCollectionViewCell.h
//  TTjianbao
//
//  Created by jiang on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMallWatchTrackCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) JHLiveRoomMode* liveRoomMode;
@property (nonatomic, copy) JHActionBlock buttonClick;

@property (nonatomic, assign) NSInteger cellIndex;
@end

NS_ASSUME_NONNULL_END
