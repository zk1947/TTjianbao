//
//  JHChatCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessage.h"
#import "JHIMHeader.h"
#import "JHChatBaseCell.h"
NS_ASSUME_NONNULL_BEGIN
//typedef void(^ClickStateHandler)(JHMessage *message);
@class JHChatCell;
@protocol JHChatCellDelegate <NSObject>

- (void)didClickResend : (JHChatCell *)cell message : (JHMessage *)message;
- (void)didLongPress : (JHChatCell *)cell message : (JHMessage *)message;
- (void)didClickCell : (JHChatCell *)cell message : (JHMessage *)message;
- (void)didClickHead : (JHChatCell *)cell userId : (NSString *)userId;
@end

@interface JHChatCell : JHChatBaseCell
/// 头像
@property (nonatomic, strong) UIImageView *iconView;
/// 消息区
@property (nonatomic, strong) UIView *messageContent;
/// 已读状态
@property (nonatomic, strong) UILabel *readStateLabel;
/// 发送状态
@property (nonatomic, strong) UIButton *sendStateButton;
/// 发送进度
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) id<JHChatCellDelegate> delegate;
/// 点击回调
//@property (nonatomic, assign) ClickStateHandler *clickHandler;
/// 消息
@property (nonatomic, strong) JHMessage *message;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setupData;
- (void)setupSubUI;
- (void)layoutViews;
@end

NS_ASSUME_NONNULL_END
