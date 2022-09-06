//
//  NTESLiveroomInfoView.h
//  TTjianbao
//  Description:直播间信息<头像...>
//  Created by chris on 16/4/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSDK/NIMSDK.h"
#import "NIMAvatarImageView.h"
@class ChannelMode;
@protocol JHLiveEndViewDelegate;

@interface NTESLiveroomInfoView : UIImageView

- (void)refreshWithChatroom:(NIMChatroom *)chatroom;
- (void)refreshWithChannel:(ChannelMode *)channel;
- (void)hiddenCareBtn;

@property (nonatomic,weak) id<JHLiveEndViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *platImage;
@property (nonatomic, strong) UIButton *careBtn;
//@property (nonatomic,strong) NIMAvatarImageView *avatar;
@property (nonatomic,strong) UIImageView *avatar;

@property (nonatomic,assign) BOOL isOpenFansClub; //是否开通粉丝团
@property (nonatomic,assign) BOOL isjoinFansClub; //是否加入粉丝团

- (void)updateStatus:(NSInteger)isfollow;
@end

