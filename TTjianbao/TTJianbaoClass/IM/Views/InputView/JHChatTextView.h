//
//  JHChatTextView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^OnPasted)(void);
@interface JHChatTextView : UITextView
@property (nonatomic, copy) OnPasted pasted;
@end

NS_ASSUME_NONNULL_END
