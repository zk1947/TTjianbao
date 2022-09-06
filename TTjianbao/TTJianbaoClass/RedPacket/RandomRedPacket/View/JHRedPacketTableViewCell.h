//
//  JHRedPacketTableViewCell.h
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHGetRedpacketModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 红包cell
@interface JHRedPacketTableViewCell : JHWBaseTableViewCell

@property (nonatomic, strong) JHGetRedpacketDetailModel *model;

- (CGFloat)viewSpace;

- (CGFloat)avatorHeight;


@end

NS_ASSUME_NONNULL_END
