//
//  JHLiveRoomDetailView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/28.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAnchorDetailView.h"
#import "User.h"
#import "NTESAudienceLiveViewController.h"
@interface JHLiveRoomDetailView : UIScrollView
@property (nonatomic, strong)JHAnchorDetailView *anchorDetailView;
@property (nonatomic, assign) BOOL  isOpenGesture;
@property (nonatomic, copy)JHActionBlock scaleActionBlock;

- (void)setLiveRoomAnchorInfoModel:(JHAnchorInfoModel *)model roleType:(NSInteger)type;
- (void)setLiveRoomEventData:(NSDictionary*)dict roleType:(JHAudienceUserRoleType)type;
@end
