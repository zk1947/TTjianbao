//
//  JHChatBaseCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHChatBaseCell : UITableViewCell
@property (nonatomic, strong) RACSubject *clickSubject;
@end

NS_ASSUME_NONNULL_END
