//
//  JHReporterCard.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecorderModel.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHReporterCard : BaseView
@property (nonatomic, strong) JHRecorderModel *model;
- (void)showAlert;
@end

NS_ASSUME_NONNULL_END
