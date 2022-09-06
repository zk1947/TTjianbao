//
//  JHInfoAnchorTableCell.h
//  TTjianbao
//  Description:直播间左侧>直播介绍+主播介绍 cell
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomIntroduceModel.h"

typedef NS_ENUM(NSUInteger, JHCornerType)
{
    JHCornerTypeNone,
    JHCornerTypeTop,
    JHCornerTypeBottom,
    JHCornerTypeAll
};

NS_ASSUME_NONNULL_BEGIN

@interface JHInfoAnchorTableCell : UITableViewCell

- (void)updateData:(JHLiveRoomAnchorInfoModel*)info cornerType:(JHCornerType)type roleType:(NSInteger)roleType;
@end

NS_ASSUME_NONNULL_END
