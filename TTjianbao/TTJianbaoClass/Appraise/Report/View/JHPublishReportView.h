//
//  JHPublishReportView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBottomAnimationView.h"
#import "NTESMicConnector.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishReportView : JHBottomAnimationView

/// 显示鉴定报告填写页面
+ (void)showWithModel:(NTESMicConnector *)model controller:(UIViewController *)controller completeBlock:( void (^)(NSDictionary *data,NSString *appraiseRecordId))completeBlock;

@end

NS_ASSUME_NONNULL_END
