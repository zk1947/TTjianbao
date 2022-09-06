//
//  JHChatEmotionView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSticker.h"

NS_ASSUME_NONNULL_BEGIN
@class JHChatEmotionView;

@protocol JHChatEmotionKeyboardDelegate <NSObject>

- (void)emotionKeyboard:(JHChatEmotionView *)emotionKeyboard didClickEmoji:(PPEmoji *)emoji;
- (void)emotionKeyboardDidClickDeleteButton:(JHChatEmotionView *)emotionKeyboard;
- (void)emotionKeyboardDidClickSendButton:(JHChatEmotionView *)emotionKeyboard;

@end
@interface JHChatEmotionView : UIView

@property (nonatomic, weak) id<JHChatEmotionKeyboardDelegate> delegate;

- (CGFloat)heightThatFits;
@end

NS_ASSUME_NONNULL_END
