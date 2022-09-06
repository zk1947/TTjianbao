//
//  JHRedPacketAlertView.h
//  TTjianbao
//
//  Created by apple on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAPPAlertBaseView.h"
#import "JHRoomRedPacketModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 红包弹层
@interface JHRedPacketAlertView : JHAPPAlertBaseView

/// 开红包 view
- (void)createOpenTypeUIWithModel:(JHRoomRedPacketModel *)model;

/// 开红包失败 view
- (void)createFailTypeUIWithModel:(JHRoomRedPacketModel *)model;

/// 显示红包弹框
+ (void)showWithModel:(JHRoomRedPacketModel *)sender;

@end

NS_ASSUME_NONNULL_END

/**
 使用说明
 JHRedPacketAlertView *alertView = [[JHRedPacketAlertView alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:alertView];
 [alertView createOpenTypeUIWithModel:model];
 [alertView showAlert];
 
 */
