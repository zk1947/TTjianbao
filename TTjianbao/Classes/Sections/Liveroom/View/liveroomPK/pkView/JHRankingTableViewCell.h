//
//  JHRankingTableViewCell.h
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHLiveRoomPKInfoModel;
@interface JHRankingTableViewCell : UITableViewCell
-(void)resetCellView:(JHLiveRoomPKInfoModel *)model andIsIncrease:(BOOL)isIncrease;
@end

NS_ASSUME_NONNULL_END
