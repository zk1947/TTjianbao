//
//  JHInfoLivingTableCell.h
//  TTjianbao
//  Description:直播间左侧>直播介绍+主播介绍> header即.直播介绍
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHInfoLivingTableCell : UITableViewCell

@property (nonatomic, copy) JHActionBlock actionBlock;

- (void)updateData:(NSString*)txt roleType:(NSInteger)roleType;
@end

