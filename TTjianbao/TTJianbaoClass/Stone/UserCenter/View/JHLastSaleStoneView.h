//
//  JHLastSaleStoneView.h
//  TTjianbao
//  Description:主播最近售出原石
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "JHLastSaleTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLastSaleStoneView : BaseView
@property (nonatomic, strong) NSString* channelCategory;// (string): 直播间类型：roughOrder-原石直播间、restoreStone-回血直播间 = ['NORMAL', 'ROUGH_ORDER', 'PROCESSING_ORDER', 'DAIGOU_ORDER', 'RESTORE'],
@property (nonatomic, assign) BOOL isAssitant;
- (void)drawSubviewsByPagetype:(JHLastSaleCellType)type channelId:(NSString*)mChannelId;
@end

NS_ASSUME_NONNULL_END
