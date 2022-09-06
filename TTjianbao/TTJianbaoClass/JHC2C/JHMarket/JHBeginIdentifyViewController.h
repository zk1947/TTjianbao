//
//  JHBeginIdentifyViewController.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  开始鉴定

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const IdentifyFinishedNotificationName = @"IdentifyFinishedNotificationName";

@interface JHBeginIdentifyViewController : JHBaseViewController

@property(strong,nonatomic) NSString *taskId;
@property(strong,nonatomic) NSString *recordInfoId;

@end


NS_ASSUME_NONNULL_END
