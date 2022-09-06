//
//  JHFansTaskView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFansBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansTaskView : JHFansBaseView
- (void)show;
- (void)HideAlert;
@property (nonatomic, copy) JHActionBlock  TaskAction;
@property (nonatomic, copy) JHActionBlock  ruleAction;
@property (nonatomic, copy) NSString  *fansClubId;

@property (nonatomic, copy) NSString  *channelLocalID;
- (void)getFansClubInfo;

@end

NS_ASSUME_NONNULL_END
