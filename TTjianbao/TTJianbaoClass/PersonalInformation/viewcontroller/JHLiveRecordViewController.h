//
//  JHLiveRecordViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/17.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRecordViewController : JHBaseViewExtController

/**
 0 观众获取自己的
 1 主播获取自己的
 */
@property (nonatomic, assign) NSInteger roleType;

- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
