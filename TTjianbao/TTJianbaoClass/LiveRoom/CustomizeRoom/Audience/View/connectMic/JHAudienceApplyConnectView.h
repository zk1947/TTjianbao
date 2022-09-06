//
//  JHAudienceApplyConnectView.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMAVChat/NIMAVChat.h>

@class ChannelMode;
@protocol JHAudienceApplyConnectViewDelegate <NSObject>

- (void)addPhoto;
- (void)onComplete;

@end
typedef void(^completeBlock)(NSString *string);
@interface JHAudienceApplyConnectView : UIControl

@property (nonatomic, weak) id<JHAudienceApplyConnectViewDelegate> delegate;

@property (nonatomic, assign) NIMNetCallMediaType type;

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, strong) ChannelMode * channel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desWarningLabel;
@property (nonatomic, strong) UIButton *sureButton;
- (void)show;
- (void)showTags:(NSArray *)tags;
- (void)dismiss;
@property (nonatomic, strong) JHActionBlock completeBlock;
-(void)setCameraImage:(UIImage*)image;
- (void)setEndAppraise;

@end


