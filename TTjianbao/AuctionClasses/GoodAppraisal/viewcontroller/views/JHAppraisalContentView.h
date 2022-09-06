//
//  JHAppraisalContentView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppraisalDetailMode;
@protocol JHAppraisalContentViewDelegate <NSObject>

@optional
- (void)pressCare:(UIButton*)button;
@end

#import "BaseView.h"

@interface JHAppraisalContentView : BaseView
@property(strong,nonatomic)UIView* contentView;
@property(strong,nonatomic)AppraisalDetailMode* appraisalDetail;
@property (nonatomic, weak) id<JHAppraisalContentViewDelegate> delegate;
@property(assign,nonatomic)BOOL isCare;
@end


