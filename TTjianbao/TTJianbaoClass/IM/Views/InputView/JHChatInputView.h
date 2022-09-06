//
//  JHChatInputView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessage.h"
#import "JHChatMediaModel.h"
#import "JHChatMediaView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol JHChatInputViewDelegate <NSObject>
@optional

- (void)sendTextMessage : (JHMessage *)message;

- (void)startRecordAudio;
- (void)stopRecordAudio;
- (void)cancelledRecordAudio;
- (void)changeRecordCancel : (BOOL)isCancel;
@end

@interface JHChatInputView : UIView

@property (nonatomic, weak) id<JHChatInputViewDelegate> delegate;
@property (nonatomic, strong) RACSubject *viewFrameChanged;
/// 多媒体页（工具）
@property (nonatomic, strong) JHChatMediaView *mediaView;
/// 设置多媒体项
- (void)setupMedias : (NSArray<JHChatMediaModel *> *)mediaList;
- (void)setEditText : (NSString *)text;
- (void)hideKeyboard;
- (void)hideLine;
@end

NS_ASSUME_NONNULL_END
