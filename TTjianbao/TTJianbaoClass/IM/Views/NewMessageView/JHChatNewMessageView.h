//
//  JHChatNewMessageView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickHandler)(void);
@interface JHChatNewMessageView : UIView
@property (nonatomic, copy) ClickHandler clickHandler;
- (void)setupDataWithNum : (NSInteger) num;
@end

NS_ASSUME_NONNULL_END
