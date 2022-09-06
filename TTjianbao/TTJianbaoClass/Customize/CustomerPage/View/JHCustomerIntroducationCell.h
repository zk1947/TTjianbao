//
//  JHCustomerIntroducationCell.h
//  TTjianbao
//
//  Created by lihui on 2020/9/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHLiveRoomModel;

@interface JHCustomerIntroducationCell : UITableViewCell
@property (nonatomic, assign) BOOL isRecycle;
@property (nonatomic, strong) JHLiveRoomModel *roomInfo;
@property (nonatomic, copy) void(^updateBlock)(CGFloat allHeight);

@end

NS_ASSUME_NONNULL_END
