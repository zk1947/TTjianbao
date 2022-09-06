//
//  JHLiveRoomListViewCell.h
//  TTjianbao
//
//  Created by 于岳 on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomListViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomListViewCell : UITableViewCell
@property(nonatomic,strong)JHLiveRoomListViewCellModel *model;
- (void)showBottomLine:(BOOL)isShow;
@end

NS_ASSUME_NONNULL_END
