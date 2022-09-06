//
//  JHIdentificationDetailsVC.h
//  TTjianbao
//
//  Created by miao on 2021/6/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentificationDetailsVC : JHBaseViewController

/// 创建鉴定的详情
/// @param recordInfoId  图文信息鉴定id
- (instancetype)initWithRecordInfoId:(NSInteger)recordInfoId;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
