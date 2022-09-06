//
//  JHMyCenterViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMyCenterDotModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterViewModel : NSObject

@property (nonatomic, strong) JHMyCenterDotModel *dotModel;

/// 扫一扫
- (void)scanAction;

@end

NS_ASSUME_NONNULL_END
