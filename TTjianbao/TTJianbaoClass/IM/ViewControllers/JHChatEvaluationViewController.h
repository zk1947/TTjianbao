//
//  JHChatEvaluationViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  用户评价

#import <UIKit/UIKit.h>
#import "JHChatEvaluationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHChatEvaluationViewController : UIViewController

@property (nonatomic, strong) RACSubject<JHChatEvaluationModel *> *submitSubject;

@end

NS_ASSUME_NONNULL_END
