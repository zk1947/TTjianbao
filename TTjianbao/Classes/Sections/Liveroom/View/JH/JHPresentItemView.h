//
//  JHPresentItemView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESPresent.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPresentItemView : BaseView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NTESPresent *model;
@end

NS_ASSUME_NONNULL_END
