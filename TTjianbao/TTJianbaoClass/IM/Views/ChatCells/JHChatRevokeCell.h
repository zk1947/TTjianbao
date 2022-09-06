//
//  JHChatRevokeCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessage.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^EditEvent)(JHMessage *message);
@interface JHChatRevokeCell : UITableViewCell
@property (nonatomic, copy) EditEvent editEvent;
/// 消息
@property (nonatomic, strong) JHMessage *message;
@end

NS_ASSUME_NONNULL_END
