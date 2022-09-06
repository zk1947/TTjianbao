//
//  JHGoodAppraisalCommentView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/4/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGestView.h"

@class AppraisalDetailMode;

typedef void (^HideCopleteBlock)(AppraisalDetailMode * mode);
@interface JHGoodAppraisalCommentView : JHGestView
@property(strong,nonatomic)HideCopleteBlock  hideCompleteBlock;
- (void)show;
- (void)dismiss;
- (void)loadData:(AppraisalDetailMode*)mode andShowCommentbar:(BOOL)isShow;
@end

