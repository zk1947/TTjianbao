//
//  JHEvaluateReportViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/3/4.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHEvaluateReportViewController : JHBaseViewExtController
@property (nonatomic, copy) NSString *appraiseRecordId;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *from;

@end

NS_ASSUME_NONNULL_END
