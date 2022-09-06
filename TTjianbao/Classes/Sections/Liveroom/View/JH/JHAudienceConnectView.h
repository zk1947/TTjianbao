//
//  JHAudienceConnectView.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/15.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMAVChat/NIMAVChat.h>

@class ChannelMode;
@protocol JHAudienceConnectDelegate <NSObject>

- (void)onCancelConnect:(id)sender;
- (void)onBackSourceMall:(id)sender;
@end

@interface JHAudienceConnectView : UIControl

@property (nonatomic, weak) id<JHAudienceConnectDelegate> delegate;

@property (nonatomic, assign) NIMNetCallMediaType type;

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) ChannelMode * channel;
- (void)show;

- (void)dismiss;
-(void)setWaitNum:(NSInteger)waitNum andWaitTime:(float)time;
@end
