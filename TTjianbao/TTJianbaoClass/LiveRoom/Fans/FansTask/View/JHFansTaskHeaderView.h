//
//  JHFansTaskHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFansClubModel.h"
#import "ChannelMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansTaskHeaderView : UIView

@property (nonatomic, strong) JHFansClubModel * fansClubModel;
@property (nonatomic, strong)  ChannelMode *channel;
@property (nonatomic, copy) JHActionBlock  ruleAction;

@property (nonatomic, copy) NSString  *channelLocalID;

@end

NS_ASSUME_NONNULL_END
