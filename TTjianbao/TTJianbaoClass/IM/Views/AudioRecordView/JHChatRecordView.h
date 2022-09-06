//
//  JHChatRecordView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JHChatRecordViewTypeRecording,
    JHChatRecordViewTypeCancel,
} JHChatRecordViewType;

@interface JHChatRecordView : UIView
+ (void)showWithType : (JHChatRecordViewType)type;
+ (void)hide;
@end

NS_ASSUME_NONNULL_END
