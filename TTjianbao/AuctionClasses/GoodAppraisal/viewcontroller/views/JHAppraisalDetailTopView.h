//
//  JHAppraisalDetailTopView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/15.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHVideoPlayControlView.h"
@protocol JHVideoPlayControlViewProtocol;


#import "BaseView.h"

@interface JHAppraisalDetailTopView : BaseView

@property (nonatomic, weak) id<JHVideoPlayControlViewProtocol> delegate;
@property(assign,nonatomic)BOOL isLike;
@property(strong,nonatomic)AppraisalDetailMode* appraisalDetail;
@property(assign,nonatomic) float topImageAlpha;
@end

