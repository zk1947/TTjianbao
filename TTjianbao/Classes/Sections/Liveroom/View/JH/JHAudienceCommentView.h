//
//  JHGoodAppraisalCommentView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/4/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGestView.h"
#import "AppraisalDetailMode.h"

typedef void (^HideCopleteBlock)(AppraisalDetailMode * mode);

@class ChannelMode;
@interface JHAudienceCommentView : JHGestView
@property(strong,nonatomic)HideCopleteBlock  hideCompleteBlock;
- (void)show;
- (void)dismiss;
- (void)loadData:(ChannelMode*)mode andShowCommentbar:(BOOL)isShow;
@end



