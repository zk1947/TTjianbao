//
//  JHRedPacketAlertListView.h
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHRedPacketDetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 红包弹层list
@interface JHRedPacketAlertListView : BaseView

/// 领取成功 YES    失败NO
@property (nonatomic, assign) BOOL hasHeader;

@property (nonatomic, strong) JHRedPacketDetailViewModel *viewModel;

-(void)reloadViewData;
@end

NS_ASSUME_NONNULL_END
