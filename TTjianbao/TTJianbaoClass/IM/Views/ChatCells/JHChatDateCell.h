//
//  JHChatDateCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHChatDateCell : UITableViewCell
/// 消息
@property (nonatomic, strong) JHMessage *message;

@end

NS_ASSUME_NONNULL_END
