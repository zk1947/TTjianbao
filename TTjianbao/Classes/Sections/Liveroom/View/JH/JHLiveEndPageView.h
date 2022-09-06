//
//  JHLiveEndPageView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/10.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSDK/NIMSDK.h"

@class ChannelMode;
@protocol JHLiveEndViewDelegate <NSObject>
@optional
- (void)didPressBackButton;
- (void)didPressCareOffButton:(UIButton *)btn;
- (void)didPressAnchorView:(ChannelMode *)mode ;
- (void)gotoLivingRoom;
/**
 点击直播间主播头像 进入主播主页
 @param member 主播model
 */
- (void)didPressAnchorAvatar:(NIMChatroomMember *)member;
@end

#import "JHAnchorInfoModel.h"

#import "BaseView.h"

@interface JHLiveEndPageView : BaseView
@property (nonatomic, strong) NIMChatroomMember *member;
@property (nonatomic, strong) JHAnchorInfoModel *model;
@property (nonatomic,weak) id<JHLiveEndViewDelegate> delegate;
-(void)setupRecommendAnchourView:(NSArray *)channels;

- (void)forbidLiveWithReason:(NSString *)reason;

@end
