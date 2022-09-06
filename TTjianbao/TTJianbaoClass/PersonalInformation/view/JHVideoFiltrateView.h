//
//  JHVideoFiltrateView.h
//  TTjianbao
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHVideoFiltrateView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
@property (nonatomic, copy)JHActionBlocks handle;

@end

NS_ASSUME_NONNULL_END
