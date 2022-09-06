//
//  JHBaseControlView.h
//  TTjianbao
//
//  Created by yaoyao on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "ZFPlayerMediaControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseControlView : BaseView <ZFPlayerMediaControl>

///双击点赞事件
@property (nonatomic, copy) void(^doubleTapBack)(void);
/// 点击事件
@property (nonatomic, copy) void(^singleTapBack)(void);

@end

NS_ASSUME_NONNULL_END
