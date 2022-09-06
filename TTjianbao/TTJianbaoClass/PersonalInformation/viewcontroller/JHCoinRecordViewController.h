//
//  JHCoinRecordViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCoinRecordViewController : JHBaseViewExtController

/**
 0鉴豆记录 1送出礼物记录 2收到礼物记录
 */
@property (nonatomic, assign)NSInteger type;

@end

NS_ASSUME_NONNULL_END
