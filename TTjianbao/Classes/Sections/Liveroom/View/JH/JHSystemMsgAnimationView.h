//
//  JHSystemMsgAnimationView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/21.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSystemMsgAttachment.h"
#import "BaseView.h"

@interface JHSystemMsgAnimationView : BaseView
- (void)comeInActionWithModel:(JHSystemMsg *)model;
- (void)stopAndRemove;
-(void)cleanDataArr;

@end

@interface JHComeinAnimationView : BaseView
- (void)comeInActionWithModel:(JHSystemMsg *)model;
- (void)stopAndRemove;
-(void)cleanDataArr;

@end
