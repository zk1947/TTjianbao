//
//  JHLivePlaySMallView
//  TTjianbao
//
//  Created by jiangchao on 2020/2/25.
//  Copyright © 2020年 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLivePlayer.h"
#import "ChannelMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHLivePlaySMallView : UIView
+ (instancetype)sharedInstance;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) ChannelMode*channelMode;
-(void)close;
@end

NS_ASSUME_NONNULL_END
