//
//  JHVideoPlayViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NELivePlayerViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHAppraisalDetailViewController : NELivePlayerViewController

/**
 1排行榜 2鉴定记录 3订单 4我的j鉴定记录
 */
@property (nonatomic, assign) NSInteger from;
@property (nonatomic, strong) NSString* appraiseId;

- (instancetype)initWithAppraisalId:(NSString *)appraisalId ;
@end

NS_ASSUME_NONNULL_END
