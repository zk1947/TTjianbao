//
//  JHPersonInfoModel.h
//  TTjianbao
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 Netease. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface JHAllowSignModel : NSObject

/// 是否显示小红点
@property (nonatomic, assign) BOOL isCheckinAllowed;

/// 是否显示签到按钮
@property (nonatomic, assign) BOOL isCheckinButtonAllowed;

@end

@interface JHPersonInfoModel : NSObject

@end

NS_ASSUME_NONNULL_END
