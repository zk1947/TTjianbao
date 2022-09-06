//
//  JHReplyMessageView.h
//  TTjianbao
//
//  Created by apple on 2020/2/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChannelMode;

@interface JHReplyMessageView : UIView

@property (nonatomic, strong) NSNumber *roomRole;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) ChannelMode *channel;
/// 0-源头直播     1-在线直播
//-(instancetype)initWithType:(NSInteger)type  didSelectMessageBlock:(void(^)(NSString * message))selectMessageBlock;

/// 0-源头直播     1-在线直播
-(instancetype)initWithChannelModel:(ChannelMode*)channel;

-(void)moveArrowsLocation:(UIButton * )sender;

+(CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
